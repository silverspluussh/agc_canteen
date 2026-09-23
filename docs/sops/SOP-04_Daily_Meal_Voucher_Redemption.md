# SOP-04: Daily Meal Voucher Redemption

| Document ID | SOP-04 |
|:---|:---|
| **Title** | Daily Meal Voucher Redemption (Fingerprint, NFC & PIN) |
| **Category** | Daily Operations |
| **Target Roles** | POS Cashier, Canteen Operator |
| **Effective Version** | AGC Canteen POS v0.1.0+ |

---

## 1. Purpose & Scope
This Standard Operating Procedure governs the primary point-of-sale workflow for authenticating eligible AGC staff and issuing automated meal voucher tickets during scheduled breakfast, lunch, dinner, and shift meal windows.

---

## 2. Prerequisites & Equipment
* Active POS Terminal in **Staff Auth / Voucher Redemption** mode.
* Loaded thermal paper roll in active printer (Built-in or External).
* Synced staff directory and biometric templates for the assigned kitchen.

---

## 3. Step-by-Step Procedure

### Step 3.1: Active Meal Window Verification
1. Verify the current time matches an active meal entitlement period (e.g., Breakfast, Lunch, Dinner, Night Shift Meal).
2. The POS system automatically queries `MealTimeService` to resolve the active meal type based on local device time and kitchen shift configurations.

### Step 3.2: Primary Authentication — Biometric Fingerprint
1. Instruct the staff member to place their enrolled finger onto the optical scanner sensor.
2. The POS matches the captured scan against local biometric templates in SQLite:
   * **Matching Criteria:** Confidence match score $\ge 80$.
   * **Kitchen Check:** Staff must be assigned to the kitchen linked to this POS.
3. Upon positive match:
   * A meal voucher order is automatically placed.
   * A unique order code is generated.
   * The receipt printer immediately outputs the meal voucher ticket.
   * On-screen green confirmation flashes with staff name and order code.

### Step 3.3: Secondary Authentication — NFC Card Tap
1. If NFC authentication is enabled, instruct the staff member to tap their employee badge against the reader.
2. The terminal reads the card UID, validates kitchen assignment, records the voucher, and outputs the printed ticket.

### Step 3.4: Fallback Authentication — Admin / PIN Authentication
*Use this fallback only if biometric recognition fails or if a staff member's prints are unreadable/unregistered.*
1. On the Staff Auth screen, tap **"Use PIN"**.
2. Enter the staff member's **Employee ID** and secret **PIN**.
3. Tap **Verify & Order**.
4. System validates eligibility and automatically prints the meal voucher.

---

## 4. Verification & Acceptance Criteria
* [ ] Printed receipt contains: Kitchen Name, Staff Name, Staff ID, Meal Type, Timestamp, and Unique Order Code.
* [ ] Order is logged in local SQLite database with unique code.
* [ ] POS screen returns to standby readiness mode within < 2 seconds.

---

## 5. Exception Handling & Error Codes
* **Error: "Not Enrolled"**
  * *Cause:* No matching biometric template exists in the terminal database.
  * *Action:* Use PIN fallback or direct staff to Canteen Admin for enrollment ([SOP-03](./SOP-03_Staff_Biometric_and_NFC_Enrollment.md)).
* **Error: "Not in Kitchen"**
  * *Cause:* Staff fingerprint matched, but staff profile is assigned to a different kitchen/canteen location.
  * *Action:* Direct staff to their designated kitchen or request kitchen reallocation via Admin.
* **Error: "No Active Meal Type"**
  * *Cause:* Attempted redemption outside scheduled meal serving windows.
  * *Action:* Wait for meal window to open or use Manual Order flow if authorized ([SOP-05](./SOP-05_Manual_Alacarte_and_Group_Orders.md)).
