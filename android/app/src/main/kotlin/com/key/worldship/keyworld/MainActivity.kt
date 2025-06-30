package com.key.worldship.keyworld

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "app_control"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "forceExit" -> {
                    forceExitApp()
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun forceExitApp() {
        // First try to finish the activity gracefully
        finishAffinity()
        
        // Force kill the process if needed
        android.os.Process.killProcess(android.os.Process.myPid())
        System.exit(0)
    }

    override fun onBackPressed() {
        // Let Flutter handle the back press
        super.onBackPressed()
    }
}
