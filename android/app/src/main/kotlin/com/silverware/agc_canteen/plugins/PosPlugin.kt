package com.silverware.agc_canteen.plugins

import android.content.Context
import androidx.annotation.NonNull
import com.hftech.pos.HFPos
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PosPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private var isInitialized = false
    private var appContext: Context? = null

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        appContext = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "com.silverware.agc_canteen/pos")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        appContext = null
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        when (call.method) {
            "init" -> initPos(result)
            "getDeviceInfo" -> getDeviceInfo(result)
            "isInit" -> result.success(isInitialized)
            else -> result.notImplemented()
        }
    }

    private fun initPos(@NonNull result: MethodChannel.Result) {
        try {
            val context = appContext ?: run {
                result.error("POS_INIT_ERROR", "Context not available", null)
                return
            }
            HFPos.getInstance().init(context)
            isInitialized = true
            result.success(true)
        } catch (e: Exception) {
            result.error("POS_INIT_ERROR", e.message, null)
        }
    }

    private fun getDeviceInfo(@NonNull result: MethodChannel.Result) {
        val info = mapOf(
            "model" to (android.os.Build.MODEL ?: "unknown"),
            "serial" to (android.os.Build.SERIAL ?: "unknown"),
            "isInit" to isInitialized
        )
        result.success(info)
    }
}
