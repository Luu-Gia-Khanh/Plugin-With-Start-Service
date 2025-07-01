import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'service_noti_method_channel.dart';

abstract class ServiceNotiPlatform extends PlatformInterface {
  /// Constructs a ServiceNotiPlatform.
  ServiceNotiPlatform() : super(token: _token);

  static final Object _token = Object();

  static ServiceNotiPlatform _instance = MethodChannelServiceNoti();

  /// The default instance of [ServiceNotiPlatform] to use.
  ///
  /// Defaults to [MethodChannelServiceNoti].
  static ServiceNotiPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ServiceNotiPlatform] when
  /// they register themselves.
  static set instance(ServiceNotiPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> startBackgroundService() {
    throw UnimplementedError(
      'startBackgroundService() has not been implemented.',
    );
  }

  Future<String?> stopBackgroundService() {
    throw UnimplementedError(
      'stopBackgroundService() has not been implemented.',
    );
  }

  Future<String?> startForegroundService() {
    throw UnimplementedError(
      'startForegroundService() has not been implemented.',
    );
  }

  Future<String?> stopForegroundService() {
    throw UnimplementedError(
      'stopForegroundService() has not been implemented.',
    );
  }

  Future<Map<String, dynamic>?> getServiceStatus() {
    throw UnimplementedError('getServiceStatus() has not been implemented.');
  }
}
