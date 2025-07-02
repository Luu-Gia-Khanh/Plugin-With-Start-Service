import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'service_b_method_channel.dart';

abstract class Service_bPlatform extends PlatformInterface {
  /// Constructs a Service_bPlatform.
  Service_bPlatform() : super(token: _token);

  static final Object _token = Object();

  static Service_bPlatform _instance = MethodChannelService_b();

  /// The default instance of [Service_bPlatform] to use.
  ///
  /// Defaults to [MethodChannelService_b].
  static Service_bPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Service_bPlatform] when
  /// they register themselves.
  static set instance(Service_bPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
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
}
