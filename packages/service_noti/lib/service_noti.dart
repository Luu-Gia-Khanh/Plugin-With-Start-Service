import 'service_noti_platform_interface.dart';

class ServiceNoti {
  Future<String?> getPlatformVersion() {
    return ServiceNotiPlatform.instance.getPlatformVersion();
  }

  Future<String?> startBackgroundService() {
    return ServiceNotiPlatform.instance.startBackgroundService();
  }

  Future<String?> stopBackgroundService() {
    return ServiceNotiPlatform.instance.stopBackgroundService();
  }

  Future<String?> startForegroundService() {
    return ServiceNotiPlatform.instance.startForegroundService();
  }

  Future<String?> stopForegroundService() {
    return ServiceNotiPlatform.instance.stopForegroundService();
  }

  Future<Map<String, dynamic>?> getServiceStatus() {
    return ServiceNotiPlatform.instance.getServiceStatus();
  }
}
