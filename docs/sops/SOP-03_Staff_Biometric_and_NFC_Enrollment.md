# SOP-03: Staff Biometric & NFC Credential Enrollment

| Document ID | SOP-03 |
|:---|:---|
| **Title** | Staff Biometric & NFC Credential Enrollment |
| **Category** | Identity & Access Management |
| **Target Roles** | Canteen Administrator, HR Operations, IT Support |
| **Effective Version** | AGC Canteen POS v0.1.0+ |

---

## 1. Purpose & Scope
This Standard Operating Procedure establishes the protocol for enrolling staff biometric fingerprint templates, linking NFC cards, and managing biometric lifecycle states (active, deactivated, deleted) in the AGC Canteen system.

---

## 2. Prerequisites & Equipment
* POS Terminal with functional biometric scanner.
* Staff member physically present with clean, dry hands.
* Staff master record already created and synced from HR central database.
* NFC smart card (if provisioning card access).

---

## 3. Step-by-Step Procedure

### Step 3.1: Staff Member Lookup
1. Log in to the POS terminal as an **Admin**.
2. Navigate to **Settings → Staff Management**.
3. Use the search bar (debounced) to query by:
   * Staff Full Name
   * Employee ID / Staff Code
   * Department filter (if kitchen has multiple departments).
4. Select the matching staff record to open the **Staff Details / Bio-Data View**.

### Step 3.2: Fingerprint Capture & Template Registration
1. Tap the **+ Enroll Fingerprint** button.
2. Select the specific finger being scanned:
   * *Primary Recommended:* Right Thumb or Right Index.
   * *Secondary / Backup:* Left Thumb or Left Index.
3. Guide the staff member to position their finger flat and steady on the center of the optical scanner glass.
4. Tap **Start Capture**.
5. The hardware captures the image, extracts minutiae features, and calculates template quality.
6. Once captured, the system saves the encrypted template locally with `sync_status = 0` (Pending Upload).
7. If internet is active, the app automatically triggers a background upload to sync the biometric template with the central server.

### Step 3.3: Managing Enrolled Fingerprint Templates
* **Deactivation (Temporary Suspension):**
  * If a staff member is suspended or on extended leave, toggle **Deactivate** on their registered finger template. The template will not match during redemption.
* **Deletion (Permanent Removal):**
  * Tap **Delete** to permanently purge the biometric template from local storage and schedule remote deletion.
* **Backup Finger Enrollment:**
  * For staff with damaged skin or difficult prints, enroll a second finger (e.g., Left Index) following Step 3.2.

### Step 3.4: Multi-Terminal Biometric Distribution
1. Biometric data enrolled on Device A is uploaded to the central server during background or manual sync.
2. To enable the enrolled staff member on Device B (e.g., another kitchen terminal), navigate on Device B to **Settings → Data Synchronization → Download Tab** and tap **Sync BioData** (or **Download All**).

---

## 4. Verification & Acceptance Criteria
* [ ] Captured template is stored locally with valid finger index and timestamp.
* [ ] Template count increments in the staff profile card.
* [ ] Verification test: Have staff place finger on auth screen; confirm instant identity match with confidence score $\ge 80$.

---

## 5. Exception Handling & Troubleshooting
* **Poor Image Quality / Scan Timeout:** Clean the staff member's finger and the scanner glass; apply slight, even pressure without sliding.
* **Staff Member Missing in Search:** Ensure download sync has been performed under **Data Synchronization** to pull the latest HR staff directory.
