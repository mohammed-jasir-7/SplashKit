import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'splashkit_method_channel.dart';

abstract class SplashkitPlatform extends PlatformInterface {
  /// Constructs a SplashkitPlatform.
  SplashkitPlatform() : super(token: _token);

  static final Object _token = Object();

  static SplashkitPlatform _instance = MethodChannelSplashkit();

  /// The default instance of [SplashkitPlatform] to use.
  ///
  /// Defaults to [MethodChannelSplashkit].
  static SplashkitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SplashkitPlatform] when
  /// they register themselves.
  static set instance(SplashkitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
