import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'service_b_platform_interface.dart';

/// An implementation of [Service_bPlatform] that uses method channels.
class MethodChannelService_b extends Service_bPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('service_b');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
