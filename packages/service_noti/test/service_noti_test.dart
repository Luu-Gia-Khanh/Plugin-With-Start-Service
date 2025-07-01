import 'package:flutter_test/flutter_test.dart';
import 'package:service_noti/service_noti.dart';
import 'package:service_noti/service_noti_platform_interface.dart';
import 'package:service_noti/service_noti_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockServiceNotiPlatform
    with MockPlatformInterfaceMixin
    implements ServiceNotiPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ServiceNotiPlatform initialPlatform = ServiceNotiPlatform.instance;

  test('$MethodChannelServiceNoti is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelServiceNoti>());
  });

  test('getPlatformVersion', () async {
    ServiceNoti serviceNotiPlugin = ServiceNoti();
    MockServiceNotiPlatform fakePlatform = MockServiceNotiPlatform();
    ServiceNotiPlatform.instance = fakePlatform;

    expect(await serviceNotiPlugin.getPlatformVersion(), '42');
  });
}
