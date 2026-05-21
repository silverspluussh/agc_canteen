package com.silverware.agc_canteen.plugins

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Base64
import android.util.Log
import androidx.annotation.NonNull
import com.hfteco.finger.FingerSDK
import com.hfteco.finger.OnCaptureBytesListener
import com.hfteco.finger.OnSdkInitListener
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class FingerprintPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var fingerSDK: FingerSDK? = null
    private var eventSink: EventChannel.EventSink? = null
    private var currentTemplate: ByteArray? = null
    private var isSdkReady = false
    private var appContext: Context? = null

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        appContext = binding.applicationContext

        methodChannel = MethodChannel(binding.binaryMessenger, "com.silverware.agc_canteen/fingerprint")
        methodChannel.setMethodCallHandler(this)

        eventChannel = EventChannel(binding.binaryMessenger, "com.silverware.agc_canteen/fingerprint_events")
        eventChannel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        cancelFingerprint()
        fingerSDK = null
        appContext = null
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        when (call.method) {
            "init" -> initFingerprint(result)
            "capture" -> {
                val templateIndex = call.argument<Int>("templateIndex") ?: 0
                capture(templateIndex, result)
            }
            "verify" -> {
                val template = call.argument<String>("template")
                val templateIndex = call.argument<Int>("templateIndex") ?: 0
                if (template != null) verifyFingerprint(templateIndex, template, result)
                else result.error("INVALID_ARG", "Template is required", null)
            }
            "enroll" -> {
                val templateIndex = call.argument<Int>("templateIndex") ?: 0
                enroll(templateIndex, result)
            }
            "cancel" -> {
                cancelFingerprint()
                result.success(true)
            }
            "isAvailable" -> result.success(isSdkReady)
            "getTemplateTypes" -> {
                val types = getTemplateTypeNames()
                result.success(types)
            }
            else -> result.notImplemented()
        }
    }

    private fun cancelFingerprint() {
        val sdk = fingerSDK ?: return
        try {
            val method = FingerSDK::class.java.getDeclaredMethod("cancel").apply {
                isAccessible = true
            }
            method.invoke(sdk)
        } catch (_: Exception) {}
    }

    private fun getTemplateTypeNames(): List<String> {
        return try {
            FingerSDK.TEMPLEATES.getTempleatesList().map { it.name }
        } catch (e: Exception) {
            emptyList()
        }
    }

    private fun getTemplateAtIndex(index: Int): FingerSDK.TEMPLEATES {
        val list = FingerSDK.TEMPLEATES.getTempleatesList()
        return if (index in list.indices) list[index] else list[0]
    }

    private fun initFingerprint(@NonNull result: MethodChannel.Result) {
        try {
            val context = appContext as? android.app.Activity ?: run {
                result.error("FINGER_INIT_ERROR", "Context not available", null)
                return
            }
            fingerSDK = FingerSDK(context, object : OnSdkInitListener {
                override fun initResult(code: Int, msg: String?) {
                    isSdkReady = code == FingerSDK.RESULT_OK
                    Log.d("FingerprintPlugin", "SDK init: code=$code msg=$msg")
                    if (isSdkReady) {
                        result.success(true)
                    } else {
                        result.error("FINGER_INIT_ERROR", "SDK init failed: $msg", null)
                    }
                }
            })
        } catch (e: Exception) {
            result.error("FINGER_INIT_ERROR", e.message, null)
        }
    }

    private fun capture(templateIndex: Int, @NonNull result: MethodChannel.Result) {
        if (fingerSDK == null || !isSdkReady) {
            result.error("FINGER_NOT_INIT", "Fingerprint SDK not initialized", null)
            return
        }

        try {
            val templateType = getTemplateAtIndex(templateIndex)
            fingerSDK!!.captureBytes(templateType, object : OnCaptureBytesListener {
                override fun capture(
                    code: Int,
                    data: ByteArray?,
                    bitmap: Bitmap?,
                    template: ByteArray?
                ) {
                    if (code == FingerSDK.RESULT_OK && data != null && template != null) {
                        currentTemplate = template

                        val imageBytes = bitmap?.let {
                            val stream = ByteArrayOutputStream()
                            it.compress(Bitmap.CompressFormat.PNG, 80, stream)
                            stream.toByteArray()
                        }

                        val captureResult = mutableMapOf<String, Any>(
                            "success" to true,
                            "data" to data.toList(),
                            "templateBase64" to Base64.encodeToString(template, Base64.NO_WRAP),
                        )
                        if (imageBytes != null) {
                            captureResult["imageBase64"] = Base64.encodeToString(imageBytes, Base64.NO_WRAP)
                        }

                        eventSink?.success(captureResult)
                        result.success(captureResult)
                    } else {
                        val errorResult = mapOf("success" to false, "code" to code)
                        eventSink?.success(errorResult)
                        result.success(errorResult)
                    }
                }
            })
        } catch (e: Exception) {
            result.error("FINGER_CAPTURE_ERROR", e.message, null)
        }
    }

    private fun verifyFingerprint(
        templateIndex: Int,
        templateBase64: String,
        @NonNull result: MethodChannel.Result
    ) {
        if (fingerSDK == null || !isSdkReady) {
            result.error("FINGER_NOT_INIT", "Fingerprint SDK not initialized", null)
            return
        }

        if (currentTemplate == null) {
            result.error("NO_TEMPLATE", "No template captured yet", null)
            return
        }

        try {
            val templateType = getTemplateAtIndex(templateIndex)
            val storedTemplate = Base64.decode(templateBase64, Base64.NO_WRAP)
            val score = fingerSDK!!.compareTemplateBytes(
                templateType,
                currentTemplate!!,
                storedTemplate
            )
            result.success(score)
        } catch (e: Exception) {
            result.error("FINGER_VERIFY_ERROR", e.message, null)
        }
    }

    private fun enroll(templateIndex: Int, @NonNull result: MethodChannel.Result) {
        capture(templateIndex, result)
    }
}
