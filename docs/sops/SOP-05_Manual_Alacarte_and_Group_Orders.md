# SOP-05: Manual, À La Carte & Group Order Processing

| Document ID | SOP-05 |
|:---|:---|
| **Title** | Manual, À La Carte & Group Order Processing |
| **Category** | POS Operations |
| **Target Roles** | POS Cashier, Canteen Operator, Canteen Supervisor |
| **Effective Version** | AGC Canteen POS v0.1.0+ |

---

## 1. Purpose & Scope
This Standard Operating Procedure outlines the procedure for processing custom à la carte meal orders, walk-in requests, special meal descriptions, and bulk group meal orders for contractor teams or department batches.

---

## 2. Prerequisites & Equipment
* Active POS Terminal with operational thermal receipt printer.
* Authenticated staff member (via biometric scan, PIN, or cashier lookup).
* Preloaded meal pricing catalog.

---

## 3. Step-by-Step Procedure

### Step 3.1: Navigating to Manual Order Interface
1. Authenticate the staff member or cashier.
2. From the main POS interface, select **Manual Order** (or **À La Carte Order**).

### Step 3.2: Processing a Single À La Carte Order
1. Select the target **Meal Type** from the available catalog (e.g., Breakfast, Special Lunch, Executive Meal).
2. *(Optional)* In the **Description / Notes** field, input any specific dining instructions or dietary modifications (e.g., "Vegetarian", "No spice").
3. Ensure **Single Order** is selected.
4. Review the meal unit price and order summary.
5. Tap **Place Order**.
6. The terminal creates the transaction record and prints the customized meal receipt.

### Step 3.3: Processing Group / Bulk Orders
*Used when a department head, team lead, or contractor foreman collects multiple meal packs simultaneously.*
1. On the **Manual Order** screen, select **Group Order**.
2. Select the designated **Meal Type**.
3. Set the **Quantity / Group Count** ($N$ meals, e.g., 5, 10, 20).
4. Review total aggregate price ($N \times \text{Unit Price}$).
5. Tap **Place Order**.
6. The system executes atomic database batch insertion, generating $N$ discrete order records each with a unique sequential order code.
7. The receipt printer outputs individual voucher tickets for each meal in the group order.

---

## 4. Verification & Acceptance Criteria
* [ ] Group orders produce exactly $N$ distinct receipts, each bearing a unique alphanumeric order code.
* [ ] Total financial value is accurately calculated and assigned to the authenticated staff/contractor ID.
* [ ] Orders are logged in local SQLite with `sync_status = 0 (Pending)` ready for server synchronization.

---

## 5. Exception Handling & Troubleshooting
* **Printer Runs Out of Paper Mid-Batch:**
  1. Insert new paper roll immediately.
  2. Navigate to **Reports → Orders**.
  3. Locate the missing order codes from the group batch.
  4. Tap the **Print Icon** to re-issue unprinted tickets ([SOP-07](./SOP-07_Reconciliation_Reporting_and_Troubleshooting.md)).
* **Staff Member Search Lag:**
  * Use the debounced search input with minimum 3 characters or enter exact Employee ID to rapidly filter records.
