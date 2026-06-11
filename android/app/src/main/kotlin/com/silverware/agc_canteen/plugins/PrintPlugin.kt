package com.silverware.agc_canteen.plugins

import android.util.Log
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

    private val isInit: Boolean get() = HFPos.getInstance().isInit

    private fun getPort(): HiboryPort = HFPos.getInstance().connectPort

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        try {
            if (!isInit) {
                result.error("PRINT_NOT_INIT", "HFPos SDK not initialized", null)
                return
            }
            when (call.method) {
                "printRawBytes" -> {
                    val bytes = call.argument<List<Int>>("bytes")
                    if (bytes != null) {
                        val data = ByteArray(bytes.size) { bytes[it].toByte() }
                        sendChunked(data)
                        result.success(true)
                    } else {
                        result.error("INVALID_DATA", "Bytes argument is required", null)
                    }
                }
                "cutPaper" -> {
                    val cutData = byteArrayOf(
                        0x1D.toByte(), 0x56.toByte(), 0x42.toByte(), 0x00.toByte()
                    )
                    getPort().sendByteData(cutData)
                    result.success(true)
                }
                "openCashDrawer" -> {
                    val drawerData = byteArrayOf(
                        0x1B.toByte(), 0x70.toByte(), 0x00.toByte(),
                        0x32.toByte(), 0x32.toByte()
                    )
                    getPort().sendByteData(drawerData)
                    result.success(true)
                }
                "checkPrinterState" -> {
                    flushInput()
                    val stateCmd = byteArrayOf(0x1D.toByte(), 0x61.toByte(), 0x00.toByte())
                    getPort().sendByteData(stateCmd)
                    printerSleep(50)
                    val state = getPort().read()
                    val stateMap = mapOf(
                        "data" to state?.joinToString(",") { it.toInt().toString() },
                        "raw" to state?.toList()
                    )
                    result.success(stateMap)
                }
                "checkPaper" -> {
                    flushInput()
                    val paperCmd = byteArrayOf(0x1D.toByte(), 0x61.toByte(), 0x00.toByte())
                    getPort().sendByteData(paperCmd)
                    printerSleep(50)
                    val data = getPort().read()
                    result.success(data?.toList() ?: emptyList<Int>())
                }
                "getFirmwareVersion" -> {
                    flushInput()
                    printerSleep(50)
                    getPort().read()
                    val versionCmd = byteArrayOf(0x1D.toByte(), 0x49.toByte(), 0x41.toByte())
                    getPort().sendByteData(versionCmd)
                    printerSleep(50)
                    val version = getPort().read()
                    result.success(version?.let { String(it) } ?: "unknown")
                }
                "isAvailable" -> {
                    result.success(isInit)
                }
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("PRINT_ERROR", e.message, null)
        }
    }

    private fun printerSleep(ms: Int) {
        try {
            Thread.sleep(ms.toLong())
        } catch (_: Exception) {}
    }

    private fun flushInput() {
        getPort().read()
    }

    /**
     * Send data in chunks of 1KB to match PdaX1-1's HiboryPrinter.sendByteData
     * which chunks large data to prevent buffer overflow.
     */
    private fun sendChunked(data: ByteArray) {
        val chunkSize = 1024
        if (data.size <= chunkSize) {
            getPort().write(data)
        } else {
            var offset = 0
            while (offset < data.size) {
                val remaining = data.size - offset
                val size = if (remaining > chunkSize) chunkSize else remaining
                val chunk = ByteArray(size)
                System.arraycopy(data, offset, chunk, 0, size)
                getPort().write(chunk)
                offset += size
                if (offset < data.size) {
                    Thread.sleep(100)
                }
            }
        }
    }
}
