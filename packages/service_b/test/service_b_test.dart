import 'package:flutter_test/flutter_test.dart';
import 'package:service_b/service_b.dart';
import 'package:service_b/service_b_platform_interface.dart';
import 'package:service_b/service_b_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockService_bPlatform
    with MockPlatformInterfaceMixin
    implements Service_bPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final Service_bPlatform initialPlatform = Service_bPlatform.instance;

  test('$MethodChannelService_b is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelService_b>());
  });

  test('getPlatformVersion', () async {
    Service_b service_bPlugin = Service_b();
    MockService_bPlatform fakePlatform = MockService_bPlatform();
    Service_bPlatform.instance = fakePlatform;

    expect(await service_bPlugin.getPlatformVersion(), '42');
  });
}
