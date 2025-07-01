
import 'service_b_platform_interface.dart';

class Service_b {
  Future<String?> getPlatformVersion() {
    return Service_bPlatform.instance.getPlatformVersion();
  }
}
