package com.silverware.agc_canteen.plugins

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ExternalPrintPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    companion object {
        private const val TAG = "ExternalPrintPlugin"
        private const val ACTION_USB_PERMISSION = "com.silverware.agc_canteen.USB_PERMISSION"

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
    private var connectedUsbDevice: UsbDevice? = null

    private val usbReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            when (intent.action) {
                UsbManager.ACTION_USB_DEVICE_ATTACHED -> {
                    val device = intent.getParcelableExtra<UsbDevice>(UsbManager.EXTRA_DEVICE)
                    if (device != null && isPrinterDevice(device)) {
                        connectedUsbDevice = device
                        requestUsbPermission(device)
                        Log.i(TAG, "USB printer attached: ${device.deviceName}")
                    }
                }
                UsbManager.ACTION_USB_DEVICE_DETACHED -> {
                    val device = intent.getParcelableExtra<UsbDevice>(UsbManager.EXTRA_DEVICE)
                    if (device != null && device.deviceId == connectedUsbDevice?.deviceId) {
                        connectedUsbDevice = null
                        Log.i(TAG, "USB printer detached")
                    }
                }
                ACTION_USB_PERMISSION -> {
                    val granted = intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)
                    if (!granted) {
                        Log.w(TAG, "USB permission denied")
                        connectedUsbDevice = null
                    }
                }
            }
        }
    }

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = binding.applicationContext
        usbManager = applicationContext?.getSystemService(Context.USB_SERVICE) as? UsbManager

        channel = MethodChannel(
            binding.binaryMessenger,
            "com.silverware.agc_canteen/external_print"
        )
        channel.setMethodCallHandler(this)

        registerUsbReceiver()
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        try {
            applicationContext?.unregisterReceiver(usbReceiver)
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

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        try {
            when (call.method) {
                "printRawBytes" -> {
                    val bytes = call.argument<List<Int>>("bytes")
                    val device = connectedUsbDevice
                    if (bytes != null && device != null) {
                        // TODO: send bytes to external USB/BLE printer
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }
                "cutPaper" -> {
                    if (connectedUsbDevice != null) {
                        // TODO: send cut command
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }
                "openCashDrawer" -> {
                    if (connectedUsbDevice != null) {
                        // TODO: send cash drawer command
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }
                "checkPrinterState" -> {
                    val device = connectedUsbDevice
                    if (device != null) {
                        result.success(mapOf(
                            "connected" to true,
                            "deviceName" to device.deviceName,
                            "vendorId" to device.vendorId,
                            "productId" to device.productId,
                        ))
                    } else {
                        result.success(mapOf("connected" to false))
                    }
                }
                "getFirmwareVersion" -> {
                    result.success(null)
                }
                "isAvailable" -> {
                    result.success(detectPrinter())
                }
                "scanForDevices" -> {
                    result.success(scanUsbDevices())
                }
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("EXTERNAL_PRINT_ERROR", e.message, null)
        }
    }

    private fun detectPrinter(): Boolean {
        if (connectedUsbDevice != null) return true
        connectedUsbDevice = findPrinterDevice()
        if (connectedUsbDevice != null) {
            requestUsbPermission(connectedUsbDevice!!)
            return true
        }
        return false
    }

    private fun findPrinterDevice(): UsbDevice? {
        val devices = usbManager?.deviceList ?: return null
        return devices.values.firstOrNull { isPrinterDevice(it) }
    }

    private fun isPrinterDevice(device: UsbDevice): Boolean {
        if (PRINTER_VENDOR_IDS.contains(device.vendorId)) return true
        for (i in 0 until device.interfaceCount) {
            val iface = device.getInterface(i)
            if (iface.interfaceClass == 0x07) return true // Printer class
            if (iface.interfaceClass == 0xFF) return true // Vendor-specific
            if (iface.interfaceClass == 0x0A) return true // CDC data (serial)
        }
        return false
    }

    private fun requestUsbPermission(device: UsbDevice) {
        val context = applicationContext ?: return
        if (usbManager?.hasPermission(device) == true) return
        val permissionIntent = PendingIntent.getBroadcast(
            context, 0,
            Intent(ACTION_USB_PERMISSION).setPackage(context.packageName),
            PendingIntent.FLAG_IMMUTABLE
        )
        usbManager?.requestPermission(device, permissionIntent)
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
}
