# SOP-07: Reconciliation, Reporting & Fault Troubleshooting

| Document ID | SOP-07 |
|:---|:---|
| **Title** | Reconciliation, Reporting & Fault Troubleshooting |
| **Category** | Audit, Reporting & Support |
| **Target Roles** | Canteen Supervisor, IT Support Specialist, System Auditor |
| **Effective Version** | AGC Canteen POS v0.1.0+ |

---

## 1. Purpose & Scope
This Standard Operating Procedure establishes the daily audit and reconciliation process for meal voucher counts, receipt re-issuance protocols, and standard diagnostic resolution for hardware and application anomalies.

---

## 2. Prerequisites & Equipment
* POS Terminal with Admin/Supervisor access.
* Kitchen meal production logs / head count tally sheet.
* USB / Bluetooth / Built-in printer connected.

---

## 3. Step-by-Step Procedure

### Step 3.1: Daily Shift Closing & Meal Reconciliation
1. Navigate to **Reports → Orders**.
2. Tap the **Date Picker** at the top of the interface:
   * Select the target reporting day / shift window.
3. Review the aggregated metrics:
   * Total Orders Placed
   * Total Meal Value
   * Breakdown by Order Type (Single Voucher / Group / À La Carte)
   * Synchronization Breakdown (Synced vs. Pending)
4. Compare POS order totals against kitchen physical serving counters.
5. If any orders remain pending, execute [SOP-06: Upload Sync](./SOP-06_Offline_Operations_and_Data_Sync.md) before final shift closing.

### Step 3.2: Receipt Re-Printing & Disputed Order Verification
1. Open **Reports → Orders**.
2. Locate the specific transaction using the debounced search bar:
   * Search by Staff Name, Employee ID, or Order Code.
3. Tap on the order row to inspect full transaction details (timestamp, kitchen, meal type, sync status).
4. Tap the **Print Icon** on the order card to re-issue an official replacement receipt.

### Step 3.3: Hardware & Application Incident Troubleshooting Matrix

| Symptom | Probable Cause | Corrective Action |
|:---|:---|:---|
| **Biometric scanner does not illuminate** | Hardware disconnect / driver sleep state | Relaunch app to trigger SDK re-initialization. Verify OTG cable if external scanner. |
| **Staff fingerprint rejected ("Not Enrolled")** | Template missing from local SQLite cache | Perform **Download Sync → BioData** ([SOP-06](./SOP-06_Offline_Operations_and_Data_Sync.md)) or re-enroll staff ([SOP-03](./SOP-03_Staff_Biometric_and_NFC_Enrollment.md)). |
| **"Not in Kitchen" error during auth** | Staff allocated to a different dining hall | Check terminal kitchen in **POS Selection**. Reallocate staff in HR portal if transferred. |
| **Thermal printer outputs blank paper** | Paper roll inserted upside down | Re-insert paper roll with thermal coating facing print head. Run test print in **Printer Settings**. |
| **External Bluetooth printer disconnects** | Bluetooth socket dropped / sleep | Tap **Refresh** under paired devices in **Printer Settings** and re-tap **Connect**. |
| **App freeze / unresponsive UI** | Heavy background task or OS memory leak | Force-close app from Android App Switcher and relaunch. All SQLite transactions are atomic and persisted. |

---

## 4. Verification & Acceptance Criteria
* [ ] Daily reconciliation report accurately accounts for all served meals.
* [ ] Zero un-synced orders remain at close of business.
* [ ] Hardware status indicators are green and ready for the next operational shift.
