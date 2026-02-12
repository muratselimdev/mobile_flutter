# ✅ Google Sign-In Configuration Summary

## Your Configuration Details
- **Google Account**: flutterauth2026@gmail.com
- **Google Cloud Project**: for-google-login
- **Package Name**: com.example.one_clinic_app

## ✅ What's Already Done

1. ✅ `google_sign_in` package is already in pubspec.yaml
2. ✅ Created `google_signin_config.dart` for storing Web Client ID
3. ✅ Updated sign-in page to use proper Google Sign-In initialization
4. ✅ Added configuration check before attempting sign-in
5. ✅ Android package name is set correctly

## 🔧 What You Need to Do

### Step 1: Get SHA-1 Fingerprint

Choose one of these methods:

**Option A: Using Android Studio (Easiest)**
1. Open this project in Android Studio
2. Open Terminal in Android Studio
3. Run: `cd android && ./gradlew signingReport`
4. Copy the SHA1 from "Variant: debug"

**Option B: Run the alternative script**
```bash
./get_sha1_alternative.sh
```

**Option C: If keystore doesn't exist yet**
```bash
flutter run
```
This will create the keystore, then try Option A again.

### Step 2: Configure Google Cloud Console

1. **Go to**: https://console.cloud.google.com/apis/credentials
2. **Make sure** you're logged in as: flutterauth2026@gmail.com
3. **Select project**: for-google-login

#### 2a. Enable APIs (if not already enabled)
- Go to: APIs & Services > Library
- Search and enable: "Google Sign-In API"

#### 2b. Configure OAuth Consent Screen (if not done)
- Go to: APIs & Services > OAuth consent screen
- User Type: External
- App name: One Clinic App
- User support email: flutterauth2026@gmail.com
- Scopes: email, profile
- Save

#### 2c. Create Android OAuth Client
1. Click: **+ CREATE CREDENTIALS** > **OAuth client ID**
2. Application type: **Android**
3. Name: `One Clinic Android`
4. Package name: `com.example.one_clinic_app`
5. SHA-1: **[Paste your SHA-1 from Step 1]**
6. Click: **CREATE**

#### 2d. Create Web OAuth Client (REQUIRED!)
1. Click: **+ CREATE CREDENTIALS** > **OAuth client ID**
2. Application type: **Web application**
3. Name: `One Clinic Web`
4. Click: **CREATE**
5. **IMPORTANT**: Copy the Client ID (looks like: `xxxxx-yyyyy.apps.googleusercontent.com`)

### Step 3: Add Web Client ID to Your App

1. Open: [lib/data/services/google_signin_config.dart](lib/data/services/google_signin_config.dart)
2. Replace `YOUR_WEB_CLIENT_ID_HERE.apps.googleusercontent.com` with your actual Web Client ID
3. Save the file

### Step 4: Clean and Run

```bash
flutter clean
flutter pub get
flutter run
```

## 🧪 Testing

1. Run your app on Android device or emulator
2. Go to the sign-in page
3. Tap the Google Sign-In button
4. You should see the Google account picker
5. Select an account and sign in

## ❌ Troubleshooting

### Error: "Developer Error" or "Error 10"
**Solution**: 
- Double-check SHA-1 matches exactly
- Verify package name is `com.example.one_clinic_app`
- Make sure you're using the Web Client ID (not Android Client ID)
- Wait 5-10 minutes after creating credentials

### Error: "Sign in failed"
**Solution**:
- Check that you created BOTH Android and Web OAuth clients
- Verify Web Client ID is correctly set in `google_signin_config.dart`

### Error: "API not enabled"
**Solution**:
- Go to: APIs & Services > Library
- Enable "Google Sign-In API" or "Google+ API"

### Error: "Google Sign-In is not configured"
**Solution**:
- You haven't updated the Web Client ID yet
- Edit: `lib/data/services/google_signin_config.dart`

## 📋 Quick Checklist

- [ ] Get SHA-1 fingerprint
- [ ] Go to Google Cloud Console
- [ ] Select "for-google-login" project
- [ ] Enable Google Sign-In API
- [ ] Configure OAuth Consent Screen
- [ ] Create Android OAuth Client with SHA-1
- [ ] Create Web OAuth Client
- [ ] Copy Web Client ID
- [ ] Update `google_signin_config.dart` with Web Client ID
- [ ] Run `flutter clean && flutter pub get`
- [ ] Test on Android device/emulator

## 📚 Files Created/Modified

1. **ANDROID_GOOGLE_SIGNIN_CONFIG.md** - Detailed setup guide
2. **lib/data/services/google_signin_config.dart** - Configuration file (⚠️ NEEDS YOUR WEB CLIENT ID)
3. **lib/presentation/pages/one_clinic_sign_in_page.dart** - Updated to use proper initialization
4. **setup_google_signin.sh** - Automated setup helper
5. **get_sha1_alternative.sh** - Alternative methods to get SHA-1

## 🆘 Need Help?

If you encounter issues:
1. Check the error message carefully
2. Read the detailed guide: [ANDROID_GOOGLE_SIGNIN_CONFIG.md](ANDROID_GOOGLE_SIGNIN_CONFIG.md)
3. Verify all checklist items above
4. Make sure credentials are active (wait 5-10 minutes after creation)

## 🎯 The Critical Step

**The most important thing**: Get your **Web Client ID** from Google Cloud Console and put it in:
```
lib/data/services/google_signin_config.dart
```

Without this, Google Sign-In will NOT work!
