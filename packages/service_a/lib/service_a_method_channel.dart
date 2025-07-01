import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'service_a_platform_interface.dart';

/// An implementation of [Service_aPlatform] that uses method channels.
class MethodChannelService_a extends Service_aPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('service_a');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
