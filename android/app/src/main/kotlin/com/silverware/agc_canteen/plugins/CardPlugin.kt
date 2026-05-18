package com.silverware.agc_canteen.plugins

import android.util.Log
import androidx.annotation.NonNull
import com.hftech.pos.HFPos
import com.hftech.pos.port.HiboryPort
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class CardPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "com.silverware.agc_canteen/card")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun getPort(): HiboryPort = HFPos.getInstance().connectPort

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        try {
            when (call.method) {
                "icApdu" -> {
                    val apdu = call.argument<List<Int>>("apdu")
                    if (apdu != null) {
                        val response = icApdu(ByteArray(apdu.size) { apdu[it].toByte() })
                        result.success(response?.toList() ?: emptyList<Int>())
                    } else {
                        result.error("INVALID_ARG", "APDU data required", null)
                    }
                }
                "psamReset" -> {
                    val slot = call.argument<Int>("slot") ?: 1
                    val response = psamReset(slot)
                    result.success(response?.toList() ?: emptyList<Int>())
                }
                "psamApdu" -> {
                    val slot = call.argument<Int>("slot") ?: 1
                    val apdu = call.argument<List<Int>>("apdu")
                    if (apdu != null) {
                        val response = psamApdu(slot, ByteArray(apdu.size) { apdu[it].toByte() })
                        result.success(response?.toList() ?: emptyList<Int>())
                    } else {
                        result.error("INVALID_ARG", "APDU data required", null)
                    }
                }
                "psamClose" -> {
                    val slot = call.argument<Int>("slot") ?: 1
                    val response = psamClose(slot)
                    result.success(response?.toList() ?: emptyList<Int>())
                }
                "swipeCard" -> {
                    val data = swipeCard()
                    result.success(data?.toList() ?: emptyList<Int>())
                }
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("CARD_ERROR", e.message, null)
        }
    }

    // ─── IC Card (ISO 7816 APDU) ────────────────────────────

    private fun icApdu(apdu: ByteArray): ByteArray? {
        flushInput()
        val cmd = ByteArray(apdu.size + 8).apply {
            this[0] = 0x1B
            this[1] = 0x23
            this[2] = 0x23
            set(3, 0x43)
            set(4, 0x41)
            set(5, 0x52)
            set(6, 0x44)
            this[7] = (apdu.size and 0xFF).toByte()
            System.arraycopy(apdu, 0, this, 8, apdu.size)
        }
        getPort().sendByteData(cmd)

        for (i in 0 until 10) {
            val data = getPort().readMuit()
            if (data != null) return data
            Thread.sleep(100)
        }
        return null
    }

    // ─── PSAM Card ──────────────────────────────────────────

    private val PSAM_HEADER = byteArrayOf(0x1B, 0x23, 0x23, 0x50, 0x53, 0x41, 0x4D)

    private fun psamReset(slot: Int): ByteArray? {
        flushInput()
        val len = 1
        val cmd = ByteArray(PSAM_HEADER.size + 3 + len).apply {
            System.arraycopy(PSAM_HEADER, 0, this, 0, PSAM_HEADER.size)
            this[PSAM_HEADER.size] = slot.toByte()
            this[PSAM_HEADER.size + 1] = ((len shr 8) and 0xFF).toByte()
            this[PSAM_HEADER.size + 2] = (len and 0xFF).toByte()
            this[PSAM_HEADER.size + 3] = 0x20
        }
        getPort().sendByteData(cmd)

        for (i in 0 until 10) {
            val data = getPort().readMuit()
            if (data != null) return data
            Thread.sleep(100)
        }
        return null
    }

    private fun psamApdu(slot: Int, apdu: ByteArray): ByteArray? {
        flushInput()
        val cmd = ByteArray(PSAM_HEADER.size + 3 + apdu.size).apply {
            System.arraycopy(PSAM_HEADER, 0, this, 0, PSAM_HEADER.size)
            this[PSAM_HEADER.size] = slot.toByte()
            this[PSAM_HEADER.size + 1] = ((apdu.size shr 8) and 0xFF).toByte()
            this[PSAM_HEADER.size + 2] = (apdu.size and 0xFF).toByte()
            System.arraycopy(apdu, 0, this, PSAM_HEADER.size + 3, apdu.size)
        }
        getPort().sendByteData(cmd)

        for (i in 0 until 10) {
            val data = getPort().readMuit()
            if (data != null) return data
            Thread.sleep(100)
        }
        return null
    }

    private fun psamClose(slot: Int): ByteArray? {
        flushInput()
        val len = 0
        val cmd = ByteArray(PSAM_HEADER.size + 3 + len).apply {
            System.arraycopy(PSAM_HEADER, 0, this, 0, PSAM_HEADER.size)
            this[PSAM_HEADER.size] = slot.toByte()
            this[PSAM_HEADER.size + 1] = ((len shr 8) and 0xFF).toByte()
            this[PSAM_HEADER.size + 2] = (len and 0xFF).toByte()
        }
        getPort().sendByteData(cmd)

        for (i in 0 until 10) {
            val data = getPort().readMuit()
            if (data != null) return data
            Thread.sleep(100)
        }
        return null
    }

    // ─── Magnetic Swipe Card ─────────────────────────────────

    private fun swipeCard(): ByteArray? {
        for (i in 0 until 50) {
            val data = getPort().readMuit()
            if (data != null) return data
            Thread.sleep(200)
        }
        return null
    }

    private fun flushInput() {
        getPort().read()
    }
}
