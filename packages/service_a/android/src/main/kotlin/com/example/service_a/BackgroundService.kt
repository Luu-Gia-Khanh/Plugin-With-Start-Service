package com.example.service_a

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.util.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class BackgroundService : Service() {
    private val serviceJob = Job()
    private val serviceScope = CoroutineScope(Dispatchers.Default + serviceJob)
    
    companion object {
        private const val TAG = "BackgroundService"
        @JvmField
        var isRunning = false
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "Background Service Created")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "Background Service Started")
        isRunning = true
        
        // Update status in ServiceNotiPlugin
        try {
            val pluginClass = Class.forName("com.example.service_noti.ServiceNotiPlugin")
            val field = pluginClass.getDeclaredField("backgroundServiceRunning")
            field.isAccessible = true
            field.setBoolean(null, true)
        } catch (e: Exception) {
            Log.w(TAG, "Could not update plugin status: ${e.message}")
        }
        
        // Start background work
        serviceScope.launch {
            startBackgroundWork()
        }
        
        return START_STICKY // Service will be restarted if killed
    }

    private suspend fun startBackgroundWork() {
        Log.d(TAG, "Background work started HEHE")
        var counter = 0
        while (isRunning) {
            Log.d(TAG, "Background work running... Count: ${++counter}")
            // Simulate background work
            delay(5000) // Wait 5 seconds
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d(TAG, "Background Service Destroyed")
        isRunning = false
        serviceJob.cancel()
        
        // Update status in ServiceNotiPlugin
        try {
            val pluginClass = Class.forName("com.example.service_noti.ServiceNotiPlugin")
            val field = pluginClass.getDeclaredField("backgroundServiceRunning")
            field.isAccessible = true
            field.setBoolean(null, false)
        } catch (e: Exception) {
            Log.w(TAG, "Could not update plugin status: ${e.message}")
        }
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null // We don't provide binding
    }

    fun stopService() {
        isRunning = false
        stopSelf()
    }
}
