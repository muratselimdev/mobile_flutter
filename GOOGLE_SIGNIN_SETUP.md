# Google Sign-In Setup Guide

## Prerequisites
You need to set up OAuth 2.0 credentials in Google Cloud Console before Google Sign-In will work.

## Step 1: Create a Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the **Google Sign-In API**

## Step 2: Configure OAuth Consent Screen

1. Go to **APIs & Services** > **OAuth consent screen**
2. Choose **External** user type
3. Fill in the required fields:
   - App name: `One Clinic`
   - User support email: Your email
   - Developer contact information: Your email
4. Click **Save and Continue**
5. Add scopes: `email` and `profile`
6. Click **Save and Continue**

## Step 3: Create OAuth 2.0 Credentials

### For Android:

1. Go to **APIs & Services** > **Credentials**
2. Click **Create Credentials** > **OAuth 2.0 Client ID**
3. Select **Android** as application type
4. Enter details:
   - **Name**: `One Clinic Android`
   - **Package name**: `com.example.one_clinic_app`
   - **SHA-1 certificate fingerprint**: Get this by running:
     ```bash
     cd android
     ./gradlew signingReport
     ```
     Look for the SHA-1 under `Variant: debug` > `Config: debug`
5. Click **Create**

### For iOS:

1. Click **Create Credentials** > **OAuth 2.0 Client ID**
2. Select **iOS** as application type
3. Enter details:
   - **Name**: `One Clinic iOS`
   - **Bundle ID**: `com.example.oneClinicApp` (check in Xcode or ios/Runner.xcodeproj)
4. Click **Create**
5. Copy the **iOS URL scheme** provided

### For Web (Required for the plugin):

1. Click **Create Credentials** > **OAuth 2.0 Client ID**
2. Select **Web application** as application type
3. **Name**: `One Clinic Web`
4. Click **Create**
5. **Copy the Client ID** - you'll need this!

## Step 4: Configure Your Flutter App

### Initialize GoogleSignIn properly:

In `lib/presentation/pages/one_clinic_sign_in_page.dart`, update the initialization to use your web client ID:

```dart
@override
void initState() {
  super.initState();
  // Replace with your actual Web Client ID from Google Cloud Console
  GoogleSignIn.instance.initialize(
    clientId: "YOUR_WEB_CLIENT_ID.apps.googleusercontent.com",
  );
}
```

### For iOS - Add URL Scheme:

Add to `ios/Runner/Info.plist` (before `</dict>`):

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- Replace with your iOS URL scheme from Google Cloud Console -->
            <string>com.googleusercontent.apps.YOUR-IOS-CLIENT-ID</string>
        </array>
    </dict>
</array>
```

### For Android - Optional (usually auto-configured):

The plugin typically auto-configures Android, but if you have issues, you can add the Web Client ID to `android/app/src/main/res/values/strings.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="default_web_client_id">YOUR_WEB_CLIENT_ID.apps.googleusercontent.com</string>
</resources>
```

## Step 5: Test

1. Run `flutter clean && flutter pub get`
2. Rebuild your app: `flutter run`
3. Click the Google Sign-In button
4. You should now see the Google account picker!

## Troubleshooting

### "Sign in failed" or "Error 10"
- Check that your SHA-1 fingerprint is correct in Google Cloud Console
- For debug builds, use the debug keystore SHA-1
- For release builds, use your release keystore SHA-1

### "Developer Error" or "Error 12501"
- Web Client ID is not configured properly
- Make sure you created a Web OAuth client (not just Android/iOS)

### No dialog appears
- OAuth credentials not set up
- Wrong package name or bundle ID
- Follow all steps above carefully

### iOS Specific Issues
- Ensure URL scheme is added to Info.plist
- Bundle ID in Xcode matches what you registered in Google Cloud Console

## Current Configuration

**Package Name (Android)**: `com.example.one_clinic_app`
**Bundle ID (iOS)**: Check `ios/Runner.xcodeproj` or Xcode

You need to create OAuth credentials for both platforms using these identifiers.
