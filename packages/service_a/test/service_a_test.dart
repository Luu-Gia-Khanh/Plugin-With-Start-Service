import 'package:flutter_test/flutter_test.dart';
import 'package:service_a/service_a.dart';
import 'package:service_a/service_a_platform_interface.dart';
import 'package:service_a/service_a_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockService_aPlatform
    with MockPlatformInterfaceMixin
    implements Service_aPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final Service_aPlatform initialPlatform = Service_aPlatform.instance;

  test('$MethodChannelService_a is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelService_a>());
  });

  test('getPlatformVersion', () async {
    Service_a service_aPlugin = Service_a();
    MockService_aPlatform fakePlatform = MockService_aPlatform();
    Service_aPlatform.instance = fakePlatform;

    expect(await service_aPlugin.getPlatformVersion(), '42');
  });
}
