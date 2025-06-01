#!/usr/bin/env dart
import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

void main(List<String> args) async {
  stderr.writeln('\n\n\n-------  🔧 AVD Splash Screen Setup Tool ------');
  stderr.writeln('⚙️  Building Android splash screen...');

  final rootDir = Directory.current.path;

  final pubspecFile = File(p.join(rootDir, 'pubspec.yaml'));
  if (!pubspecFile.existsSync()) {
    stderr.writeln('❌ Error: pubspec.yaml not found in the current directory.');
    stderr.writeln(
      '➡️  Please make sure you are running this command from the root of a Flutter project.',
    );

    return;
  }

  final pubspecContent = pubspecFile.readAsStringSync();
  final pubspec = loadYaml(pubspecContent);

  if (pubspec['avd_splash'] == null) {
    stderr.writeln(
      '❌ Missing `avd_splash` configuration in pubspec.yaml.\nPlease define it like:\n\navd_splash:\n  package: com.example.app\n  animated_icon: assets/splash/animation.xml\n  post_theme: AppTheme',
    );

    return;
  }

  final animatedIcon = pubspec['avd_splash']['animated_icon'] as String?;
  final postTheme =
      pubspec['avd_splash']['post_theme'] as String? ?? 'AppTheme';
  final packageName = pubspec['avd_splash']['package'] as String?;
  if (packageName == null) {
    stderr.writeln(
      '❌ Missing `package_name` in `avd_splash` configuration.\nPlease add it like:\n\navd_splash:\n  package: com.example.app\n  animated_icon: assets/splash/animation.xml\n  post_theme: AppTheme',
    );

    return;
  }

  if (animatedIcon == null) {
    stderr.writeln(
      '❌ Missing `animated_icon` in `avd_splash` configuration.\nPlease add it like:\n\navd_splash:\n  package: com.example.app\n  animated_icon: assets/splash/animation.xml\n  post_theme: AppTheme',
    );
    return;
  }

  stdout.writeln('✨✅ AVD Splash Configuration Found 🎉');
  stdout.writeln('📁 Animated Icon Path  : $animatedIcon');
  stdout.writeln('🎨 Post Theme          : $postTheme');
  stdout.writeln('🚀 Ready to set up your Android splash screen!');

  // Paths
  final androidResDrawable = p.join(
    rootDir,
    'android',
    'app',
    'src',
    'main',
    'res',
    'drawable',
  );
  final androidManifestFile = File(
    p.join(rootDir, 'android', 'app', 'src', 'main', 'AndroidManifest.xml'),
  );
  final stylesFile = File(
    p.join(
      rootDir,
      'android',
      'app',
      'src',
      'main',
      'res',
      'values',
      'styles.xml',
    ),
  );
  final assetAvdFile = File(p.join(rootDir, animatedIcon));

  if (!assetAvdFile.existsSync()) {
    stderr.writeln('🚫 AVD animated icon not found at path: $animatedIcon ❗');
    stderr.writeln('💡 Please check the "animated_icon" path in pubspec.yaml.');

    return;
  }

  // Copy AVD XML to drawable
  final drawableFileName = p.basename(animatedIcon);
  final targetDrawableFile = File(p.join(androidResDrawable, drawableFileName));
  assetAvdFile.copySync(targetDrawableFile.path);
  //print('Copied AVD XML to $targetDrawableFile');

  // Update build.gradle
  stdout.writeln('⚙️ Upgrading build.gradle file...');

  final buildGradleFile = File(
    p.join(rootDir, 'android', 'app', 'build.gradle.kts'),
  );
  if (!buildGradleFile.existsSync()) {
    stderr.writeln('❌ android/app/build.gradle not found!');
  } else {
    final gradleContent = buildGradleFile.readAsStringSync();
    const splashDependency =
        'implementation ("androidx.core:core-splashscreen:1.0.1")';
    const material =
        'implementation ("com.google.android.material:material:1.10.0")';
    bool isContainsMaterial = false;
    if (gradleContent.contains('com.google.android.material:material')) {
      isContainsMaterial = true;
    }
    String updatedGradle;

    if (!gradleContent.contains('androidx.core:core-splashscreen')) {
      if (gradleContent.contains(RegExp(r'dependencies\s*\{'))) {
        // ✅ dependencies block exists, inject line inside
        updatedGradle = gradleContent.replaceFirstMapped(
          RegExp(r'dependencies\s*\{'),
          (match) => '${match.group(0)}\n    $splashDependency',
        );
        if (!isContainsMaterial) {
          updatedGradle = updatedGradle.replaceFirstMapped(
            RegExp(r'dependencies\s*\{'),
            (match) => '${match.group(0)}\n    $material',
          );
        }
        stdout.writeln('✅ Successfully upgraded build.gradle');
      } else {
        // ❌ dependencies block doesn't exist, append one at the end

        if (isContainsMaterial) {
          updatedGradle =
              '''
$gradleContent


dependencies {
    $splashDependency
    

}
''';
        } else {
          updatedGradle =
              '''
$gradleContent


dependencies {
    $splashDependency
    $material
    

}
''';
        }
      }

      // Write updated content back
      buildGradleFile.writeAsStringSync(updatedGradle);
    } else {}
  }

  // Update MainActivity.kt
  final mainActivityPath = getMainActivityPath(rootDir, packageName);
  final mainActivityFile = File(mainActivityPath);
  if (!mainActivityFile.existsSync()) {
    stderr.writeln(
      '❌ MainActivity.kt not found! Please ensure it exists at the correct path.',
    );
  } else {
    var mainActivityContent = mainActivityFile.readAsStringSync();

    if (!mainActivityContent.contains(
      'androidx.core.splashscreen.SplashScreen',
    )) {
      mainActivityContent =
          '''
package $packageName
import android.os.Bundle
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import io.flutter.embedding.android.FlutterActivity


class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        val splashScreen = installSplashScreen()
        super.onCreate(savedInstanceState)

        // Optional: control splash screen visibility duration or animation
        splashScreen.setKeepOnScreenCondition {
            // You can keep splash screen until Flutter is ready
            false // return true to keep, false to dismiss
        }
    }
}
''';
      mainActivityFile.writeAsStringSync(mainActivityContent);
      stdout.writeln('✅ MainActivity.kt updated with SplashScreen API');
    } else {
      stdout.writeln('ℹ️ MainActivity.kt already uses SplashScreen API');
    }
  }

  // Update AndroidManifest.xml
  final manifestContent = androidManifestFile.readAsStringSync();
  final newManifestContent = manifestContent.replaceAllMapped(
    RegExp(
      r'(<activity[^>]*android:name="\.MainActivity"[^>]*)(android:theme="[^"]*")?([^>]*>)',
    ),
    (m) {
      
      final prefix = m.group(1) ?? '';
      final existingTheme = m.group(2);
      final suffix = m.group(3) ?? '';

    //  final newThemeAttr = 'android:theme="@style/LaunchTheme"';
     
      if (existingTheme != null) {
        // Replace existing theme
        return prefix  + suffix;
      } else {
        // Add theme attribute
        return '$prefix $suffix';
      }
    },
  );

  androidManifestFile.writeAsStringSync(newManifestContent);

  stdout.writeln('✅ AndroidManifest.xml updated with LaunchTheme');

  // Update styles.xml (basic example, overwrite or add LaunchTheme and AppTheme)
  final stylesContent =
      '''
<resources>
    <style name="LaunchTheme" parent="Theme.SplashScreen">
        <item name="windowSplashScreenAnimatedIcon">@drawable/${p.basenameWithoutExtension(drawableFileName)}</item>
        <item name="postSplashScreenTheme">@style/$postTheme</item>
    </style>

    <style name="$postTheme" parent="Theme.Material3.DayNight.NoActionBar">
        <!-- Flutter will take over -->
    </style>
</resources>
''';

  stylesFile.writeAsStringSync(stylesContent);

  stdout.writeln('✅ styles.xml updated with LaunchTheme and $postTheme');
  stdout.writeln('🎉 Android splash screen setup complete! 🎉\n\n');
}

String getMainActivityPath(String rootDir, String packageName) {
  final packagePath = packageName.replaceAll(
    '.',
    Platform.pathSeparator,
  ); // => com/example/test2

  return p.join(
    rootDir,
    'android',
    'app',
    'src',
    'main',
    'kotlin',
    packagePath,
    'MainActivity.kt',
  );
}
