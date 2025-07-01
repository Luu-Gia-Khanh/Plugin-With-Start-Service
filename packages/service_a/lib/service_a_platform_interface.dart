import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'service_a_method_channel.dart';

abstract class Service_aPlatform extends PlatformInterface {
  /// Constructs a Service_aPlatform.
  Service_aPlatform() : super(token: _token);

  static final Object _token = Object();

  static Service_aPlatform _instance = MethodChannelService_a();

  /// The default instance of [Service_aPlatform] to use.
  ///
  /// Defaults to [MethodChannelService_a].
  static Service_aPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Service_aPlatform] when
  /// they register themselves.
  static set instance(Service_aPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
