# Quick Start: Enable Google Sign-In

## Current Status
❌ Google Sign-In button is visible but doesn't work yet
✅ Button click handler is implemented
⚠️  OAuth credentials need to be configured

## Why It's Not Working
Google Sign-In requires OAuth 2.0 credentials from Google Cloud Console. Without these credentials, the authentication dialog won't appear.

## Quick Fix (5-10 minutes)

### Step 1: Get Your SHA-1 Fingerprint

Run this command in your terminal:
```bash
cd /Users/murat/mobile_flutter
./get_sha1.sh
```

Or manually:
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android | grep SHA1
```

**Copy the SHA-1 value** (looks like: `AB:CD:EF:12:34:56:78:90...`)

### Step 2: Create Google Cloud Project

1. Open: https://console.cloud.google.com/
2. Click "Select a project" → "New Project"
3. Name it "One Clinic" → Create
4. Wait for project creation (30 seconds)

### Step 3: Enable Google Sign-In API

1. In your project, go to: **APIs & Services** → **Library**
2. Search for "Google Sign-In"
3. Click **Enable**

### Step 4: Configure OAuth Consent Screen

1. Go to: **APIs & Services** → **OAuth consent screen**
2. Select **External** → Click **Create**
3. Fill in:
   - App name: `One Clinic`
   - User support email: `your-email@example.com`
   - Developer contact: `your-email@example.com`
4. Click **Save and Continue**
5. Click **Save and Continue** (skip adding scopes for now)
6. Click **Save and Continue** (skip test users for now)
7. Click **Back to Dashboard**

### Step 5: Create OAuth Credentials

#### 5a. Create Android OAuth Client

1. Go to: **APIs & Services** → **Credentials**
2. Click **+ CREATE CREDENTIALS** → **OAuth 2.0 Client ID**
3. Application type: **Android**
4. Fill in:
   - Name: `One Clinic Android`
   - Package name: `com.example.one_clinic_app`
   - SHA-1: *Paste your SHA-1 from Step 1*
5. Click **CREATE**
6. Click **OK** on the popup

#### 5b. Create Web OAuth Client (REQUIRED!)

1. Still in Credentials page, click **+ CREATE CREDENTIALS** → **OAuth 2.0 Client ID**
2. Application type: **Web application**
3. Name: `One Clinic Web`
4. Click **CREATE**
5. **⚠️ IMPORTANT**: Copy the **Client ID** shown in the popup
   - It looks like: `123456789-abcdefghijklmnop.apps.googleusercontent.com`
6. Save it somewhere - you'll need it in the next step!

### Step 6: Add Client ID to Your App

Open: `lib/presentation/pages/one_clinic_sign_in_page.dart`

Find this line (around line 40):
```dart
clientId: null, // Set to null to use platform default
```

Replace it with:
```dart
clientId: "YOUR-WEB-CLIENT-ID.apps.googleusercontent.com",
```

**Paste your actual Web Client ID from Step 5b!**

### Step 7: Rebuild and Test

```bash
cd /Users/murat/mobile_flutter
flutter clean
flutter pub get
flutter run
```

Click the Google Sign-In button - it should now show the account picker! 🎉

---

## Troubleshooting

### Issue: "Sign in failed" or "Error 10"
**Fix**: Check your SHA-1 is correct in Google Cloud Console (Step 5a)

### Issue: "Developer Error" or "Error 12501"  
**Fix**: Make sure you created BOTH Android AND Web OAuth clients (Steps 5a and 5b)

### Issue: Nothing happens when clicking button
**Fix**: Check console logs - run `flutter run` and watch for error messages

### Issue: "PlatformException" or "SIGN_IN_FAILED"
**Fix**: Your Web Client ID is not set correctly (Step 6)

---

## For iOS Setup (Later)

If you want to build for iOS, you'll also need to:

1. Create iOS OAuth Client in Google Cloud Console
2. Add URL scheme to `ios/Runner/Info.plist`
3. See full guide in `GOOGLE_SIGNIN_SETUP.md`

---

## Need Help?

- Full detailed guide: See `GOOGLE_SIGNIN_SETUP.md`
- Google's official guide: https://developers.google.com/identity/sign-in/android/start
- Check logs when running: `flutter run` and click the button

---

**Package Name**: `com.example.one_clinic_app`  
**Current SHA-1**: Run `./get_sha1.sh` to find it
