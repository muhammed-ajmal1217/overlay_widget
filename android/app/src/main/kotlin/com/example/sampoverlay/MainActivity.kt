package com.example.sampoverlay
import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.sampoverlay/openApp"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val channel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { call, result ->
            Log.d("MainActivity", "Method called: ${call.method}")
            when (call.method) {
                "openApp" -> {
                    Log.d("MainActivity", "Opening the app")
                    val intent = Intent(this, MainActivity::class.java)
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                    startActivity(intent)
                    result.success(null)
                }
                else -> {
                    Log.d("MainActivity", "Method not implemented: ${call.method}")
                    result.notImplemented()
                }
            }
        }
    }
}
