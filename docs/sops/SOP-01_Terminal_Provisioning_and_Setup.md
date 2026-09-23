# SOP-01: Terminal Provisioning & Kitchen Setup

| Document ID | SOP-01 |
|:---|:---|
| **Title** | Terminal Provisioning & Kitchen Profile Setup |
| **Category** | Setup & Configuration |
| **Target Roles** | IT Support, System Administrator, Canteen Administrator |
| **Effective Version** | AGC Canteen POS v0.1.0+ |

---

## 1. Purpose & Scope
This Standard Operating Procedure defines the step-by-step process for provisioning, configuring, and binding a new or factory-reset Android POS terminal to its designated kitchen dining facility within the AGC network.

---

## 2. Prerequisites & Equipment
* Target Android POS Terminal (with built-in or external thermal printer and biometric optical module).
* Stable Wi-Fi network or active 4G/LTE SIM card with cellular data.
* Authorized Admin credentials (Email/Phone and Password).
* Verified `ADMIN_ACCESS_CODE` configuration in environment (`.env`).

---

## 3. Step-by-Step Procedure

### Step 3.1: Terminal Unboxing & Initial Boot
1. Power on the POS terminal.
2. Ensure battery level is above 50% or connected to mains AC power.
3. Launch the **AGC Canteen POS** application.
4. Verify the splash screen initializes without database corruption or hardware SDK errors.

### Step 3.2: Administrator Authentication
1. On the launch screen, tap the settings/lock icon or navigate to **Admin Login**.
2. Input registered **Administrator Email / Phone** and **Password**.
3. Authenticate to unlock administrative privilege menus.

### Step 3.3: POS Device Profile Binding
1. Navigate to **Settings → POS Selection**.
2. The terminal queries the central backend server for available POS profiles registered under AGC.
3. Select the specific POS Terminal Profile representing the physical terminal and target kitchen location (e.g., *Main Plant Kitchen - POS 01*).
4. Confirm profile binding. This registers the device UUID, kitchen association, and kitchen ID locally.

### Step 3.4: Baseline Master Data Download
1. Ensure the terminal has an active internet connection.
2. Navigate to **Settings → Data Synchronization → Download Tab**.
3. Tap **Download All** to pull:
   * Assigned Department records
   * Active Meal Types & pricing catalog
   * Shift definitions and active dining meal time windows
   * Registered visitor and contractor records
4. Confirm the record counts increment and display on each respective card.

---

## 4. Verification & Acceptance Criteria
* [ ] POS terminal profile is successfully assigned and visible in the device summary.
* [ ] Kitchen ID is bound; terminal displays correct kitchen name on header.
* [ ] Initial download sync passes with zero network timeout errors.
* [ ] Unregistered POS error prompt does not appear upon navigating to POS main screen.

---

## 5. Exception Handling & Troubleshooting
* **Error: "Unregistered POS" upon boot:** Relaunch **Settings → POS Selection**, re-authenticate as Admin, and select the device profile again.
* **Error: "Network Connection Timeout":** Verify Wi-Fi gateway/DNS or cellular APN settings before retrying sync.
