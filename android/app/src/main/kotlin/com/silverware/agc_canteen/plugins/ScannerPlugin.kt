package com.silverware.agc_canteen.plugins

import android.hibory.CommonApi
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ScannerPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null

    private val commonApi = CommonApi()
    private var readThread: Thread? = null
    private var isScanning = false
    private var comFd = -1

    private val COM_PATH = "/dev/ttyMT0"
    private val GPIO_POWER = 32
    private val GPIO_TRIGGER = 31

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(binding.binaryMessenger, "com.silverware.agc_canteen/scanner")
        methodChannel.setMethodCallHandler(this)

        eventChannel = EventChannel(binding.binaryMessenger, "com.silverware.agc_canteen/scanner_events")
        eventChannel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        closeScanner()
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        try {
            when (call.method) {
                "startScan" -> startScanner(result)
                "stopScan" -> {
                    closeScanner()
                    result.success(true)
                }
                "trigger" -> {
                    val trigger = call.argument<Boolean>("value") ?: false
                    triggerScanner(trigger)
                    result.success(true)
                }
                "isScanning" -> result.success(isScanning)
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("SCANNER_ERROR", e.message, null)
        }
    }

    private fun startScanner(@NonNull result: MethodChannel.Result) {
        try {
            commonApi.setGpioDir(GPIO_POWER, 1)
            commonApi.setGpioOut(GPIO_POWER, 1)

            comFd = commonApi.openCom(COM_PATH, 9600, 8, 'N', 1)
            if (comFd < 0) {
                result.error("SCANNER_OPEN_FAIL", "Failed to open COM port", null)
                return
            }

            triggerScanner(false)
            Thread.sleep(500)

            val serialCmd = byteArrayOf(
                0x7E, 0x00, 0x08, 0x01, 0x00, 0x0D,
                0xA0.toByte(), 0xAB.toByte(), 0xCD.toByte()
            )
            commonApi.writeCom(comFd, serialCmd, serialCmd.size)

            isScanning = true
            readThread = Thread {
                while (isScanning) {
                    try {
                        val buffer = ByteArray(256)
                        val readLen = commonApi.readComEx(comFd, buffer, 256, 0, 500000)
                        if (readLen > 0) {
                            val data = ByteArray(readLen)
                            System.arraycopy(buffer, 0, data, 0, readLen)
                            val barcode = String(data).trim()
                            Log.d("ScannerPlugin", "Scanned: $barcode")

                            eventSink?.success(mapOf(
                                "barcode" to barcode,
                                "raw" to data.toList()
                            ))
                        }
                    } catch (e: Exception) {
                        Log.e("ScannerPlugin", "Read error: ${e.message}")
                        break
                    }
                }
            }
            readThread?.start()
            result.success(true)
        } catch (e: Exception) {
            result.error("SCANNER_START_ERROR", e.message, null)
        }
    }

    private fun closeScanner() {
        isScanning = false
        readThread?.interrupt()
        readThread = null

        try {
            commonApi.setGpioDir(GPIO_POWER, 1)
            commonApi.setGpioOut(GPIO_POWER, 0)
            if (comFd >= 0) {
                commonApi.closeCom(comFd)
                comFd = -1
            }
        } catch (e: Exception) {
            Log.e("ScannerPlugin", "Close error: ${e.message}")
        }
    }

    private fun triggerScanner(trigger: Boolean) {
        commonApi.setGpioDir(GPIO_TRIGGER, 1)
        commonApi.setGpioOut(GPIO_TRIGGER, if (trigger) 1 else 0)
    }
}
