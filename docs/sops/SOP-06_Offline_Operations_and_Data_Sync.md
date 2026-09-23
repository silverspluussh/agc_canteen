# SOP-06: Offline Mode & Data Synchronization

| Document ID | SOP-06 |
|:---|:---|
| **Title** | Offline Mode & Data Synchronization Protocol |
| **Category** | Data Management & Network Operations |
| **Target Roles** | POS Cashier, Canteen Supervisor, IT Support |
| **Effective Version** | AGC Canteen POS v0.1.0+ |

---

## 1. Purpose & Scope
This Standard Operating Procedure governs the synchronization of data between local POS SQLite storage and the central AGC cloud server. It defines protocols for offline meal issuance, pending data uploads, and remote master data downloads.

---

## 2. Prerequisites & Equipment
* POS Terminal with pending local records or updated central records.
* Available Wi-Fi or 4G LTE cellular connection (for online sync phases).

---

## 3. Step-by-Step Procedure

### Step 3.1: Offline Resilient Operation Protocol
1. If network connectivity is lost during peak canteen hours, **continue all voucher and manual order operations without interruption**.
2. The POS system operates in local offline mode:
   * Biometric verification executes against local SQLite biometric templates.
   * New orders and bio enrollments are flagged with `sync_status = 0 (Pending)`.
   * Receipts print normally.

### Step 3.2: Upload Synchronization (Terminal → Server)
*Perform at the end of each shift or once network connectivity is restored.*
1. Log in to the terminal as **Admin** or **Supervisor**.
2. Navigate to **Settings → Data Synchronization**.
3. Select the **Upload Tab**.
4. Review pending transaction counts:
   * **Staff Orders:** Pending voucher and manual orders.
   * **BioData:** Biometric templates enrolled on this terminal.
5. Tap **Sync All** (or tap individual entity upload).
6. The system dispatches data in chunks (~50 orders per batch) respecting the 60s network timeout.
7. Confirm that pending counters drop to 0 and records update to `sync_status = 2 (Synced)`.

### Step 3.3: Download Synchronization (Server → Terminal)
*Perform before the morning shift start or upon notification of HR staff updates.*
1. On the **Data Synchronization** screen, switch to the **Download Tab**.
2. Tap **Download All** to fetch the latest central records:
   * **Staff:** Active staff directory for this kitchen.
   * **Meal Types:** Updated meal pricing and menus.
   * **BioData:** Biometric templates registered across all network terminals.
   * **Visitors & Contractors:** Temporary dining permissions.
   * **Dependents:** Family meal entitlements.
   * **Shifts:** Updated shift hours and dining windows.
3. System applies conflict resolution: remote data wins, local records are upserted, and fully synced stale records are automatically cleaned up.

---

## 4. Verification & Acceptance Criteria
* [ ] Upload tab shows 0 pending orders after completion of upload sync.
* [ ] Download tab increments record counts without throwing database lock exceptions.
* [ ] No duplicate order records or template collisions created during sync.

---

## 5. Exception Handling & Troubleshooting
* **Failed Sync Status (`sync_status = 3`):**
  * If individual orders fail server validation (e.g., duplicate sequence or server busy), records remain locally with status `3`. Tap **Retry Sync** or check internet stability.
* **Overlapping Sync Guard:**
  * If a sync is already in progress, the UI disables sync buttons to prevent race conditions. Wait for current batch to complete.
* **Large Bio Upload Hang:**
  * Bio upload is capped with a 60s timeout to prevent infinite socket freezes. If timeout occurs, retry with a stronger Wi-Fi signal.
