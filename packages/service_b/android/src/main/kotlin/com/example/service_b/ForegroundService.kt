package com.example.service_b

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class ForegroundService : Service() {
    private val serviceJob = Job()
    private val serviceScope = CoroutineScope(Dispatchers.Default + serviceJob)
    
    companion object {
        private const val TAG = "ForegroundService"
        private const val NOTIFICATION_ID = 1001
        private const val CHANNEL_ID = "foreground_service_channel"
        @JvmField
        var isRunning = false
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "Foreground Service Created")
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "Foreground Service Started")
        isRunning = true
        
        // Update status in ServiceNotiPlugin
        try {
            val pluginClass = Class.forName("com.example.service_noti.ServiceNotiPlugin")
            val field = pluginClass.getDeclaredField("foregroundServiceRunning")
            field.isAccessible = true
            field.setBoolean(null, true)
        } catch (e: Exception) {
            Log.w(TAG, "Could not update plugin status: ${e.message}")
        }
        
        // Start foreground service with notification
        val notification = createNotification()
        startForeground(NOTIFICATION_ID, notification)
        
        // Start foreground work
        serviceScope.launch {
            startForegroundWork()
        }
        
        return START_STICKY
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Foreground Service Channel",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Channel for Foreground Service"
            }
            
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Foreground Service Running")
            .setContentText("Service is running in foreground")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }

    private suspend fun startForegroundWork() {
        var counter = 0
        while (isRunning) {
            Log.d(TAG, "Foreground work running... Count: ${++counter}")
            
            // Update notification with counter
            val updatedNotification = NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("Foreground Service Running")
                .setContentText("Running for ${counter * 3} seconds")
                .setSmallIcon(android.R.drawable.ic_dialog_info)
                .setPriority(NotificationCompat.PRIORITY_LOW)
                .build()
            
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.notify(NOTIFICATION_ID, updatedNotification)
            
            delay(3000) // Wait 3 seconds
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d(TAG, "Foreground Service Destroyed")
        isRunning = false
        serviceJob.cancel()
        stopForeground(true)
        
        // Update status in ServiceNotiPlugin
        try {
            val pluginClass = Class.forName("com.example.service_noti.ServiceNotiPlugin")
            val field = pluginClass.getDeclaredField("foregroundServiceRunning")
            field.isAccessible = true
            field.setBoolean(null, false)
        } catch (e: Exception) {
            Log.w(TAG, "Could not update plugin status: ${e.message}")
        }
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    fun stopService() {
        isRunning = false
        stopSelf()
    }
}
