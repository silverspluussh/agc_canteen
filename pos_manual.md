# AGC Canteen POS System — User Manual

## Table of Contents

1. [Overview](#overview)
2. [System Setup](#system-setup)
3. [Authentication](#authentication)
4. [POS Operations](#pos-operations)
5. [Staff & Fingerprint Enrollment](#staff--fingerprint-enrollment)
6. [Data Synchronization](#data-synchronization)
7. [Reports](#reports)
8. [Settings](#settings)
9. [Troubleshooting](#troubleshooting)

---

## Overview

The AGC Canteen POS System is an Android-based Point of Sale application designed to manage canteen operations for AGC. It supports:

- **Fingerprint-based staff authentication** for meal eligibility verification
- **Manual order placement** for staff without fingerprints (admin PIN fallback)
- **Individual and group order processing** with real-time receipt printing
- **Remote data synchronization** — pulls staff, meal types, bio-data, visitors, shifts, dependents, and contractor staff from the central server
- **Offline-first operation** — orders and fingerprint enrollments work without internet and sync when connectivity returns
- **NFC card scanning** for staff identification
- **Staff management** with fingerprint enrollment/deactivation

---

## System Setup

### Initial Device Setup

1. **Launch the app** — The splash screen initializes the fingerprint hardware and POS device SDK automatically.
2. **Select POS Profile** — On first launch, a POS device selection dialog appears. Choose your registered POS device from the list. This links the device to its assigned kitchen and determines which staff are available.
3. **Verify Connectivity** — Ensure the device has an active internet connection for the initial data pull. The system will automatically:
   - Fetch staff records for your assigned kitchen
   - Download meal types and pricing
   - Pull existing biometric (fingerprint) data
   - Sync visitors, shifts, dependents, and contractor staff

### Printer Setup

Navigate to **Settings → Printer Settings**.

- **Built-in** — uses the POS terminal's internal thermal printer (HFPos SDK). No pairing needed; tap **Test print** to verify.
- **External** — connect a separate USB or Bluetooth thermal printer:
  - **USB**: plug in the printer, tap **Scan**, then **Connect** on the detected device.
  - **Bluetooth**: tap **Scan in app** first — this discovers nearby printers and attempts to pair automatically. If your POS unit blocks in-app pairing (common on some handheld models), tap **Bluetooth settings** to pair the printer from Android's system settings, then return to the app and tap the **Refresh** icon next to "Paired devices" to pick it up. Either way, tap **Connect** on the paired device to finish.
  - Once connected, tap **Test print** to confirm the printer outputs a receipt.
- If you switch to **External** before a device is connected, the app shows a message and keeps using the previous printer type until you connect one.

---

## Authentication

### Fingerprint Authentication (Primary)

The default authentication method for staff meal redemption.

1. Staff member places their enrolled finger on the scanner sensor.
2. The system matches the fingerprint against locally stored templates.
3. If a match is found (confidence score ≥ 80), the staff record is retrieved.
4. If the staff is assigned to the POS kitchen, authentication succeeds and a meal voucher order is automatically placed.
5. A printed receipt confirms the order.

**Failure reasons displayed:**
- **Not Enrolled** — No matching fingerprint found locally.
- **Not in Kitchen** — Staff fingerprint matched but they are not assigned to this POS kitchen.

### Admin PIN Authentication (Fallback)

Used when fingerprint authentication is unavailable or for staff without enrolled fingerprints.

1. On the staff auth screen, select **"Use PIN"**.
2. Enter the staff's employee ID and PIN.
3. System looks up the staff and proceeds with order placement if found in the assigned kitchen.

### Admin Login

Administrators log in via the **Admin Login** screen with their email/phone and password. Admins can access:

- Staff Management
- Reports
- Settings
- Data Synchronization
- Fingerprint Enrollment

---

## POS Operations

### Placing a Manual Order

Used for walk-in or non-standard orders (à la carte).

1. Authenticate a staff member via fingerprint or PIN.
2. On the **Manual Order** screen:
   - Select a **meal type** from the available options (breakfast, lunch, etc.)
   - Optionally add a **description** (e.g., special request)
   - Choose **single** or **group** order (group orders repeat the order N times)
3. Tap **Place Order** to confirm.
4. A receipt prints for each order.

### Voucher Orders (Automatic)

Voucher orders are automatically generated upon successful fingerprint authentication. The system:

1. Determines the current meal type based on the time of day.
2. Places a single order for the authenticated staff member.
3. Prints a voucher receipt with order code and timestamp.

### NFC Card Orders

Staff can also be identified by scanning an NFC card. The flow is identical to fingerprint authentication — scan the card, and the system looks up the associated staff record.

---

## Staff & Fingerprint Enrollment

### Registering a Fingerprint

1. Navigate to **Settings → Staff Management**.
2. Find the staff member in the list (search by name, employee ID, or filter by kitchen/department).
3. Tap the staff member to open their bio-data page.
4. Tap **"+ Enroll Fingerprint"**.
5. Select the finger to enroll (Thumb, Index, Middle, Ring, Pinky).
6. Press **"Start Capture"** and have the staff member place their finger on the sensor.
7. The system captures the template and stores it locally with `sync_status = 0` (pending upload).
8. A background API call attempts to upload to the server immediately.
9. If the upload fails (no internet), the template stays pending — it will upload during the next **sync**.

### Managing Fingerprints

- **Deactivate** — Marks a fingerprint as inactive locally and on the server.
- **Delete** — Permanently removes the fingerprint template.
- **View Bio-Data** — See all enrolled fingers and their active status.

### Fingerprint Import from Server

When the app syncs (download), it pulls all bio-data for the assigned kitchen from the remote server and stores them locally. This ensures newly enrolled staff fingerprints are available even if they were enrolled on another device.

---

## Data Synchronization

The sync page has two tabs: **Upload** and **Download**.

### Upload (Local → Remote)

Pushes locally created data that has not yet reached the server.

| Entity | What gets uploaded |
|--------|--------------------|
| Staff Orders | Unsynced orders placed at this POS |
| BioData | Fingerprint templates enrolled on this device |

**Sync All** uploads both in one operation.

Use the **View** button on orders to see a list of pending orders before syncing.

### Download (Remote → Local)

Pulls fresh data from the server and replaces stale local records.

| Entity | Description |
|--------|-------------|
| Staff | All staff assigned to your kitchen |
| MealTypes | Meal type definitions and pricing |
| BioData | Fingerprint templates for your kitchen's staff |
| Visitors | Visitor records |
| Contractor Staff | Contractor personnel |
| Dependents | Staff dependents |
| Shifts | Shift definitions |

**Download All** fetches all entities in one operation.

Each entity card shows the current local record count. Tap **Sync** to fetch that specific entity individually.

### Sync Behavior

- **Stale cleanup** — Records that exist locally but are no longer present remotely are deleted automatically.
- **Fully synced records only** are subject to cleanup (pending or failed records are preserved).
- **Conflict resolution** — Remote data wins. Existing local records are updated via upsert (insert or replace).
- **Background sync** — The system auto-syncs on app startup after POS profile registration (download only).

---

## Reports

### Orders Report

Navigate to **Reports → Orders** to view all locally stored orders including:

- Order code
- Meal type
- Order type (single/group/alacarte)
- Staff name
- Sync status (synced / pending)
- Date and time
- Total price

**Features:**
- **Filter** by date range using the date picker at the top
- Tap any order to view its **receipt**
- Tap the **print icon** to re-print a receipt

---

## Settings

### POS Device Selection

Navigate to **Settings → POS Selection** to change the registered POS device. This is typically done once during setup.

### Card Test

Navigate to **Settings → Card Test** to scan an NFC card and verify it can be read. This is a diagnostic tool.

### Printer Settings

Navigate to **Settings → Printer Settings** to configure the thermal printer. Choose **Built-in** for the terminal's internal printer, or **External** for a USB/Bluetooth thermal printer — see [Printer Setup](#system-setup) above for the full scan/pair/connect flow. This page replaces the old printer type switch that used to live on the POS Settings page (POS Settings now only links to it).

### Data Synchronization

See [Data Synchronization](#data-synchronization) section above.

---

## Troubleshooting

### Fingerprint Scanner Not Working

1. Ensure the fingerprint hardware is properly connected to the Android device.
2. Restart the app — it initializes the scanner on launch.
3. Check **Settings → POS Settings** for scanner status indicators.

### Sync Failures

**Upload fails:**
- Check internet connectivity.
- Verify the server is reachable.
- Failed records remain locally with `sync_status = failed (3)` — they will be retried on the next sync.

**Download fails:**
- The system keeps existing local data intact if remote fetch fails.
- Try syncing individual entities to isolate the failure.
- Ensure the POS device profile is registered.

### Order Not Printing

1. Verify printer type is selected in **Settings → Printer Settings**.
2. For **External**: check the status card shows "Connected" — if not, reconnect (USB: Scan → Connect; Bluetooth: Scan in app or pair via Bluetooth settings → Refresh → Connect).
3. Ensure printer is powered on and, for Bluetooth, within range.
4. Use **Test print** on the Printer Settings page to isolate whether the issue is the printer connection or the order flow.
5. Try re-printing from the **Reports** page.

### Staff Not Found During Authentication

1. Ensure the staff has been synced from the server (check sync page download tab).
2. Verify the staff is assigned to the kitchen linked to this POS device.
3. For fingerprint auth: verify at least one active fingerprint exists for the staff.

### App Crashes or Freezes

1. Force-stop the app and relaunch.
2. If the issue persists, clear app data and re-register the POS device.
3. Check with your system administrator for server status.

---

## Glossary

| Term | Definition |
|------|------------|
| **POS** | Point of Sale — the device running this application |
| **BioData / Fingerprint Template** | Encrypted biometric data stored for fingerprint matching |
| **Meal Type** | A defined meal period (e.g., Breakfast, Lunch) with a set price |
| **Kitchen** | The dining facility this POS serves — determines available staff |
| **Voucher** | A pre-authorized meal order for staff based on their entitlement |
| **Sync Status** | 0 = New/Pending, 2 = Synced, 3 = Failed |
| **Upsert** | Insert if new, update if exists — prevents duplicates |
| **Group Order** | One staff authenticates, multiple identical meal orders are placed |
| **À la Carte** | Manual order for a specific meal type, outside the automatic voucher system |