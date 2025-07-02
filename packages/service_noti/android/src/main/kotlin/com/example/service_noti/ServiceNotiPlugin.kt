package com.example.service_noti

import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class ServiceNotiPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  
  private var backgroundServiceClass: Class<out Service>? = null
  private var foregroundServiceClass: Class<out Service>? = null
  
  companion object {
    private const val TAG = "ServiceNotiPlugin"
  }

  fun registerServices(
    backgroundServiceClass: Class<out Service>,
    foregroundServiceClass: Class<out Service>
  ) {
    this.backgroundServiceClass = backgroundServiceClass
    this.foregroundServiceClass = foregroundServiceClass
    Log.d(TAG, "Services registered: ${backgroundServiceClass.simpleName}, ${foregroundServiceClass.simpleName}")
  }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "service_noti")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "startBackgroundService" -> {
        if (backgroundServiceClass != null) {
          try {
            val intent = Intent(context, backgroundServiceClass)
            context.startService(intent)
            Log.d(TAG, "Background service started successfully")
            result.success("Background service started successfully")
          } catch (e: Exception) {
            Log.e(TAG, "Failed to start background service: ${e.message}")
            result.error("START_ERROR", "Failed to start background service: ${e.message}", null)
          }
        } else {
          result.error("SERVICE_NOT_REGISTERED", "Background service not registered in MainActivity", null)
        }
      }
      "stopBackgroundService" -> {
        if (backgroundServiceClass != null) {
          try {
            val intent = Intent(context, backgroundServiceClass)
            context.stopService(intent)
            Log.d(TAG, "Background service stopped successfully")
            result.success("Background service stopped successfully")
          } catch (e: Exception) {
            Log.e(TAG, "Failed to stop background service: ${e.message}")
            result.error("STOP_ERROR", "Failed to stop background service: ${e.message}", null)
          }
        } else {
          result.error("SERVICE_NOT_REGISTERED", "Background service not registered in MainActivity", null)
        }
      }
      "startForegroundService" -> {
        if (foregroundServiceClass != null) {
          try {
            val intent = Intent(context, foregroundServiceClass)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
              context.startForegroundService(intent)
            } else {
              context.startService(intent)
            }
            Log.d(TAG, "Foreground service started successfully")
            result.success("Foreground service started successfully")
          } catch (e: Exception) {
            Log.e(TAG, "Failed to start foreground service: ${e.message}")
            result.error("START_ERROR", "Failed to start foreground service: ${e.message}", null)
          }
        } else {
          result.error("SERVICE_NOT_REGISTERED", "Foreground service not registered in MainActivity", null)
        }
      }
      "stopForegroundService" -> {
        if (foregroundServiceClass != null) {
          try {
            val intent = Intent(context, foregroundServiceClass)
            context.stopService(intent)
            Log.d(TAG, "Foreground service stopped successfully")
            result.success("Foreground service stopped successfully")
          } catch (e: Exception) {
            Log.e(TAG, "Failed to stop foreground service: ${e.message}")
            result.error("STOP_ERROR", "Failed to stop foreground service: ${e.message}", null)
          }
        } else {
          result.error("SERVICE_NOT_REGISTERED", "Foreground service not registered in MainActivity", null)
        }
      }
      "getServiceStatus" -> {
        try {
          // Use reflection to get service status from the registered classes
          val backgroundRunning = if (backgroundServiceClass != null) {
            try {
              val field = backgroundServiceClass!!.getDeclaredField("isRunning")
              field.isAccessible = true
              field.getBoolean(null)
            } catch (e: Exception) {
              Log.w(TAG, "Could not get background service status: ${e.message}")
              false
            }
          } else false
          
          val foregroundRunning = if (foregroundServiceClass != null) {
            try {
              val field = foregroundServiceClass!!.getDeclaredField("isRunning")
              field.isAccessible = true
              field.getBoolean(null)
            } catch (e: Exception) {
              Log.w(TAG, "Could not get foreground service status: ${e.message}")
              false
            }
          } else false
          
          val status = mapOf(
            "backgroundRunning" to backgroundRunning,
            "foregroundRunning" to foregroundRunning,
            "servicesRegistered" to (backgroundServiceClass != null && foregroundServiceClass != null)
          )
          result.success(status)
        } catch (e: Exception) {
          Log.e(TAG, "Failed to get service status: ${e.message}")
          result.error("STATUS_ERROR", "Failed to get service status: ${e.message}", null)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
