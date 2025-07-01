# start_service_flutter

A Flutter project demonstrating multi-module service management with background and foreground Android services.

## Project Overview

This project implements a Flutter plugin (`service_noti`) that can start, stop, and track the status of Android services from separate packages. The architecture uses a multi-module approach where service implementations are in separate packages and controlled through a central plugin.

## Architecture

### Module Structure
```
start_service_flutter/
├── packages/
│   ├── service_a/          # Background Service Package
│   ├── service_b/          # Foreground Service Package
│   └── service_noti/       # Main Plugin Package
│       └── example/        # Demo App
```

### Service Packages

#### service_a (Background Service)
- **Location**: `packages/service_a/android/src/main/kotlin/com/example/service_a/`
- **Main Class**: `BackgroundService.kt`
- **Purpose**: Implements a background service with coroutine-based work
- **Status Tracking**: Uses `@JvmField var isRunning = false` for status tracking

#### service_b (Foreground Service) 
- **Location**: `packages/service_b/android/src/main/kotlin/com/example/service_b/`
- **Main Class**: `ForegroundService.kt`
- **Purpose**: Implements a foreground service with notification support
- **Status Tracking**: Uses `@JvmField var isRunning = false` for status tracking

#### service_noti (Main Plugin)
- **Location**: `packages/service_noti/android/src/main/kotlin/com/example/service_noti/`
- **Main Class**: `ServiceNotiPlugin.kt`
- **Purpose**: Flutter plugin that manages external services via method channels

## Flow Diagram

```
Flutter UI (Dart)
       ↕ (Method Channel)
ServiceNotiPlugin.kt
       ↕ (Direct Service Class Registration)
MainActivity.kt
       ↕ (Direct Import)
BackgroundService.kt + ForegroundService.kt
```

## Code Flow

### 1. Service Registration Flow
```kotlin
// MainActivity.kt
import com.example.service_a.BackgroundService
import com.example.service_b.ForegroundService

override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    val serviceNotiPlugin = flutterEngine.plugins.get(ServiceNotiPlugin::class.java)
    serviceNotiPlugin?.registerServices(
        backgroundServiceClass = BackgroundService::class.java,
        foregroundServiceClass = ForegroundService::class.java
    )
}
```

### 2. Plugin Method Handling Flow
```kotlin
// ServiceNotiPlugin.kt
override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
        "startBackgroundService" -> {
            val intent = Intent(context, backgroundServiceClass)
            context.startService(intent)
        }
        "getServiceStatus" -> {
            // Use reflection to access isRunning field
            val field = backgroundServiceClass!!.getDeclaredField("isRunning")
            val status = field.getBoolean(null)
        }
    }
}
```

### 3. Flutter-to-Native Communication
```dart
// Flutter (Dart side)
final result = await ServiceNoti.startBackgroundService();
final status = await ServiceNoti.getServiceStatus();
```

## Key Features

### 1. Multi-Module Architecture
- **Separation of Concerns**: Each service is in its own package
- **Reusability**: Services can be used independently
- **Maintainability**: Clear module boundaries

### 2. Direct Import Approach
- **Type Safety**: Compile-time checking of service classes
- **Performance**: No reflection for service instantiation
- **Simplicity**: Straightforward import and registration

### 3. Method Channel Communication
- **Bidirectional**: Flutter ↔ Android communication
- **Async Support**: Non-blocking service operations
- **Error Handling**: Proper error propagation to Flutter

### 4. Service Status Tracking
- **Real-time Status**: Track if services are running
- **Reflection Access**: Access static fields across modules
- **Status API**: Unified status checking interface

## Build Configuration

### Gradle Dependencies
```kotlin
// service_noti/android/build.gradle
dependencies {
    implementation project(':service_a')  // Background service
    implementation project(':service_b')  // Foreground service
}
```

### Settings Configuration
```kotlin
// example/android/settings.gradle.kts
include(":service_a")
project(":service_a").projectDir = file("../../../service_a/android")

include(":service_b") 
project(":service_b").projectDir = file("../../../service_b/android")
```

## Usage

### Start Background Service
```dart
String result = await ServiceNoti.startBackgroundService();
```

### Start Foreground Service
```dart
String result = await ServiceNoti.startForegroundService();
```

### Check Service Status
```dart
Map<String, dynamic> status = await ServiceNoti.getServiceStatus();
bool backgroundRunning = status['backgroundRunning'];
bool foregroundRunning = status['foregroundRunning'];
```

### Stop Services
```dart
await ServiceNoti.stopBackgroundService();
await ServiceNoti.stopForegroundService();
```

## Android Manifest Configuration

Services must be registered in the example app's AndroidManifest.xml:

```xml
<!-- Background Service from service_a package -->
<service
    android:name="com.example.service_a.BackgroundService"
    android:enabled="true"
    android:exported="false" />

<!-- Foreground Service from service_b package -->
<service
    android:name="com.example.service_b.ForegroundService"
    android:enabled="true"
    android:exported="false"
    android:foregroundServiceType="dataSync" />
```

## Advantages of This Approach

1. **Clean Architecture**: Clear separation between service logic and plugin logic
2. **Type Safety**: Compile-time verification of service classes
3. **Performance**: No reflection overhead for service operations
4. **Maintainability**: Easy to add new services or modify existing ones
5. **Reusability**: Service packages can be used in other projects
6. **Testability**: Each module can be tested independently

## Future Enhancements

- Add service configuration parameters
- Implement service lifecycle callbacks
- Add service dependency injection
- Support for custom service types
- Add service monitoring and analytics
# Plugin-With-Start-Service
