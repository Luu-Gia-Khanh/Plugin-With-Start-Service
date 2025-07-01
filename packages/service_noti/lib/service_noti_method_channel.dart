import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'service_noti_platform_interface.dart';

/// An implementation of [ServiceNotiPlatform] that uses method channels.
class MethodChannelServiceNoti extends ServiceNotiPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('service_noti');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<String?> startBackgroundService() async {
    final result = await methodChannel.invokeMethod<String>(
      'startBackgroundService',
    );
    return result;
  }

  @override
  Future<String?> stopBackgroundService() async {
    final result = await methodChannel.invokeMethod<String>(
      'stopBackgroundService',
    );
    return result;
  }

  @override
  Future<String?> startForegroundService() async {
    final result = await methodChannel.invokeMethod<String>(
      'startForegroundService',
    );
    return result;
  }

  @override
  Future<String?> stopForegroundService() async {
    final result = await methodChannel.invokeMethod<String>(
      'stopForegroundService',
    );
    return result;
  }

  @override
  Future<Map<String, dynamic>?> getServiceStatus() async {
    final result = await methodChannel.invokeMethod<Map>('getServiceStatus');
    return result?.cast<String, dynamic>();
  }
}
