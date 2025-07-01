
import 'service_a_platform_interface.dart';

class Service_a {
  Future<String?> getPlatformVersion() {
    return Service_aPlatform.instance.getPlatformVersion();
  }
}
