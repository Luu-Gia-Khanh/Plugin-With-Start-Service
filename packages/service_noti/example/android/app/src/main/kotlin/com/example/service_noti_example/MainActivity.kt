package com.example.service_noti_example

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.example.service_noti.ServiceNotiPlugin
import com.example.service_a.BackgroundService
import com.example.service_b.ForegroundService

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        val serviceNotiPlugin = flutterEngine.plugins.get(ServiceNotiPlugin::class.java) as? ServiceNotiPlugin
        serviceNotiPlugin?.registerServices(
            backgroundServiceClass = BackgroundService::class.java,
            foregroundServiceClass = ForegroundService::class.java
        )
    }
}
