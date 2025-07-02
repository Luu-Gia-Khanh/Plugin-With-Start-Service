package com.example.start_service_flutter

import android.app.Service
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.firebase.messaging.FirebaseMessaging
import com.example.service_noti.ServiceNotiPlugin


class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.start_service_flutter/fcm"
    private val TAG = "MainActivity"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Register services from service_a and service_b packages with ServiceNotiPlugin
        try {
            val servicePlugin = flutterEngine.plugins.get(ServiceNotiPlugin::class.java) as? ServiceNotiPlugin
            if (servicePlugin != null) {
                // Get service classes from packages
                val serviceAClass = getServiceAClass()
                val serviceBClass = getServiceBClass()
                
                if (serviceAClass != null && serviceBClass != null) {
                    servicePlugin.registerServices(
                        serviceAClass,  // Background service from service_a package
                        serviceBClass   // Foreground service from service_b package
                    )
                    Log.d(TAG, "Services registered successfully: ${serviceAClass.simpleName} (background), ${serviceBClass.simpleName} (foreground)")
                } else {
                    Log.e(TAG, "Failed to load service classes from packages")
                }
            } else {
                Log.e(TAG, "ServiceNotiPlugin not found")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to register services: ${e.message}")
        }
    }

    private fun getServiceAClass(): Class<out Service>? {
        return try {
            // Load BackgroundService from service_a package
            Class.forName("com.example.service_a.BackgroundService") as Class<out Service>
        } catch (e: ClassNotFoundException) {
            Log.e(TAG, "BackgroundService from service_a package not found: ${e.message}")
            null
        } catch (e: ClassCastException) {
            Log.e(TAG, "BackgroundService is not a Service class: ${e.message}")
            null
        }
    }

    private fun getServiceBClass(): Class<out Service>? {
        return try {
            // Load ForegroundService from service_b package (assuming similar structure)
            Class.forName("com.example.service_b.ForegroundService") as Class<out Service>
        } catch (e: ClassNotFoundException) {
            Log.e(TAG, "ForegroundService from service_b package not found: ${e.message}")
            // Fallback: try other possible names
            try {
                Class.forName("com.example.service_b.BackgroundService") as Class<out Service>
            } catch (e2: ClassNotFoundException) {
                Log.e(TAG, "No service found in service_b package: ${e2.message}")
                null
            } catch (e2: ClassCastException) {
                Log.e(TAG, "Service in service_b package is not a Service class: ${e2.message}")
                null
            }
        } catch (e: ClassCastException) {
            Log.e(TAG, "ForegroundService is not a Service class: ${e.message}")
            null
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        FirebaseMessaging.getInstance().subscribeToTopic("general")
            .addOnCompleteListener { task ->
                var msg = "Subscribed to general topic"
                if (!task.isSuccessful) {
                    msg = "Subscribe failed"
                }
                Log.d(TAG, msg)
            }
    }
}
