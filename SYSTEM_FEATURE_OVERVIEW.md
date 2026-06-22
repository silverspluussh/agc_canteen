# AGC Canteen — System Feature Overview

## 1. Executive Summary

AGC Canteen is a **local-first, offline-capable Android POS (Point of Sale)** system for corporate/industrial canteens. It runs on dedicated handheld POS terminals and integrates with **fingerprint biometrics**, **smart card (NFC/PSAM) readers**, and **thermal receipt printers**. Data syncs bidirectionally with a remote REST API, ensuring the system functions seamlessly without internet connectivity.

---

## 2. Core Features

### 2.1 Fingerprint-Based Staff Authentication
- Staff scan their fingerprint on the POS terminal to identify themselves
- Biometric templates (Base64-encoded ISO templates) are stored locally in SQLite and pushed to a remote HR endpoint
- Supports enrollment of up to **5 fingers per staff** (thumb, index, middle, ring, little)
- Matching uses a configurable threshold (default score ≥ 80)
- Hardware integration via native Android MethodChannel

### 2.2 Time-Gated Meal Ordering
- Meal types (breakfast, lunch, dinner, midnight, snack, beverage, à la carte) have defined **time windows** (beginTime/endTime in 24h format, e.g. `16:00:00`–`22:00:00` for dinner)
- The POS grid automatically filters to show only meals belonging to **currently active** meal types
- Time windows re-evaluate every 30 seconds, so the available meal list updates as the day progresses
- Prevents ordering outside of designated meal periods

### 2.3 Meal Selection & Ordering
- Visual meal grid with images (cached), names, and prices
- Search/filter by meal name or meal type
- **Dine-in / Takeout** toggle on the confirmation screen
- À la carte meals require a mandatory description before ordering
- One-click order confirmation with automatic receipt printing

### 2.4 Duplicate Detection (Overcharge Logging)
- If a staff member orders the **same meal type twice in one day**, the system still allows it but logs an **overcharge** entry
- Provides an audit trail for compliance and reporting

### 2.5 Receipt Printing
- Dual printer support: **inbuilt POS thermal printer** and **external thermal printer**
- ESC/POS formatted receipts with bold/centered text, line items, order code, date/time, and total
- Automatic paper cut after printing

### 2.6 Group Orders (Admin)
- Admins can create **group/bulk orders** from the settings screen
- Specify total group size, then add multiple meals with individual quantities
- Automatic validation that quantity sum matches the declared group count
- Separate sync endpoint (`/pos/order/create-group`)

### 2.7 Manual Order Entry (Admin)
- Admin-only screen to create orders for any staff member
- Can override meal type, choose any available meal
- Useful for walk-in staff or when fingerprint hardware is unavailable

---

## 3. Unique / Differentiating Functionalities

### 3.1 Multi-Layered Authentication Architecture
| Layer | Method | Purpose |
|---|---|---|
| **Admin Login** | Email + Password + OTP (2FA) | Admin access to settings, reports, sync |
| **Admin PIN** | 6-digit PIN from `.env` | Quick admin access from the staff auth screen without full login |
| **Staff Auth** | Fingerprint biometric | Staff identification for meal ordering |
| **Offline Login** | SHA-256 hashed credentials | Admin can log in without internet |

### 3.2 Local-First Offline Architecture
- **Complete SQLite database** with 15 tables mirroring the remote schema
- All CRUD operations work offline
- Sync status tracking per record (unsynced, syncing, synced, failed)
- On reconnect: push local changes, pull remote changes, clean up stale records

### 3.3 Intelligent Bidirectional Sync
Two independent sync services run in parallel:

| Service | Direction | Scope |
|---|---|---|
| `SyncService` | Push + Pull | All tables (orders, staff, meals, etc.) |
| `RemoteDataSyncService` | Pull-only | Reference data (meals, menu types, staff, biometrics, POS profile) |

- **Push:** POSTs unsynced records to `/api/sync/{table}`
- **Pull:** GETs remote changes with `since` timestamps for incremental sync
- **Bulk order sync:** Batches individual orders into a single POST to `/pos/order/create-bulk`
- **Cleanup:** Deletes locally-synced records whose IDs are absent from the remote set (source-of-truth enforcement)
- **Preservation:** Meal types synced via nested meal data do not overwrite existing `beginTime`/`endTime` unless the incoming payload explicitly includes them

### 3.4 Smart Card / NFC / PSAM Integration
- **ISO 7816-4 APDU** command support (SELECT FILE, READ BINARY, UPDATE BINARY, VERIFY PIN, GET RESPONSE)
- **PSAM (Secure Access Module)** with multi-slot support for secure transactions
- **Magnetic swipe** support
- Dedicated **Card Test** debug screen for hardware diagnostics and raw APDU testing
- Native Android MethodChannel integration

### 3.5 Order Code System
- Auto-generated sequential order codes: **ASG0001, ASG0002, ...**
- Shared counter across both individual orders and group orders
- Highest existing code detected from both `orders` and `group_orders` tables

### 3.6 POS Device Identity & Kitchen Scoping
- Device profile fetched from remote `/pos/profiles` based on device model/MAC address
- Each POS device is assigned to a **kitchen**
- Meals, staff, and biometric data are automatically scoped to the device's kitchen (`kitchenId` query parameter)
- Device information gathered: model, manufacturer, RAM, disk, MAC address, Android SDK version

### 3.7 Activity Logging & Audit Trail
- Every significant action is logged: admin login/logout, staff auth success/failure, fingerprint enrollment/deletion, order placement, sync events, language/theme changes
- Actor type, ID, and name tracked per log entry
- Metadata stored as JSON for rich context

---

## 4. System Architecture

### 4.1 Technology Stack
| Component | Technology |
|---|---|
| Framework | Flutter 3.x (Dart) |
| State Management | Riverpod |
| Dependency Injection | get_it |
| Local Database | Drift ORM (SQLite) |
| HTTP Client | Dio |
| Secure Storage | flutter_secure_storage |
| Localization | intl (EN, FR, ES) |
| Printing | ESC/POS utils |
| Biometrics | Native Android MethodChannel |
| Card Reader | Native Android MethodChannel (ISO 7816) |
| Theming | adaptive_theme (Light/Dark/System) |

### 4.2 Database Schema (15 Tables)

**Reference Data:** `sites`, `kitchens`, `menu_types`, `meal_types`, `meals`, `meal_kitchens`, `staff`, `users`, `user_kitchens`, `pos_devices`, `bio_data_entries`

**Transaction Data:** `orders`, `order_items`, `group_orders`, `group_order_items`, `overcharges`

**Audit:** `activity_logs`

Key relationships:
- `Meals` ↔ `Kitchens` (M:N via `meal_kitchens`)
- `Orders` → `Staff` (FK)
- `Orders` → `OrderItems` (1:N)
- `BioDataEntries` → `Staff` (FK)

All tables (except `activity_logs`) have `syncStatus` and `syncUpdatedAt` columns for sync tracking.

### 4.3 Navigation & Screen Flow

```
App Start → AuthGate
  ├─ Admin Login → OTP → Settings → Sync / Reports / Staff / Manual Order / Card Test
  └─ Staff Auth (Fingerprint) → POS Page → Confirm Order → Receipt
       └─ Admin PIN (6-digit) → Settings (quick access)
```

---

## 5. Multi-Language Support
- **3 languages:** English, French, Spanish
- Generated from `.arb` files via `flutter_localizations`
- Language persisted in SharedPreferences
- Switcher available on both POS and Settings pages

---

## 6. Companion App: Canteen Staff Enrollment
A sibling Flutter app (`canteen_staff_enrollment/`) handles **bulk staff enrollment** — fingerprint registration, staff bio-data entry, and NFC card assignment. It shares the same service layer architecture and is under active development.
