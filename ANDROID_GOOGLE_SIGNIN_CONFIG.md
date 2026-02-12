# Android Google Sign-In Configuration Guide

## Project Details
- **Google Account**: flutterauth2026@gmail.com
- **Google Cloud Project**: for-google-login
- **Package Name**: com.example.one_clinic_app

## Step 1: Get Your SHA-1 Certificate Fingerprint

### Option A: Install Java and use keytool (Recommended)

1. Install Java:
   ```bash
   brew install openjdk@17
   ```

2. Get SHA-1 fingerprint:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```

3. Look for the SHA-1 line (it will look like: `SHA1: AA:BB:CC:DD...`)

### Option B: Use Android Studio

1. Open Android Studio
2. Open your project
3. Click on **Gradle** tab (right side)
4. Navigate to: `Tasks` > `android` > `signingReport`
5. Double-click to run
6. Look for SHA-1 under "Variant: debug"

### Option C: Use Flutter Doctor

```bash
flutter doctor -v
```

The SHA-1 might be displayed in the output.

## Step 2: Configure Google Cloud Console

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Make sure you're logged in with **flutterauth2026@gmail.com**
3. Select your project **"for-google-login"**

### 2.1 Enable Required APIs

1. Go to **APIs & Services** > **Library**
2. Search and enable:
   - **Google Sign-In API** (or **Google+ API**)
   - **Google Identity Toolkit API** (if available)

### 2.2 Configure OAuth Consent Screen

1. Go to **APIs & Services** > **OAuth consent screen**
2. Select **External** user type (click Configure)
3. Fill in the required fields:
   - **App name**: One Clinic App
   - **User support email**: flutterauth2026@gmail.com
   - **Developer contact information**: flutterauth2026@gmail.com
4. Click **Save and Continue**
5. **Scopes**: Click **Add or Remove Scopes**
   - Add: `email`
   - Add: `profile`
6. Click **Save and Continue**
7. **Test users** (optional for now): Click **Save and Continue**
8. Click **Back to Dashboard**

### 2.3 Create OAuth 2.0 Credentials

#### A. Create Android Client

1. Go to **APIs & Services** > **Credentials**
2. Click **+ CREATE CREDENTIALS** > **OAuth client ID**
3. Select **Android** as Application type
4. Fill in:
   - **Name**: One Clinic Android
   - **Package name**: `com.example.one_clinic_app`
   - **SHA-1 certificate fingerprint**: [Paste your SHA-1 from Step 1]
5. Click **CREATE**
6. Click **OK** on the success dialog

#### B. Create Web Client (REQUIRED!)

1. Click **+ CREATE CREDENTIALS** > **OAuth client ID** again
2. Select **Web application** as Application type
3. Fill in:
   - **Name**: One Clinic Web
4. Click **CREATE**
5. **IMPORTANT**: Copy the **Client ID** shown in the dialog
   - It will look like: `123456789-abcdefgh.apps.googleusercontent.com`
   - Save this somewhere safe - you'll need it in Step 3!
6. Click **OK**

## Step 3: Configure Your Flutter App

### 3.1 Update Your Sign-In Code

Find your Google Sign-In initialization code (likely in your sign-in page) and update it with your Web Client ID:

```dart
// In your sign-in page or initialization
final GoogleSignIn _googleSignIn = GoogleSignIn(
  // Add your Web Client ID here
  clientId: "YOUR_WEB_CLIENT_ID_HERE.apps.googleusercontent.com",
  scopes: ['email', 'profile'],
);
```

### 3.2 Verify Package Name

Make sure your Android package name matches everywhere:

**Check**: `android/app/build.gradle.kts`
```kotlin
applicationId = "com.example.one_clinic_app"  // Should match
```

**Check**: `android/app/src/main/AndroidManifest.xml`
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- package should be consistent -->
</manifest>
```

## Step 4: Update AndroidManifest.xml (if needed)

Your `android/app/src/main/AndroidManifest.xml` should already have INTERNET permission, but verify:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

## Step 5: Test Your Configuration

1. Run your app:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. Try signing in with Google
3. If you get errors, check the logs for specific issues

## Common Issues & Solutions

### Issue 1: "Developer Error" or "Error 10"
- **Solution**: Double-check that:
  - SHA-1 fingerprint matches exactly
  - Package name is correct: `com.example.one_clinic_app`
  - You're using the Web Client ID in your code

### Issue 2: "Sign in failed" or null user
- **Solution**: Make sure you've created BOTH Android and Web OAuth clients

### Issue 3: "API not enabled"
- **Solution**: Go back to APIs & Services > Library and enable Google Sign-In API

### Issue 4: "Invalid client"
- **Solution**: Wait 5-10 minutes after creating credentials, Google needs time to propagate changes

## Quick Reference

**Package Name**: `com.example.one_clinic_app`  
**Google Account**: flutterauth2026@gmail.com  
**Project**: for-google-login  
**SHA-1**: [Get from Step 1]  
**Web Client ID**: [Get from Step 2.3.B]  

## Testing Checklist

- [ ] SHA-1 fingerprint obtained
- [ ] OAuth Consent Screen configured
- [ ] Android OAuth client created with correct SHA-1
- [ ] Web OAuth client created
- [ ] Web Client ID copied and added to Flutter code
- [ ] App cleaned and rebuilt
- [ ] Google Sign-In tested on Android device/emulator

## Need Help?

If you encounter issues, provide:
1. The exact error message
2. Your SHA-1 fingerprint
3. Your Web Client ID
4. Screenshots from Google Cloud Console Credentials page
