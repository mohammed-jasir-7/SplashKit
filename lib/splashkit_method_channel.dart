import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'splashkit_platform_interface.dart';

/// An implementation of [SplashkitPlatform] that uses method channels.
class MethodChannelSplashkit extends SplashkitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('splashkit');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
