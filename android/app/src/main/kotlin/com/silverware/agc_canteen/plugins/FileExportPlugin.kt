package com.silverware.agc_canteen.plugins

import android.content.ContentValues
import android.content.Context
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

class FileExportPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private var appContext: Context? = null

    companion object {
        private const val SUBFOLDER = "AGC Canteen"
    }

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        appContext = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "com.silverware.agc_canteen/file_export")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        appContext = null
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        when (call.method) {
            "saveToDownloads" -> saveToDownloads(call, result)
            else -> result.notImplemented()
        }
    }

    private fun saveToDownloads(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        val fileName = call.argument<String>("fileName")
        val bytes = call.argument<List<Int>>("bytes")
        if (fileName.isNullOrBlank() || bytes == null) {
            result.error("INVALID_ARGS", "fileName and bytes are required", null)
            return
        }

        val data = ByteArray(bytes.size) { bytes[it].toByte() }
        try {
            val path = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                saveWithMediaStore(fileName, data)
            } else {
                saveWithFile(fileName, data)
            }
            result.success(path)
        } catch (e: Exception) {
            result.error("EXPORT_ERROR", e.message, null)
        }
    }

    private fun saveWithMediaStore(fileName: String, data: ByteArray): String {
        val context = appContext ?: throw IllegalStateException("Context not available")
        val relativePath = "${Environment.DIRECTORY_DOWNLOADS}/$SUBFOLDER"

        val values = ContentValues().apply {
            put(MediaStore.Downloads.DISPLAY_NAME, fileName)
            put(MediaStore.Downloads.MIME_TYPE, "text/csv")
            put(MediaStore.Downloads.RELATIVE_PATH, relativePath)
            put(MediaStore.Downloads.IS_PENDING, 1)
        }

        val resolver = context.contentResolver
        val collection = MediaStore.Downloads.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
        val uri = resolver.insert(collection, values)
            ?: throw IllegalStateException("Failed to create file in Downloads")

        resolver.openOutputStream(uri)?.use { out ->
            out.write(data)
            out.flush()
        } ?: throw IllegalStateException("Failed to open output stream")

        values.clear()
        values.put(MediaStore.Downloads.IS_PENDING, 0)
        resolver.update(uri, values, null, null)

        return "$relativePath/$fileName"
    }

    private fun saveWithFile(fileName: String, data: ByteArray): String {
        val downloads = Environment.getExternalStoragePublicDirectory(
            Environment.DIRECTORY_DOWNLOADS
        )
        val dir = File(downloads, SUBFOLDER)
        if (!dir.exists()) dir.mkdirs()
        val file = File(dir, fileName)
        file.writeBytes(data)
        return file.absolutePath
    }
}
