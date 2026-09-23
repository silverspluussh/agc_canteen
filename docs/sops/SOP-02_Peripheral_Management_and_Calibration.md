# SOP-02: Peripheral Management & Calibration

| Document ID | SOP-02 |
|:---|:---|
| **Title** | Peripheral Management (Printer, Scanner & NFC) |
| **Category** | Hardware & Peripherals |
| **Target Roles** | IT Support, Canteen Supervisor, POS Operator |
| **Effective Version** | AGC Canteen POS v0.1.0+ |

---

## 1. Purpose & Scope
This Standard Operating Procedure outlines the configuration, pairing, testing, and troubleshooting protocols for built-in/external receipt printers, optical fingerprint scanners, and contactless NFC card readers.

---

## 2. Prerequisites & Equipment
* POS Terminal with internal thermal head or external 58mm/80mm USB / Bluetooth thermal receipt printer.
* Compatible thermal paper rolls (standard 58mm / 80mm).
* Test NFC RFID card (ISO 14443 Type A/B / Mifare).
* Clean micro-fiber cloth for optical scanner prism.

---

## 3. Step-by-Step Procedure

### Step 3.1: Built-in Internal Thermal Printer Configuration
1. Open terminal paper compartment; insert thermal paper roll with feeding edge facing down/forward. Close lid securely.
2. Navigate to **Settings → Printer Settings**.
3. Select the **Built-in** option (HFPos Native SDK).
4. Tap **Test Print**.
5. Verify a receipt outputs with complete header, sample barcode/QR, clear alignment, and clean tear-off margin.

### Step 3.2: External Printer Configuration (USB / Bluetooth)
1. **USB Printer Flow:**
   * Connect printer to terminal via USB OTG cable and power on printer.
   * In **Settings → Printer Settings**, switch printer type to **External** → **USB**.
   * Tap **Scan**, choose detected device from list, and tap **Connect**.
   * Tap **Test Print** to confirm byte transmission.
2. **Bluetooth Printer Flow:**
   * Power on Bluetooth thermal printer and enable pairing mode.
   * In **Settings → Printer Settings**, select **External** → **Bluetooth**.
   * Tap **Scan in app** to discover and auto-pair the peripheral.
   * *OEM Fallback Mode:* If in-app pairing is blocked by Android OEM security, open Android OS **Bluetooth Settings**, pair with the device manually, return to the app, tap the **Refresh** icon under "Paired devices", and tap **Connect**.
   * Tap **Test Print** to verify receipt output over SPP socket.

### Step 3.3: Fingerprint Scanner Optical Check & Calibration
1. Inspect the optical sensor glass for dirt, grease, or residue. Clean gently using a dry micro-fiber cloth.
2. Verify scanner status indicator is active on the main POS authorization view.
3. If hardware fails to initialize during cold start, restart application to re-trigger native driver handshake.

### Step 3.4: Contactless NFC Card Reader Test
1. Navigate to **Settings → Card Test**.
2. Hold a test NFC card within 2–4 cm of the POS card reader zone (usually rear or top bezel).
3. Confirm instantaneous detection, UID extraction, and audible/visual confirmation on screen.

---

## 4. Verification & Acceptance Criteria
* [ ] Printer settings and connection preferences persist across application restarts.
* [ ] Test print outputs legible text without missing lines or thermal fading.
* [ ] Card test displays valid card UID and responds within < 1 second.
* [ ] Optical fingerprint prism illuminates upon authentication request.

---

## 5. Exception Handling & Troubleshooting
* **Printer Type Silently Reverting / Not Saving:** Ensure the printer is powered on and physically connected before switching to External mode.
* **Paper Jam / Blank Output:** Verify paper roll orientation (thermal side must face the print head).
* **NFC Unresponsive:** Verify Android NFC toggle is enabled in system OS settings.
