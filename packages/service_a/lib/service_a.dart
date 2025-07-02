import 'service_a_platform_interface.dart';

class Service_a {
  Future<String?> getPlatformVersion() {
    return Service_aPlatform.instance.getPlatformVersion();
  }

  Future<String?> startBackgroundService() {
    return Service_aPlatform.instance.startBackgroundService();
  }

  Future<String?> stopBackgroundService() {
    return Service_aPlatform.instance.stopBackgroundService();
  }
}
