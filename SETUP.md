# WhatBytes - Setup Guide

## 🚀 Complete Setup Instructions

### Step 1: Firebase Project Setup

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com)
   - Click "Add project"
   - Enter project name: `whatbytes-e5955` (or your preferred name)
   - Disable Google Analytics (optional)
   - Click "Create project"

2. **Enable Authentication**
   - In Firebase Console, go to **Authentication**
   - Click "Get started"
   - Select **Email/Password** under Sign-in providers
   - Enable it and click "Save"

3. **Create Firestore Database**
   - Go to **Firestore Database**
   - Click "Create database"
   - Select **Start in production mode** (we'll add rules)
   - Choose a location closest to your users
   - Click "Enable"

4. **Deploy Security Rules**
   - In your project terminal:
   ```bash
   firebase login
   firebase init firestore
   # When prompted, select the firestore.rules file
   firebase deploy --only firestore:rules
   ```

   Or manually copy rules from `firestore.rules` to Firebase Console → Firestore → Rules tab

### Step 2: Android Configuration

1. **Add Android App in Firebase**
   - In Firebase Console, click Android icon
   - Package name: `com.example.whatbytes`
   - Download `google-services.json`
   - Place it in `android/app/` directory

2. **Or Use FlutterFire CLI (Recommended)**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Add to PATH (if not already)
   export PATH="$PATH":"$HOME/.pub-cache/bin"
   
   # Configure Firebase
   flutterfire configure --project=whatbytes-e5955
   ```

### Step 3: Install Dependencies

```bash
flutter pub get
```

### Step 4: Run the App

```bash
# Check connected devices
flutter devices

# Run on connected Android device/emulator
flutter run

# Or run in release mode
flutter run --release
```

### Step 5: Test the App

1. **Create an Account**
   - Open the app
   - Tap "Sign Up" on login screen
   - Enter your details
   - Create account

2. **Create Tasks**
   - Tap the + button
   - Fill in task details
   - Select priority
   - Choose due date
   - Save

3. **Manage Tasks**
   - Tap checkbox to complete/uncomplete
   - Tap task card to edit
   - Tap delete icon to remove
   - Use filter menu to show All/Pending/Completed
   - Use sort menu to organize by date/priority

## 🔧 Troubleshooting

### Issue: Firebase not initialized
**Solution:** Ensure `google-services.json` is in `android/app/` and run:
```bash
flutterfire configure --project=YOUR_PROJECT_ID
```

### Issue: Build fails with "Execution failed for task ':app:processDebugGoogleServices'"
**Solution:** Check that package name in:
- `android/app/build.gradle.kts` → `applicationId = "com.example.whatbytes"`
- `google-services.json` → `"package_name": "com.example.whatbytes"`
Match exactly.

### Issue: Firestore permission denied
**Solution:** Deploy security rules:
```bash
firebase deploy --only firestore:rules
```

### Issue: Logo not showing
**Solution:** Ensure `assets/logo.png` exists and `pubspec.yaml` has:
```yaml
flutter:
  assets:
    - assets/logo.png
```
Then run: `flutter clean && flutter pub get`

## 📱 Building for Release

### Create Release APK
```bash
flutter build apk --release
```
APK location: `build/app/outputs/flutter-apk/app-release.apk`

### Create App Bundle (for Play Store)
```bash
flutter build appbundle --release
```
Bundle location: `build/app/outputs/bundle/release/app-release.aab`

### Signing (for Production)

1. **Create Keystore**
   ```bash
   keytool -genkey -v -keystore ~/whatbytes-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias whatbytes
   ```

2. **Create key.properties**
   File: `android/key.properties`
   ```properties
   storePassword=YOUR_STORE_PASSWORD
   keyPassword=YOUR_KEY_PASSWORD
   keyAlias=whatbytes
   storeFile=/home/username/whatbytes-key.jks
   ```

3. **Update android/app/build.gradle.kts**
   ```kotlin
   // Add before android block
   val keystoreProperties = Properties()
   val keystorePropertiesFile = rootProject.file("key.properties")
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(FileInputStream(keystorePropertiesFile))
   }
   
   // Inside android block
   signingConfigs {
       create("release") {
           keyAlias = keystoreProperties["keyAlias"] as String
           keyPassword = keystoreProperties["keyPassword"] as String
           storeFile = file(keystoreProperties["storeFile"] as String)
           storePassword = keystoreProperties["storePassword"] as String
       }
   }
   
   buildTypes {
       release {
           signingConfig = signingConfigs.getByName("release")
       }
   }
   ```

4. **Build Signed APK**
   ```bash
   flutter build apk --release
   ```

## 🎨 Customization

### Change App Name
- Android: `android/app/src/main/AndroidManifest.xml` → `android:label`
- Constants: `lib/core/constants/app_constants.dart` → `appName`

### Change Package Name
```bash
# Using rename package
flutter pub global activate rename
flutter pub global run rename --bundleId com.yourcompany.yourapp
```

### Change Theme Colors
Edit `lib/core/theme/app_colors.dart`:
```dart
static const Color primaryColor = Color(0xFF6366F1);  // Change this
static const Color accentColor = Color(0xFF22D3EE);   // Change this
static const Color bgPrimary = Color(0xFF0F172A);     // Change this
```

### Change App Icon
1. Replace `assets/logo.png` with your icon (1024x1024 recommended)
2. Use flutter_launcher_icons package or manually update:
   - Android: `android/app/src/main/res/mipmap-*/ic_launcher.png`

## 📊 Firebase Console Tips

### View Users
**Authentication → Users** - See all registered users

### View Tasks
**Firestore Database → tasks collection** - See all tasks (admin only)

### Monitor Usage
**Usage** tab - Track API calls, storage, bandwidth

### Set Budget Alerts
**Firestore → Usage → Set up budget alerts** - Get notified before overages

## 🔒 Security Best Practices

1. **Never commit these files:**
   - `android/app/google-services.json`
   - `android/key.properties`
   - `ios/Runner/GoogleService-Info.plist`
   - Any keystore files

2. **Add to .gitignore:**
   ```
   **/google-services.json
   **/key.properties
   **/*.jks
   ```

3. **Use environment variables for sensitive data**

4. **Keep Firebase rules strict** - Only allow authenticated users

5. **Enable App Check** (optional) - Prevent API abuse

## 📈 Performance Tips

1. **Enable Firestore offline persistence** (already enabled in code)
2. **Use indexes for complex queries** (Firebase will prompt in console)
3. **Paginate large lists** (implement if > 100 tasks)
4. **Cache images and assets**
5. **Use Flutter DevTools** to profile performance

## 🎓 Next Steps

- [ ] Add task categories/tags
- [ ] Implement task notifications
- [ ] Add dark/light theme toggle
- [ ] Export tasks to CSV/PDF
- [ ] Add task attachments
- [ ] Implement task sharing
- [ ] Add analytics
- [ ] Create iOS version

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Riverpod Documentation](https://riverpod.dev/)
- [Material Design 3](https://m3.material.io/)

---

**Need Help?** Open an issue on GitHub or check the README.md for contact info.
