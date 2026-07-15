package com.silverware.agc_canteen.plugins

import android.app.Activity
import android.media.AudioManager
import android.media.ToneGenerator
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class NfcPlugin : FlutterPlugin, ActivityAware, MethodChannel.MethodCallHandler,
    EventChannel.StreamHandler, NfcAdapter.ReaderCallback {

    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null
    private var activity: Activity? = null
    private var nfcAdapter: NfcAdapter? = null

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(
            binding.binaryMessenger, "com.silverware.agc_canteen/nfc"
        )
        methodChannel.setMethodCallHandler(this)

        eventChannel = EventChannel(
            binding.binaryMessenger, "com.silverware.agc_canteen/nfc_events"
        )
        eventChannel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        eventSink = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        nfcAdapter = NfcAdapter.getDefaultAdapter(activity)
    }

    override fun onDetachedFromActivity() {
        disableReaderMode()
        activity = null
        nfcAdapter = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        enableReaderMode()
    }

    override fun onCancel(arguments: Any?) {
        disableReaderMode()
        eventSink = null
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        try {
            when (call.method) {
                "supportNfc" -> result.success(nfcAdapter != null)
                "isEnabled" -> result.success(nfcAdapter?.isEnabled ?: false)
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("NFC_ERROR", e.message, null)
        }
    }

    private fun enableReaderMode() {
        val adapter = nfcAdapter ?: return
        val act = activity ?: return
        try {
            adapter.enableReaderMode(act, this,
                NfcAdapter.FLAG_READER_NFC_A or
                        NfcAdapter.FLAG_READER_NFC_B or
                        NfcAdapter.FLAG_READER_NFC_F or
                        NfcAdapter.FLAG_READER_NFC_V or
                        NfcAdapter.FLAG_READER_NFC_BARCODE or
                        NfcAdapter.FLAG_READER_NO_PLATFORM_SOUNDS or
                        NfcAdapter.FLAG_READER_SKIP_NDEF_CHECK,
                null
            )
        } catch (e: Exception) {
            Log.e("NfcPlugin", "enableReaderMode: ${e.message}")
        }
    }

    private fun disableReaderMode() {
        val adapter = nfcAdapter ?: return
        val act = activity ?: return
        try {
            adapter.disableReaderMode(act)
        } catch (e: Exception) {
            Log.e("NfcPlugin", "disableReaderMode: ${e.message}")
        }
    }

    override fun onTagDiscovered(tag: Tag) {
        Handler(Looper.getMainLooper()).post {
            try {
                val id = tag.id ?: return@post
                val hexId = bytes2HexString(id)

                ToneGenerator(AudioManager.STREAM_MUSIC, 100)
                    .apply { startTone(ToneGenerator.TONE_PROP_BEEP, 150) }

                eventSink?.success(mapOf(
                    "tagId" to hexId,
                    "techList" to tag.techList.toList()
                ))
            } catch (e: Exception) {
                Log.e("NfcPlugin", "onTagDiscovered: ${e.message}")
            }
        }
    }

    private fun bytes2HexString(bytes: ByteArray): String {
        val ret = StringBuilder()
        for (b in bytes) {
            val hex = Integer.toHexString(b.toInt() and 0xFF)
            if (hex.length == 1) ret.append('0')
            ret.append(hex.uppercase())
        }
        return ret.toString()
    }
}
