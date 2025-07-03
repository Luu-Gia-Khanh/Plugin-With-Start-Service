package com.example.service_noti

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

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "✅ MyFirebaseMessagingService CREATED")
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        Log.d(TAG, "🔥 ON RECEIVED MESSAGE - Data: ${remoteMessage.data}")
        Log.d(TAG, "🔥 From: ${remoteMessage.from}")
        Log.d(TAG, "🔥 Notification: ${remoteMessage.notification}")
        
        // ✅ GỌI SUPER TRƯỚC để Flutter nhận background message
        // super.onMessageReceived(remoteMessage)
    }

    override fun onNewToken(token: String) {
        Log.d(TAG, "Refreshed token: $token")
        sendRegistrationToServer(token)
    }

    private fun sendRegistrationToServer(token: String?) {
        Log.d(TAG, "Sending token to server: $token")
    }
}
