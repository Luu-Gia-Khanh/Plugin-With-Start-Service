package com.example.start_service_flutter

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class MyFirebaseMessagingService : FirebaseMessagingService() {

    private val TAG = "FCMService"
    private val CHANNEL_ID = "fcm_default_channel"

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        Log.d(TAG, "ON RECEIVED MESSAGE")
        val autoStart = "true"
        val serviceType = "background"
        // Check service type to start
        // val serviceType = remoteMessage.data["service_type"] ?: "background"
        // val autoStart = remoteMessage.data["auto_start"] ?: "true"
        if (autoStart == "true") {
            Log.d(TAG, "CALL START SERVICE FROM FCM")
            when (serviceType.lowercase()) {
                "background" -> {
                    Log.d(TAG, "Starting service_a BackgroundService from FCM")
                    startServiceA()
                }
                "foreground" -> {
                    Log.d(TAG, "Starting service_b service from FCM")
                    startServiceB()
                }
                else -> {
                    Log.d(TAG, "Starting default service_a BackgroundService from FCM")
                    startServiceA()
                }
            }
        }
        // }
        remoteMessage.notification?.let {
            Log.d(TAG, "Message Notification Body: ${it.body}")
            sendNotification(it.title ?: "Notification", it.body ?: "")
        }
    }

    override fun onNewToken(token: String) {
        Log.d(TAG, "Refreshed token: $token")
        sendRegistrationToServer(token)
    }

    private fun sendRegistrationToServer(token: String?) {
        Log.d(TAG, "Sending token to server: $token")
    }

    private fun sendNotification(title: String, messageBody: String) {
        val intent = Intent(this, MainActivity::class.java)
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
        val requestCode = 0
        val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
        val pendingIntent = PendingIntent.getActivity(this, requestCode, intent, flags)

        val notificationBuilder = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentTitle(title)
            .setContentText(messageBody)
            .setAutoCancel(true)
            .setContentIntent(pendingIntent)

        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "FCM Notifications",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            notificationManager.createNotificationChannel(channel)
        }

        notificationManager.notify(0, notificationBuilder.build())
    }

    private fun startServiceA() {
        try {
            // Start BackgroundService from service_a package
            val serviceAClass = Class.forName("com.example.service_a.BackgroundService")
            val intent = Intent(this, serviceAClass)
            startService(intent)
            Log.d(TAG, "service_a BackgroundService started successfully from FCM")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to start service_a BackgroundService: ${e.message}")
        }
    }

    private fun startServiceB() {
        try {
            // Try to start service from service_b package
            val serviceBClass = getServiceBClass()
            if (serviceBClass != null) {
                val intent = Intent(this, serviceBClass)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    // Check if it's a foreground service
                    if (serviceBClass.simpleName.contains("Foreground", ignoreCase = true)) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                } else {
                    startService(intent)
                }
                Log.d(TAG, "service_b ${serviceBClass.simpleName} started successfully from FCM")
            } else {
                Log.e(TAG, "service_b service class not found")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to start service_b service: ${e.message}")
        }
    }

    private fun getServiceBClass(): Class<*>? {
        // Try different possible service names in service_b package
        val possibleClassNames = listOf(
            "com.example.service_b.ForegroundService",
            "com.example.service_b.BackgroundService",
            "com.example.service_b.ServiceB"
        )
        
        for (className in possibleClassNames) {
            try {
                return Class.forName(className)
            } catch (e: ClassNotFoundException) {
                Log.d(TAG, "Class $className not found, trying next...")
            }
        }
        return null
    }
}
