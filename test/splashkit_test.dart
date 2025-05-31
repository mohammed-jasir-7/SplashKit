import 'package:flutter_test/flutter_test.dart';
import 'package:splashkit/splashkit.dart';
import 'package:splashkit/splashkit_platform_interface.dart';
import 'package:splashkit/splashkit_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSplashkitPlatform
    with MockPlatformInterfaceMixin
    implements SplashkitPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SplashkitPlatform initialPlatform = SplashkitPlatform.instance;

  test('$MethodChannelSplashkit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSplashkit>());
  });

  test('getPlatformVersion', () async {
    Splashkit splashkitPlugin = Splashkit();
    MockSplashkitPlatform fakePlatform = MockSplashkitPlatform();
    SplashkitPlatform.instance = fakePlatform;

    expect(await splashkitPlugin.getPlatformVersion(), '42');
  });
}
