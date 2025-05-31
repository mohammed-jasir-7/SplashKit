import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

void main(List<String> args) async {
  final rootDir = Directory.current.path;

  final pubspecFile = File(p.join(rootDir, 'pubspec.yaml'));
  if (!pubspecFile.existsSync()) {
    print('pubspec.yaml not found!');
    return;
  }

  final pubspecContent = pubspecFile.readAsStringSync();
  final pubspec = loadYaml(pubspecContent);

  if (pubspec['avd_splash'] == null) {
    print('avd_splash config not found in pubspec.yaml!');
    return;
  }

  final animatedIcon = pubspec['avd_splash']['animated_icon'] as String?;
  final postTheme = pubspec['avd_splash']['post_theme'] as String? ?? 'AppTheme';

  if (animatedIcon == null) {
    print('animated_icon path missing!');
    return;
  }

  print('Config found:');
  print('animated_icon: $animatedIcon');
  print('post_theme: $postTheme');

  // Paths
  final androidResDrawable = p.join(rootDir, 'android', 'app', 'src', 'main', 'res', 'drawable');
  final androidManifestFile = File(p.join(rootDir, 'android', 'app', 'src', 'main', 'AndroidManifest.xml'));
  final stylesFile = File(p.join(rootDir, 'android', 'app', 'src', 'main', 'res', 'values', 'styles.xml'));
  final assetAvdFile = File(p.join(rootDir, animatedIcon));

  if (!assetAvdFile.existsSync()) {
    print('AVD XML file not found at $animatedIcon');
    return;
  }

  // Copy AVD XML to drawable
  final drawableFileName = p.basename(animatedIcon);
  final targetDrawableFile = File(p.join(androidResDrawable, drawableFileName));
  assetAvdFile.copySync(targetDrawableFile.path);
  print('Copied AVD XML to $targetDrawableFile');

// Update build.gradle
final buildGradleFile = File(p.join(rootDir, 'android', 'app', 'build.gradle'));
if (!buildGradleFile.existsSync()) {
  stderr.writeln('❌ android/app/build.gradle not found!');
} else {
  final gradleContent = buildGradleFile.readAsStringSync();

  if (!gradleContent.contains('androidx.core:core-splashscreen')) {
    final updatedGradle = gradleContent.replaceFirstMapped(
      RegExp(r'dependencies\s*\{'),
      (m) => '${m.group(0)}\n    implementation "androidx.core:core-splashscreen:1.0.1"',
    );

    buildGradleFile.writeAsStringSync(updatedGradle);
    stdout.writeln('✅ Added androidx.core:core-splashscreen to build.gradle');
  } else {
    stdout.writeln('ℹ️ SplashScreen dependency already present in build.gradle');
  }
}

// Update MainActivity.kt
final mainActivityPath = getMainActivityPath(rootDir);
final mainActivityFile = File(mainActivityPath);
if (!mainActivityFile.existsSync()) {
  stderr.writeln('❌ MainActivity.kt not found!');
} else {
  var mainActivityContent = mainActivityFile.readAsStringSync();
  //get the package name from AndroidManifest.xml
  final manifestContent = androidManifestFile.readAsStringSync();
  final packageMatch = RegExp(r'package="([^"]+)"').firstMatch(manifestContent);
  if (packageMatch == null) {
    stderr.writeln('❌ Could not find package name in AndroidManifest.xml');
    return;
  }
  final packageName = packageMatch.group(1)!; // e.g. com.example.test2

  if (!mainActivityContent.contains('androidx.core.splashscreen.SplashScreen')) {
    mainActivityContent = '''
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
    RegExp(r'(<activity[^>]*android:name="\.MainActivity"[^>]*)(android:theme="[^"]*")?([^>]*>)'),
    (m) {
      final prefix = m.group(1) ?? '';
      final existingTheme = m.group(2);
      final suffix = m.group(3) ?? '';

      final newThemeAttr = 'android:theme="@style/LaunchTheme"';
      if (existingTheme != null) {
        // Replace existing theme
        return prefix + newThemeAttr + suffix;
      } else {
        // Add theme attribute
        return prefix + ' ' + newThemeAttr + suffix;
      }
    },
  );

  androidManifestFile.writeAsStringSync(newManifestContent);
  print('Updated AndroidManifest.xml with LaunchTheme');

  // Update styles.xml (basic example, overwrite or add LaunchTheme and AppTheme)
  final stylesContent = '''
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
  print('Updated styles.xml with LaunchTheme and $postTheme');
}

String getMainActivityPath(String rootDir) {
  final manifestFile = File(p.join(rootDir, 'android', 'app', 'src', 'main', 'AndroidManifest.xml'));
  if (!manifestFile.existsSync()) {
    throw Exception('AndroidManifest.xml not found!');
  }

  final content = manifestFile.readAsStringSync();
  final packageMatch = RegExp(r'package="([^"]+)"').firstMatch(content);

  if (packageMatch == null) {
    throw Exception('Could not find package name in AndroidManifest.xml');
  }

  final packageName = packageMatch.group(1)!; // e.g. com.example.test2
  final packagePath = packageName.replaceAll('.', Platform.pathSeparator); // => com/example/test2

  return p.join(rootDir, 'android', 'app', 'src', 'main', 'kotlin', packagePath, 'MainActivity.kt');
}

