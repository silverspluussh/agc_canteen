package com.silverware.agc_canteen.plugins

import androidx.annotation.NonNull
import com.hftech.pos.HFPos
import com.hftech.pos.port.HiboryPort
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PrintPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "com.silverware.agc_canteen/print")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun getPort(): HiboryPort = HFPos.getInstance().connectPort

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        try {
            when (call.method) {
                "printRawBytes" -> {
                    val bytes = call.argument<List<Int>>("bytes")
                    if (bytes != null) {
                        val data = ByteArray(bytes.size) { bytes[it].toByte() }
                        getPort().sendByteData(data)
                        result.success(true)
                    } else {
                        result.error("INVALID_DATA", "Bytes argument is required", null)
                    }
                }
                "cutPaper" -> {
                    val cutData = byteArrayOf(0x1D.toByte(), 0x56.toByte(), 0x01.toByte())
                    getPort().sendByteData(cutData)
                    result.success(true)
                }
                "openCashDrawer" -> {
                    val drawerData = byteArrayOf(0x1B.toByte(), 0x70.toByte(), 0x00.toByte(), 0x19.toByte(), 0xFA.toByte())
                    getPort().sendByteData(drawerData)
                    result.success(true)
                }
                "checkPrinterState" -> {
                    val stateCmd = byteArrayOf(0x1B.toByte(), 0x76.toByte())
                    getPort().sendByteData(stateCmd)
                    val state = getPort().read()
                    val stateMap = mapOf(
                        "data" to state?.joinToString(",") { it.toInt().toString() },
                        "raw" to state?.toList()
                    )
                    result.success(stateMap)
                }
                "getFirmwareVersion" -> {
                    val versionCmd = byteArrayOf(0x1D.toByte(), 0x49.toByte(), 0x41.toByte())
                    getPort().sendByteData(versionCmd)
                    val version = getPort().read()
                    result.success(version?.let { String(it) } ?: "unknown")
                }
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("PRINT_ERROR", e.message, null)
        }
    }
}
