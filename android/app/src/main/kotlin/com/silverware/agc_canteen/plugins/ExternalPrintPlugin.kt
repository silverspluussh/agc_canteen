package com.silverware.agc_canteen.plugins

import android.app.PendingIntent
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothSocket
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.usb.UsbConstants
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbDeviceConnection
import android.hardware.usb.UsbEndpoint
import android.hardware.usb.UsbInterface
import android.hardware.usb.UsbManager
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import java.io.OutputStream
import java.util.UUID
import java.util.concurrent.Executors

/**
 * Handles an externally connected thermal printer over USB or Bluetooth
 * Classic (SPP). Both transports share the same ESC/POS byte write path.
 */
class ExternalPrintPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    companion object {
        private const val TAG = "ExternalPrintPlugin"
        private const val ACTION_USB_PERMISSION = "com.silverware.agc_canteen.USB_PERMISSION"
        private val SPP_UUID: UUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")
        private const val USB_WRITE_TIMEOUT_MS = 3000

        // Known thermal printer vendor IDs
        private val PRINTER_VENDOR_IDS = setOf(
            0x04b8, // Epson
            0x0a5f, // Zebra
            0x1504, // Bixolon
            0x0519, // Star Micronics
            0x1cb0, // Citizen
            0x0416, // Winpos
            0x0493, // Esc/POS generic
        )
    }

    private lateinit var channel: MethodChannel
    private var usbManager: UsbManager? = null
    private var applicationContext: Context? = null
    private val mainHandler = Handler(Looper.getMainLooper())
    private val bgExecutor = Executors.newCachedThreadPool()

    // ── USB state ────────────────────────────────────────────────────────
    private var connectedUsbDevice: UsbDevice? = null
    private var usbConnection: UsbDeviceConnection? = null
    private var usbInterface: UsbInterface? = null
    private var usbOutEndpoint: UsbEndpoint? = null
    private var pendingUsbPermissionResult: MethodChannel.Result? = null

    // ── Bluetooth state ──────────────────────────────────────────────────
    private var bluetoothAdapter: BluetoothAdapter? = null
    private var bluetoothSocket: BluetoothSocket? = null
    private var bluetoothOutputStream: OutputStream? = null
    private var connectedBluetoothDevice: BluetoothDevice? = null
    private var discoveryReceiverRegistered = false

    private val usbReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            when (intent.action) {
                UsbManager.ACTION_USB_DEVICE_ATTACHED -> {
                    @Suppress("DEPRECATION")
                    val device = intent.getParcelableExtra<UsbDevice>(UsbManager.EXTRA_DEVICE)
                    if (device != null && isPrinterDevice(device)) {
                        connectedUsbDevice = device
                        requestUsbPermission(device, null)
                        Log.i(TAG, "USB printer attached: ${device.deviceName}")
                    }
                }
                UsbManager.ACTION_USB_DEVICE_DETACHED -> {
                    @Suppress("DEPRECATION")
                    val device = intent.getParcelableExtra<UsbDevice>(UsbManager.EXTRA_DEVICE)
                    if (device != null && device.deviceId == connectedUsbDevice?.deviceId) {
                        closeUsbConnection()
                        connectedUsbDevice = null
                        Log.i(TAG, "USB printer detached")
                    }
                }
                ACTION_USB_PERMISSION -> {
                    val granted = intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)
                    val device = connectedUsbDevice
                    if (granted && device != null) {
                        openUsbConnection(device)
                    } else {
                        Log.w(TAG, "USB permission denied")
                        connectedUsbDevice = null
                    }
                    pendingUsbPermissionResult?.success(granted)
                    pendingUsbPermissionResult = null
                }
            }
        }
    }

    private val bluetoothReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            when (intent.action) {
                BluetoothDevice.ACTION_FOUND -> {
                    @Suppress("DEPRECATION")
                    val device = intent.getParcelableExtra<BluetoothDevice>(BluetoothDevice.EXTRA_DEVICE)
                    if (device != null) {
                        mainHandler.post {
                            channel.invokeMethod(
                                "bluetoothDeviceFound",
                                mapOf(
                                    "name" to (safeDeviceName(device) ?: "Unknown device"),
                                    "address" to device.address,
                                    "bonded" to (device.bondState == BluetoothDevice.BOND_BONDED),
                                ),
                            )
                        }
                    }
                }
                BluetoothAdapter.ACTION_DISCOVERY_FINISHED -> {
                    mainHandler.post { channel.invokeMethod("bluetoothDiscoveryFinished", null) }
                }
                BluetoothDevice.ACTION_BOND_STATE_CHANGED -> {
                    @Suppress("DEPRECATION")
                    val device = intent.getParcelableExtra<BluetoothDevice>(BluetoothDevice.EXTRA_DEVICE)
                    val state = intent.getIntExtra(BluetoothDevice.EXTRA_BOND_STATE, -1)
                    if (device != null && state != BluetoothDevice.BOND_BONDING) {
                        mainHandler.post {
                            channel.invokeMethod(
                                "bluetoothBondStateChanged",
                                mapOf(
                                    "address" to device.address,
                                    "bonded" to (state == BluetoothDevice.BOND_BONDED),
                                ),
                            )
                        }
                    }
                }
            }
        }
    }

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = binding.applicationContext
        usbManager = applicationContext?.getSystemService(Context.USB_SERVICE) as? UsbManager
        bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()

        channel = MethodChannel(
            binding.binaryMessenger,
            "com.silverware.agc_canteen/external_print"
        )
        channel.setMethodCallHandler(this)

        registerUsbReceiver()
        registerBluetoothReceiver()
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        stopDiscoveryInternal()
        closeUsbConnection()
        closeBluetoothConnection()
        try {
            applicationContext?.unregisterReceiver(usbReceiver)
        } catch (_: Exception) {}
        try {
            applicationContext?.unregisterReceiver(bluetoothReceiver)
        } catch (_: Exception) {}
    }

    private fun registerUsbReceiver() {
        val filter = IntentFilter().apply {
            addAction(UsbManager.ACTION_USB_DEVICE_ATTACHED)
            addAction(UsbManager.ACTION_USB_DEVICE_DETACHED)
            addAction(ACTION_USB_PERMISSION)
        }
        applicationContext?.registerReceiver(usbReceiver, filter, Context.RECEIVER_EXPORTED)
    }

    private fun registerBluetoothReceiver() {
        val filter = IntentFilter().apply {
            addAction(BluetoothDevice.ACTION_FOUND)
            addAction(BluetoothAdapter.ACTION_DISCOVERY_FINISHED)
            addAction(BluetoothDevice.ACTION_BOND_STATE_CHANGED)
        }
        applicationContext?.registerReceiver(bluetoothReceiver, filter, Context.RECEIVER_EXPORTED)
        discoveryReceiverRegistered = true
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        try {
            when (call.method) {
                "printRawBytes" -> {
                    val bytes = call.argument<List<Int>>("bytes")
                    if (bytes == null) {
                        result.success(false)
                        return
                    }
                    val data = ByteArray(bytes.size) { bytes[it].toByte() }
                    writeBytesAsync(data, result)
                }
                "cutPaper" -> {
                    val cutData = byteArrayOf(0x1D, 0x56, 0x42, 0x00)
                    writeBytesAsync(cutData, result)
                }
                "openCashDrawer" -> {
                    val drawerData = byteArrayOf(0x1B, 0x70, 0x00, 0x32, 0x32)
                    writeBytesAsync(drawerData, result)
                }
                "checkPrinterState" -> {
                    result.success(buildStateMap())
                }
                "getFirmwareVersion" -> {
                    result.success(null)
                }
                "isAvailable" -> {
                    result.success(isPrinterConnected())
                }
                "getConnectionInfo" -> {
                    result.success(buildConnectionInfo())
                }
                "disconnect" -> {
                    closeUsbConnection()
                    closeBluetoothConnection()
                    result.success(true)
                }
                "scanForDevices" -> {
                    result.success(scanUsbDevices())
                }
                "connectUsb" -> {
                    val deviceName = call.argument<String>("deviceName")
                    connectUsb(deviceName, result)
                }
                "isBluetoothSupported" -> {
                    result.success(bluetoothAdapter != null && bluetoothAdapter!!.isEnabled)
                }
                "getBondedBluetoothDevices" -> {
                    result.success(getBondedBluetoothDevices())
                }
                "startBluetoothDiscovery" -> {
                    result.success(startBluetoothDiscovery())
                }
                "stopBluetoothDiscovery" -> {
                    stopDiscoveryInternal()
                    result.success(true)
                }
                "pairBluetoothDevice" -> {
                    val address = call.argument<String>("address")
                    result.success(pairBluetoothDevice(address))
                }
                "connectBluetooth" -> {
                    val address = call.argument<String>("address")
                    connectBluetoothAsync(address, result)
                }
                "openBluetoothSettings" -> {
                    openBluetoothSettings()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("EXTERNAL_PRINT_ERROR", e.message, null)
        }
    }

    // ── Shared write path ───────────────────────────────────────────────

    private fun writeBytesAsync(data: ByteArray, result: MethodChannel.Result) {
        bgExecutor.execute {
            val ok = try {
                writeBytes(data)
            } catch (e: Exception) {
                Log.e(TAG, "Write failed: ${e.message}")
                false
            }
            mainHandler.post { result.success(ok) }
        }
    }

    private fun writeBytes(data: ByteArray): Boolean {
        bluetoothOutputStream?.let { stream ->
            stream.write(data)
            stream.flush()
            return true
        }
        val connection = usbConnection
        val iface = usbInterface
        val endpoint = usbOutEndpoint
        if (connection != null && iface != null && endpoint != null) {
            return writeUsbChunked(connection, endpoint, data)
        }
        return false
    }

    private fun writeUsbChunked(
        connection: UsbDeviceConnection,
        endpoint: UsbEndpoint,
        data: ByteArray,
    ): Boolean {
        val chunkSize = maxOf(endpoint.maxPacketSize, 64)
        var offset = 0
        while (offset < data.size) {
            val size = minOf(chunkSize, data.size - offset)
            val chunk = data.copyOfRange(offset, offset + size)
            val sent = connection.bulkTransfer(endpoint, chunk, chunk.size, USB_WRITE_TIMEOUT_MS)
            if (sent < 0) return false
            offset += size
        }
        return true
    }

    private fun isPrinterConnected(): Boolean =
        bluetoothOutputStream != null || (usbConnection != null && usbOutEndpoint != null)

    private fun buildStateMap(): Map<String, Any> {
        return when {
            bluetoothOutputStream != null -> mapOf(
                "connected" to true,
                "connectionType" to "bluetooth",
                "deviceName" to (safeDeviceName(connectedBluetoothDevice) ?: "Unknown"),
                "address" to (connectedBluetoothDevice?.address ?: ""),
            )
            usbConnection != null && usbOutEndpoint != null -> mapOf(
                "connected" to true,
                "connectionType" to "usb",
                "deviceName" to (connectedUsbDevice?.deviceName ?: "Unknown"),
                "vendorId" to (connectedUsbDevice?.vendorId ?: 0),
                "productId" to (connectedUsbDevice?.productId ?: 0),
            )
            else -> mapOf("connected" to false)
        }
    }

    private fun buildConnectionInfo(): Map<String, Any?> {
        return when {
            bluetoothOutputStream != null -> mapOf(
                "connected" to true,
                "type" to "bluetooth",
                "name" to safeDeviceName(connectedBluetoothDevice),
                "address" to connectedBluetoothDevice?.address,
            )
            usbConnection != null && usbOutEndpoint != null -> mapOf(
                "connected" to true,
                "type" to "usb",
                "name" to connectedUsbDevice?.deviceName,
                "address" to null,
            )
            else -> mapOf("connected" to false, "type" to null, "name" to null, "address" to null)
        }
    }

    // ── USB ──────────────────────────────────────────────────────────────

    private fun findPrinterDevice(): UsbDevice? {
        val devices = usbManager?.deviceList ?: return null
        return devices.values.firstOrNull { isPrinterDevice(it) }
    }

    private fun isPrinterDevice(device: UsbDevice): Boolean {
        if (PRINTER_VENDOR_IDS.contains(device.vendorId)) return true
        for (i in 0 until device.interfaceCount) {
            val iface = device.getInterface(i)
            if (iface.interfaceClass == UsbConstants.USB_CLASS_PRINTER) return true
            if (iface.interfaceClass == 0xFF) return true // Vendor-specific
            if (iface.interfaceClass == UsbConstants.USB_CLASS_CDC_DATA) return true
        }
        return false
    }

    private fun findBulkOutInterfaceAndEndpoint(device: UsbDevice): Pair<UsbInterface, UsbEndpoint>? {
        for (i in 0 until device.interfaceCount) {
            val iface = device.getInterface(i)
            for (e in 0 until iface.endpointCount) {
                val endpoint = iface.getEndpoint(e)
                if (endpoint.type == UsbConstants.USB_ENDPOINT_XFER_BULK &&
                    endpoint.direction == UsbConstants.USB_DIR_OUT
                ) {
                    return iface to endpoint
                }
            }
        }
        return null
    }

    private fun requestUsbPermission(device: UsbDevice, result: MethodChannel.Result?) {
        val context = applicationContext ?: return
        if (usbManager?.hasPermission(device) == true) {
            openUsbConnection(device)
            result?.success(true)
            return
        }
        pendingUsbPermissionResult = result
        val permissionIntent = PendingIntent.getBroadcast(
            context, 0,
            Intent(ACTION_USB_PERMISSION).setPackage(context.packageName),
            PendingIntent.FLAG_IMMUTABLE
        )
        usbManager?.requestPermission(device, permissionIntent)
    }

    private fun openUsbConnection(device: UsbDevice) {
        closeUsbConnection()
        val manager = usbManager ?: return
        val target = findBulkOutInterfaceAndEndpoint(device)
        if (target == null) {
            Log.w(TAG, "No bulk-OUT endpoint found on ${device.deviceName}")
            return
        }
        val (iface, endpoint) = target
        val connection = manager.openDevice(device) ?: run {
            Log.w(TAG, "Failed to open USB device ${device.deviceName}")
            return
        }
        if (!connection.claimInterface(iface, true)) {
            Log.w(TAG, "Failed to claim USB interface")
            connection.close()
            return
        }
        usbConnection = connection
        usbInterface = iface
        usbOutEndpoint = endpoint
        connectedUsbDevice = device
        // A USB connection replaces any active Bluetooth connection.
        closeBluetoothConnection()
        Log.i(TAG, "USB printer connected: ${device.deviceName}")
    }

    private fun closeUsbConnection() {
        try {
            usbInterface?.let { usbConnection?.releaseInterface(it) }
            usbConnection?.close()
        } catch (_: Exception) {}
        usbConnection = null
        usbInterface = null
        usbOutEndpoint = null
    }

    private fun connectUsb(deviceName: String?, result: MethodChannel.Result) {
        val devices = usbManager?.deviceList
        val device = devices?.values?.firstOrNull { it.deviceName == deviceName }
            ?: findPrinterDevice()
        if (device == null) {
            result.success(false)
            return
        }
        connectedUsbDevice = device
        requestUsbPermission(device, result)
    }

    private fun scanUsbDevices(): List<Map<String, Any>> {
        val devices = usbManager?.deviceList ?: return emptyList()
        return devices.values.map { device ->
            mapOf<String, Any>(
                "deviceName" to device.deviceName,
                "vendorId" to device.vendorId,
                "productId" to device.productId,
                "interfaceCount" to device.interfaceCount,
            )
        }
    }

    // ── Bluetooth ────────────────────────────────────────────────────────

    private fun hasBluetoothConnectPermission(): Boolean {
        val context = applicationContext ?: return false
        return try {
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
                context.checkSelfPermission(android.Manifest.permission.BLUETOOTH_CONNECT) ==
                    android.content.pm.PackageManager.PERMISSION_GRANTED
            } else {
                true
            }
        } catch (_: Exception) {
            false
        }
    }

    private fun hasBluetoothScanPermission(): Boolean {
        val context = applicationContext ?: return false
        return try {
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
                context.checkSelfPermission(android.Manifest.permission.BLUETOOTH_SCAN) ==
                    android.content.pm.PackageManager.PERMISSION_GRANTED
            } else {
                true
            }
        } catch (_: Exception) {
            false
        }
    }

    @Suppress("MissingPermission")
    private fun safeDeviceName(device: BluetoothDevice?): String? {
        if (device == null || !hasBluetoothConnectPermission()) return device?.address
        return try {
            device.name
        } catch (_: SecurityException) {
            null
        }
    }

    @Suppress("MissingPermission")
    private fun getBondedBluetoothDevices(): List<Map<String, Any>> {
        val adapter = bluetoothAdapter ?: return emptyList()
        if (!hasBluetoothConnectPermission()) return emptyList()
        return try {
            adapter.bondedDevices.map { device ->
                mapOf(
                    "name" to (safeDeviceName(device) ?: "Unknown device"),
                    "address" to device.address,
                    "bonded" to true,
                )
            }
        } catch (_: SecurityException) {
            emptyList()
        }
    }

    @Suppress("MissingPermission")
    private fun startBluetoothDiscovery(): Boolean {
        val adapter = bluetoothAdapter ?: return false
        if (!adapter.isEnabled) return false
        if (!hasBluetoothScanPermission()) return false
        return try {
            if (adapter.isDiscovering) adapter.cancelDiscovery()
            adapter.startDiscovery()
        } catch (_: SecurityException) {
            false
        }
    }

    @Suppress("MissingPermission")
    private fun stopDiscoveryInternal() {
        try {
            if (bluetoothAdapter?.isDiscovering == true) bluetoothAdapter?.cancelDiscovery()
        } catch (_: Exception) {}
    }

    /**
     * Initiates a bond with the given device. Returns true if the OS
     * accepted the pairing request (result arrives async via
     * `bluetoothBondStateChanged`); false if this device/OEM rejects
     * in-app pairing (caller should fall back to system Bluetooth settings).
     */
    @Suppress("MissingPermission")
    private fun pairBluetoothDevice(address: String?): Boolean {
        if (address == null) return false
        val adapter = bluetoothAdapter ?: return false
        if (!hasBluetoothConnectPermission()) return false
        val device = try {
            adapter.getRemoteDevice(address)
        } catch (_: IllegalArgumentException) {
            return false
        }
        if (device.bondState == BluetoothDevice.BOND_BONDED) return true
        return try {
            device.createBond()
        } catch (_: SecurityException) {
            false
        }
    }

    private fun connectBluetoothAsync(address: String?, result: MethodChannel.Result) {
        if (address == null) {
            result.success(false)
            return
        }
        bgExecutor.execute {
            val ok = try {
                connectBluetoothBlocking(address)
            } catch (e: Exception) {
                Log.e(TAG, "Bluetooth connect failed: ${e.message}")
                false
            }
            mainHandler.post { result.success(ok) }
        }
    }

    @Suppress("MissingPermission")
    private fun connectBluetoothBlocking(address: String): Boolean {
        val adapter = bluetoothAdapter ?: return false
        if (!hasBluetoothConnectPermission()) return false
        val device = adapter.getRemoteDevice(address)
        closeUsbConnection()
        closeBluetoothConnection()
        stopDiscoveryInternal()

        var socket: BluetoothSocket? = null
        try {
            socket = device.createRfcommSocketToServiceRecord(SPP_UUID)
            socket.connect()
        } catch (e: IOException) {
            Log.w(TAG, "Standard SPP connect failed, trying fallback: ${e.message}")
            try {
                socket?.close()
            } catch (_: Exception) {}
            socket = try {
                // Fallback for devices that don't expose createRfcommSocketToServiceRecord
                // reliably (common workaround for reflection-based channel 1 connect).
                val method = device.javaClass.getMethod(
                    "createRfcommSocket",
                    Int::class.javaPrimitiveType,
                )
                method.invoke(device, 1) as BluetoothSocket
            } catch (_: Exception) {
                null
            }
            try {
                socket?.connect()
            } catch (_: Exception) {
                try {
                    socket?.close()
                } catch (_: Exception) {}
                return false
            }
        }

        if (socket == null || !socket.isConnected) return false
        bluetoothSocket = socket
        bluetoothOutputStream = socket.outputStream
        connectedBluetoothDevice = device
        Log.i(TAG, "Bluetooth printer connected: $address")
        return true
    }

    private fun closeBluetoothConnection() {
        try {
            bluetoothOutputStream?.close()
        } catch (_: Exception) {}
        try {
            bluetoothSocket?.close()
        } catch (_: Exception) {}
        bluetoothOutputStream = null
        bluetoothSocket = null
        connectedBluetoothDevice = null
    }

    private fun openBluetoothSettings() {
        val context = applicationContext ?: return
        try {
            val intent = Intent(android.provider.Settings.ACTION_BLUETOOTH_SETTINGS).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            context.startActivity(intent)
        } catch (e: Exception) {
            Log.w(TAG, "Failed to open Bluetooth settings: ${e.message}")
        }
    }
}
