package com.silverware.canteen_staff_enrollment.plugins

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
        channel = MethodChannel(binding.binaryMessenger, "com.silverware.canteen_staff_enrollment/card")
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
                result.error("CARD_NOT_INIT", "HFPos SDK not initialized", null)
                return
            }
            when (call.method) {
                "icReset" -> {
                    val response = icReset()
                    result.success(response?.toList() ?: emptyList<Int>())
                }
                "icApdu" -> {
                    val apdu = call.argument<List<Int>>("apdu")
                    if (apdu != null) {
                        val response = icApdu(ByteArray(apdu.size) { apdu[it].toByte() })
                        result.success(response?.toList() ?: emptyList<Int>())
                    } else {
                        result.error("INVALID_ARG", "APDU data required", null)
                    }
                }
                "icWrite" -> {
                    val apdu = call.argument<List<Int>>("apdu")
                    if (apdu != null) {
                        val code = icWrite(ByteArray(apdu.size) { apdu[it].toByte() })
                        result.success(code)
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

    private fun flushInput() {
        getPort().read()
    }

  
    private fun icReset(): ByteArray? {
        flushInput()
        val cmd = byteArrayOf(0x1B, 0x23, 0x23, 0x43, 0x41, 0x52, 0x44, 0x00)
        getPort().sendByteData(cmd)
        Thread.sleep(500)

        for (i in 0 until 10) {
            val data = getPort().readMuit()
            if (data != null) {
                Log.d("CardPlugin", "IC Reset: ${data.joinToString(",")}")
                if (data[0] == 0x00.toByte()) {
                    val atr = ByteArray(data.size - 1)
                    System.arraycopy(data, 1, atr, 0, data.size - 1)
                    return atr
                }
                return data
            }
            Thread.sleep(100)
        }
        return null
    }

    /**
     * ISO 7816 APDU exchange with IC smart card.
     * Command: 1B 23 23 43 41 52 44 LEN APDU
     */
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

    /**
     * ISO 7816 write to IC memory card (e.g. 4442).
     * Command: 1B 23 23 43 41 52 44 LEN DATA
     * Returns write result code.
     */
    private fun icWrite(apdu: ByteArray): Int {
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

        var code = 0
        for (i in 0 until 10) {
            code = getPort().write(cmd)
            if (code != 0) return code
            Thread.sleep(100)
        }
        return code
    }

    // ─── PSAM Card ──────────────────────────────────────────

    private val PSAM_HEADER_RST = byteArrayOf(0x1B, 0x23, 0x23, 0x50, 0x53, 0x41, 0x4D)
    private val PSAM_HEADER_CLOSE = byteArrayOf(0x1B, 0x23, 0x23, 0x50, 0x4D, 0x44, 0x4E)

    /**
     * PSAM reset — activates and returns ATR.
     * Command: 1B 23 23 50 53 41 4D slot 00
     * (9 bytes, single-byte length of 0 = no APDU data)
     */
    private fun psamReset(slot: Int): ByteArray? {
        flushInput()
        val cmd = byteArrayOf(
            0x1B, 0x23, 0x23, 0x50, 0x53, 0x41, 0x4D,
            slot.toByte(),
            0x00
        )
        getPort().sendByteData(cmd)
        Thread.sleep(500)
        val data = getPort().readMuit()
        if (data != null) {
            if (data[0] == 0x00.toByte()) {
                val atr = ByteArray(data.size - 1)
                System.arraycopy(data, 1, atr, 0, data.size - 1)
                return atr
            }
            Log.d("CardPlugin", "psam reset fail, data: ${data.joinToString(",")}")
        }
        return null
    }

    private fun psamApdu(slot: Int, apdu: ByteArray): ByteArray? {
        flushInput()
        if (apdu.isEmpty()) return null

        val cmd = ByteArray(apdu.size + 9).apply {
            System.arraycopy(PSAM_HEADER_RST, 0, this, 0, PSAM_HEADER_RST.size)
            this[PSAM_HEADER_RST.size] = slot.toByte()
            this[PSAM_HEADER_RST.size + 1] = (apdu.size and 0xFF).toByte()
            System.arraycopy(apdu, 0, this, PSAM_HEADER_RST.size + 2, apdu.size)
        }
        getPort().sendByteData(cmd)

        var data: ByteArray? = null
        for (i in 0 until 10) {
            data = getPort().readMuit()
            if (data == null) {
                Thread.sleep(100)
                continue
            }
            if (data.size == 1) {
                if (data[0] == 0x01.toByte()) {
                    Log.e("CardPlugin", "psam no reset")
                } else if (data[0] == 0x02.toByte()) {
                    Log.e("CardPlugin", "apdu error")
                }
                Thread.sleep(100)
                continue
            }
            return data
        }
        return data
    }


    private fun psamClose(slot: Int): ByteArray? {
        flushInput()
        val cmd = ByteArray(PSAM_HEADER_CLOSE.size + 1).apply {
            System.arraycopy(PSAM_HEADER_CLOSE, 0, this, 0, PSAM_HEADER_CLOSE.size)
            this[PSAM_HEADER_CLOSE.size] = slot.toByte()
        }
        getPort().sendByteData(cmd)
        return getPort().read()
    }


    private fun swipeCard(): ByteArray? {
        flushInput()
        flushInput()
        for (i in 0 until 50) {
            val data = getPort().readMuit()
            if (data != null) {
                Log.d("CardPlugin", "swipeCard: ${data.joinToString(",")}")
                return data
            }
            Log.d("CardPlugin", "swipeCard count: $i")
        }
        return null
    }
}
