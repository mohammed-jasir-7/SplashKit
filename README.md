https://buymeacoffee.com/mohammedjasir

# 🌊 SplashKit

**SplashKit** is a Dart CLI tool that automates the creation and configuration of native Android 12+ splash screens using **Animated Vector Drawable (AVD)** for Flutter apps.

---

## 🚀 Features

- ✅ Adds required Android dependencies for native splash
- 🛠 Modifies `AndroidManifest.xml`, `styles.xml`, and `MainActivity.kt`
- 🎨 Applies your custom AVD splash icon
- ⚙️ Easily configurable via `pubspec.yaml`

---

## 📦 Installation

### Activate globally:

```bash
dart pub global activate splashkit
```

> **Note:** Ensure Dart’s global bin is in your PATH:

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

Add this to your shell config file (`.zshrc`, `.bashrc`, etc.) for persistence.

---

## 🧪 Usage

In the root of your Flutter project, run:

```bash
splashkit
```

SplashKit will:

- Read config from `pubspec.yaml`
- Locate the AVD XML file
- Update your native Android splash screen setup

---

## ⚙️ Configuration

Add a block to your `pubspec.yaml`:

```yaml
avd_splash:
  animated_icon: assets/animated_icon.xml
  post_theme: AppTheme
  package_name: com.example.myapp
```

| Key             | Description                                                         |
|----------------|---------------------------------------------------------------------|
| `animated_icon`| Path to your AVD XML file                                           |
| `post_theme`   | The theme to apply after the splash screen                          |
| `package_name` | Your app’s package name (as used in `AndroidManifest.xml`)          |

---

## 📁 Example Project Layout

```
my_flutter_app/
├── assets/
│   └── animated_icon.xml
├── pubspec.yaml
└── android/
    └── app/
        ├── build.gradle
        ├── src/
        │   └── main/
        │       ├── AndroidManifest.xml
        │       ├── kotlin/com/example/myapp/MainActivity.kt
        │       └── res/values/styles.xml
```

---

## ✅ What It Edits

- `android/app/build.gradle` — adds `androidx.core:core-splashscreen`
- `AndroidManifest.xml` — sets splash theme
- `styles.xml` — applies post-splash theme
- `MainActivity.kt` — invokes `setTheme(...)`

---

## 🧾 Requirements

- Flutter app targeting Android 12 (API 31+) or newer
- A valid [AVD XML](https://developer.android.com/reference/android/graphics/drawable/AnimatedVectorDrawable) file

---

## 🛣 Roadmap

- [ ] Lottie-to-AVD converter
- [ ] Pre-Android 12 fallback
- [ ] Web and desktop splash support

---

## 🙋 Author

Built with ❤️ by [Mohammed Jasir](https://github.com/mjasir)

> Contributions welcome! Star ⭐️ the repo and open issues/PRs to improve it!

---

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.
