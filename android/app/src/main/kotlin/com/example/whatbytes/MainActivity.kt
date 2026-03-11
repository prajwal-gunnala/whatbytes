package com.example.whatbytes

import android.content.Intent
import android.graphics.BitmapFactory
import androidx.core.app.Person
import androidx.core.content.pm.ShortcutInfoCompat
import androidx.core.content.pm.ShortcutManagerCompat
import androidx.core.graphics.drawable.IconCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "configureConversationShortcut" -> {
                        try {
                            configureConversationShortcut()
                            result.success(null)
                        } catch (e: Exception) {
                            result.error(
                                "shortcut_error",
                                e.message ?: "Failed to configure conversation shortcut",
                                null
                            )
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun configureConversationShortcut() {
        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
            action = Intent.ACTION_VIEW
        } ?: Intent(this, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
        }

        val iconBitmap = BitmapFactory.decodeResource(
            resources,
            R.drawable.burnmate_notification_large
        )
        val iconCompat = IconCompat.createWithBitmap(iconBitmap)
        val person = Person.Builder()
            .setName("BurnMate")
            .setKey(CONVERSATION_SHORTCUT_ID)
            .setImportant(true)
            .setIcon(iconCompat)
            .build()

        val shortcut = ShortcutInfoCompat.Builder(this, CONVERSATION_SHORTCUT_ID)
            .setShortLabel("BurnMate")
            .setLongLabel("BurnMate notifications")
            .setIcon(iconCompat)
            .setIntent(launchIntent)
            .setLongLived(true)
            .setPerson(person)
            .build()

        ShortcutManagerCompat.pushDynamicShortcut(this, shortcut)
    }

    companion object {
        private const val CHANNEL = "burnmate/shortcuts"
        private const val CONVERSATION_SHORTCUT_ID = "burnmate_notifications"
    }
}
