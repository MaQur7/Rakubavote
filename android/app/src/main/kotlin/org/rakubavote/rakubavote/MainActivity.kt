package org.rakubavote.rakubavote

import android.app.ActivityManager
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.os.Build
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Kiosk mode for voting booths (lib/platform/kiosk.dart).
 *
 * If the app is the device owner (set once with adb, see README), lock task mode
 * keeps voters inside the app: no home, recent apps or notifications. Otherwise
 * Android's screen pinning is used, which the user must confirm and which an
 * informed person can leave; officers should set up device owner on booth tablets.
 */
class MainActivity : FlutterActivity() {
    private val channel = "org.rakubavote/kiosk"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            when (call.method) {
                "isDeviceOwner" -> result.success(isDeviceOwner())
                "isLocked" -> result.success(isLocked())
                "enter" -> {
                    try {
                        if (isDeviceOwner()) {
                            val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
                            val admin = ComponentName(this, KioskAdminReceiver::class.java)
                            dpm.setLockTaskPackages(admin, arrayOf(packageName))
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                                dpm.setLockTaskFeatures(admin, DevicePolicyManager.LOCK_TASK_FEATURE_NONE)
                            }
                        }
                        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                        startLockTask()
                        result.success(isDeviceOwner())
                    } catch (e: Exception) {
                        result.error("kiosk", e.message, null)
                    }
                }
                "exit" -> {
                    try {
                        stopLockTask()
                    } catch (_: Exception) {
                    }
                    window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun isDeviceOwner(): Boolean {
        val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        return dpm.isDeviceOwnerApp(packageName)
    }

    private fun isLocked(): Boolean {
        val am = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        return am.lockTaskModeState != ActivityManager.LOCK_TASK_MODE_NONE
    }
}
