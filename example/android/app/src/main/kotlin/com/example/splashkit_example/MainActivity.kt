package com.example.splashkit_example
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
