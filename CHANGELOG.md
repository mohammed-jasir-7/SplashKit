## 0.0.1
# Changelog

All notable changes to this project will be documented in this file.

## [0.0.1] - 2025-06-01

### 🎉 Initial Release

- Added support for creating native Android splash screens using AVD files.
- Automatically updates:
  - `AndroidManifest.xml` with splash theme.
  - `MainActivity.kt` with splash configuration.
  - `build.gradle` with splashscreen dependency.
- Supports Flutter apps targeting Android 12 and above.
- CLI command `splashkit` now available via global install or `dart run splashkit`.
