# Fingerprint Auth Performance — Tier 1 Plan

Status: Tier 1 complete (Phases 1–4) + configurable threshold (Phase A)
Scope: `agc_canteen` (Flutter POS)
Owner: _
Last updated: 2026-10-12

## Problem

Fingerprint authentication is an O(N) loop: `FingerprintAuthService.authenticate`
loads every active bio-data row and calls the native `verify` **once per stored
template**, sequentially, re-reading and re-decoding the table on every tap
(`lib/services/auth/fingerprint_auth_service.dart:189-231` →
`android/.../FingerprintPlugin.kt:325`).

With up to 10 fingerprints per person and single-order scans allowed without a
department, a tap can scan thousands of templates and make thousands of
MethodChannel round-trips per scan — multi-second latency.

### Volumes (per POS, ≤50% of aggregate, typically a single category)

| Terminal | People | Templates @1 | @5 | @10 |
|---|---|---|---|---|
| Contractor POS | ~500 | 500 | 2,500 | 5,000 |
| Staff POS | ~250 | 250 | 1,250 | 2,500 |
| Absolute worst | ~825 | 825 | 4,125 | 8,250 |

## Goals

- Predictable sub-second fingerprint taps at the volumes above.
- Correct department-scoped matching for every entity category.
- No change to enrollment, no backfill, no SDK 1:N work, threshold stays 80.

## Decisions (locked)

- Department selection is **mandatory** for every scan (single and group).
- `contractor` / `visitor` / `dependent` are scoped like everyone else, resolved
  from their parent entity — **without changing enrollment**.
- No backfill of existing rows.
- Add composite index `bio_data_entries(department_id, is_active)`.
- Add a template cache.
- Match threshold stays **80**; early-accept stays **95**.

## Open confirmation

- **Cross-department rule:** scoping means a person whose resolved department
  does not match the selected department will not match. Confirm this is the
  intended product behaviour (each person maps to exactly one department the
  operator selects).

---

## Phase 1 — Mandatory department scoping

**Status:** done.

**Objective:** a scan cannot start without a resolved department.

**Deliverables**
- Single-order scan (fingerprint + NFC) requires a department; group order
  already enforces this.
- If >1 department exists and none is selected: disable scan buttons and prompt
  for selection.
- `authenticate(departmentId:)` / `readCard(departmentId:)` never receive null
  from the UI.
- A single-department terminal auto-resolves, so the operator never has to pick.

**Files**
- `lib/views/auth/single_auth_pos.dart` (resolution + gated buttons + prompt).
- `lib/views/auth/scan_department.dart` (pure `resolveScanDepartmentId` rule).
- `test/unit/views/scan_department_test.dart`.

**Steps**
1. Change `_effectiveDepartmentId` so it no longer returns null on a
   multi-department terminal without a selection.
2. Gate the scan/scan-NFC buttons on a non-null resolved department; show a
   "Select a department" prompt/disabled state otherwise.
3. Ensure the resolved id is threaded to both auth entry points.

**Benefits**
- Bounds N to one department — the largest single reduction.
- Removes the unscoped "scan everyone" path for single orders.
- Consistent single/group operator flow.

**Tests**
- Widget: scan disabled until a department is selected.
- Call-site: auth is never invoked with a null department through the UI.

**Dependencies:** none.
**Acceptance:** no scan can be initiated without a department; buttons reflect
the requirement.

---

## Phase 2 — Resolve department by parent entity

**Status:** done.

**Objective:** derive a template's department from the person, not from
`bio_data.departmentId`.

**Deliverables**
- Resolver mapping an active bio-data row to a department:
  - staffType → `staff.departmentId`
  - contractor → `contractorStaffTable.departmentId`
  - visitor → `visitors.departmentId`
  - dependent → parent's department (staff or contractor via
    `staffId` / `contractorStaffId`)
- Bulk-load the entity maps once, resolve in memory (O(rows), not per-lookup).

**Files**
- `lib/services/database/app_database.dart` (`activeBioDataDepartments`,
  `getActiveBioDataForDepartment`, bulk-load helpers).
- `lib/services/auth/fingerprint_auth_service.dart` (`authenticate` scopes via
  the resolver instead of the stored column).
- `test/unit/services/database/bio_data_department_resolution_test.dart`.

**Steps**
1. Add bulk-load helpers for staff / contractor / visitor / dependent
   department maps.
2. Add a resolver that maps each active bio-data row to a department.
3. Route the scoped query/cache through the resolver instead of
   `bio_data.departmentId`.

**Benefits**
- Mandatory scoping becomes correct for every category, including
  locally-enrolled contractor/visitor/dependent rows stored with a null
  department (`fingerprint_auth_service.dart:117`).
- Removes dependence on the server populating `bio_data.departmentId`.
- Fixes the group-order recall hole with no enrollment change.

**Tests**
- Per-category resolution, including a null-department local row.
- Dependent → parent resolution (staff and contractor parents).

**Dependencies:** Phase 1 consumes it.
**Acceptance:** every active template resolves to a department for every
category without touching enrollment.

---

## Phase 3 — In-memory template cache

**Status:** done.

**Objective:** stop re-reading and re-materializing the whole active set on
every tap.

**Deliverables**
- Cache of active templates grouped by resolved department, built once from the
  DB and held in memory.
- `authenticate` reads the cache for the selected department.
- Invalidation after each bio-data pull and after local enrollment.
- Composite index `bio_data_entries(department_id, is_active)`.

**Files**
- `lib/services/auth/fingerprint_template_cache.dart` (new cache class).
- `lib/services/auth/fingerprint_auth_service.dart` (read from cache;
  invalidate on enroll).
- `lib/services/sync_services/sync_from_remote_to_local.dart` (invalidate after
  every pull run).
- `lib/services/database/app_database.dart` (`_createPerformanceIndexes`).
- `lib/core/di/injection_container.dart` (shared cache singleton).
- `test/unit/services/auth/fingerprint_template_cache_test.dart`,
  `test/unit/services/sync/template_cache_invalidation_test.dart`.

**Steps**
1. Build the cache from active bio-data + Phase 2 resolution, partitioned by
   department.
2. Switch `authenticate` to the cache (matching logic unchanged: best score,
   threshold 80, early-accept 95).
3. Invalidate/rebuild after bio-data pull and local enrollment.
4. Add the composite index.

**Benefits**
- Removes the per-tap DB read and re-materialization of every active row.
- Stable, precomputed department partitions — prerequisite for Phase 4.
- Matching semantics unchanged.

**Tests**
- Cache contents match the resolved department.
- Invalidation after sync and after enrollment.
- Guard when no department is resolved.

**Dependencies:** Phase 2.
**Acceptance:** a tap performs no per-tap full-table read; cache reflects the
latest synced/enrolled data.

---

## Phase 4 — Native `verifyBatch`

**Status:** done.

**Objective:** replace N MethodChannel round-trips with a single call.

**Deliverables**
- Native `verifyBatch(templates)` that loops `compareTemplateBytes` and returns
  the best id/score in one result.
- Dart `PosFingerprintService.verifyBatch`.
- `authenticate` calls `verifyBatch` once per tap using the Phase 3 cache.

**Files**
- `android/app/src/main/kotlin/com/silverware/agc_canteen/plugins/FingerprintPlugin.kt`
  (`verifyBatch` method + `verifyBatchFingerprint`).
- `lib/services/pos/pos_fingerprint_service.dart` (`FingerprintMatch`,
  `verifyBatch`).
- `lib/services/auth/fingerprint_auth_service.dart` (single batch call + timing
  log).
- `test/unit/services/auth/fingerprint_auth_batch_test.dart`.

**Steps**
1. Add `verifyBatch` to the plugin, iterating `compareTemplateBytes` internally
   and returning the best matching index + score.
2. Expose it in `PosFingerprintService`.
3. Use the cached department set to call it once per tap; keep threshold 80 and
   early-accept 95 applied to the returned best score.

**Benefits**
- Collapses N channel round-trips (the dominant cost) into one.
- Keeps the compare loop in fast native code; no SDK change, no threshold
  change.
- Multi-second taps become tens of milliseconds even for large departments.

**Tests**
- Dart unit: best-match selection against a fake batch API.
- On-device instrumented timing.
- Verified the Kotlin plugin compiles (`:app:compileDebugKotlin`).

**Dependencies:** Phase 3 (feeds the set).
**Acceptance:** a tap issues a single native compare call and returns the same
match a per-template loop would.

---

## Cross-cutting

- **Instrumentation** (Phase 3/4): log scoped-template count and total auth
  duration per tap, and near-threshold scores, for on-device validation.
- Leave enrollment, backfill, per-person caps, and SDK 1:N untouched.

### Phase A — Configurable match threshold (done)

The accept threshold is now operator-configurable, default 80 (unchanged
behaviour at default).

- `lib/services/auth/fingerprint_auth_service.dart`: `defaultMatchThreshold` =
  80, `matchThresholdPrefsKey` = `finger_match_threshold`; `authenticate`
  resolves the configured value (falls back to 80 when unset/out of range).
- `lib/controllers/auth_settings_controller.dart`: `fingerMatchThreshold` on
  `AuthSettings` with load/set.
- `lib/views/settings/settings_page.dart`: a threshold dropdown (70–95) under
  Authentication when fingerprint is enabled; out-of-set stored values fall
  back to 80.
- Tests: `fingerprint_auth_batch_test.dart` (configured higher/lower threshold),
  `test/unit/controllers/auth_settings_controller_test.dart`.

### Phase B — Best−secondBest margin (deferred, contingency only)

Only worth building if field score data shows near-threshold ambiguity: return
`secondScore` from `verifyBatch` and accept only when
`best >= threshold && best - second >= margin` (margin default 0 = disabled).

## Deferred (not in Tier 1)

- Best−secondBest margin (Phase B) — pending real-device score data.
- Composite `orders(ordered_by_id, employee_type, created_at)` index.
- Batching oversized `NOT IN` purges.

## Net outcome

Scoping bounds N → resolution makes it correct for all categories → cache
removes per-tap DB work → batch verify removes per-template overhead. Result:
predictable sub-second taps at the stated volumes with no enrollment or server
changes.
