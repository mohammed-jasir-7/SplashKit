
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

## Installation & Usage

### Run Locally (Inside Your Project)

If you have SplashKit added as a dev dependency or are inside its folder, run:

```bash
dart run splashkit
```



## 🛠️ Install Globally (Recommended)

#### windows :
To use SplashKit from anywhere in your terminal, install it globally:

### 1. Activate the package globally

```cmd
dart pub global activate --source=path .
```

_(Run the above command inside your SplashKit project folder.)_

### 2. Add Dart’s global executables folder to your system `PATH`

- Open **System Properties** → **Environment Variables**
- Under **User variables**, find or create a variable named `Path`
- Add:

```
%USERPROFILE%\AppData\Local\Pub\Cache\bin
```

### 3. Restart your terminal

After updating your environment variables, restart your terminal (Command Prompt, PowerShell, etc.).

### ✅ Done!

Now, you can run SplashKit anywhere:

```cmd
splashkit
```

#### macOS/Linux :
To use SplashKit from anywhere in your terminal, install it globally:

### 1. Activate the package globally

```bash
dart pub global activate --source=path .
```

_(Run the above command inside your SplashKit project folder.)_

### 2. Add Dart’s global executables folder to your system `PATH`

```bash
export PATH="$PATH:$HOME/.pub-cache/bin"
```

> Add the above line to your shell config file (`~/.zshrc`, `~/.bashrc`, or `~/.bash_profile`) to make it permanent.

### 3. Reload your shell configuration

```bash
source ~/.zshrc  # or source ~/.bashrc or ~/.bash_profile
```

### ✅ Done!

Now, you can run SplashKit anywhere:

```bash
splashkit
```
## 📁 Sample AVD

You can use this sample [Animated Vector Drawable](https://developer.android.com/reference/android/graphics/drawable/AnimatedVectorDrawable) to test the plugin:

🔗 [Download sample_avd.xml](https://github.com/mohammed-jasir-7/Files/blob/main/animation.xml)

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
  package: com.example.myapp
```

| Key             | Description                                                         |
|----------------|---------------------------------------------------------------------|
| `animated_icon`| Path to your AVD XML file                                           |
| `post_theme`   | The theme to apply after the splash screen                          |
| `package_name` | Your app’s package name (as used in `AndroidManifest.xml`)          |

---

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
- compileSdkVersion 35 or above 

---

## 🛣 Roadmap

- [ ] Lottie-to-AVD converter
- [ ] Pre-Android 12 fallback
- [ ] Web and desktop splash support

---

## Support Me ☕
If you enjoy my work, consider buying me a coffee!

[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-yellow?style=for-the-badge&logo=buy-me-a-coffee)](https://buymeacoffee.com/mohammedjasir)



## 🙋 Author

Built with ❤️ by [Jasir Bin Shihabudeen](https://github.com/mohammed-jasir-7)

> Contributions welcome! Star ⭐️ the repo and open issues/PRs to improve it!

---

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.
