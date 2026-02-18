# Apple Sign-In Setup Guide

## ✅ Prerequisites Completed
- ✅ `sign_in_with_apple: ^7.0.1` already in pubspec.yaml
- ✅ Code implementation already in `one_clinic_sign_in_page.dart`
- ✅ iOS project configured with bundle ID: `com.example.oneClinicApp`

## 🎯 Next Steps

### Step 1: Register iOS App in Firebase Console

Based on your screenshot, you're ready to register your iOS app:

1. **Enter Bundle ID**: `com.example.oneClinicApp`
2. **App nickname** (optional): `One Clinic iOS`
3. **App Store ID** (optional): Leave empty for now
4. Click **Register app**
5. **Download GoogleService-Info.plist**

### Step 2: Add GoogleService-Info.plist to iOS Project

1. Open Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. Drag and drop `GoogleService-Info.plist` into `Runner` folder in Xcode
3. When prompted, make sure these are checked:
   - ✅ Copy items if needed
   - ✅ Add to targets: Runner

### Step 3: Enable Apple Sign-In in Firebase Authentication

1. In Firebase Console, go to: **Authentication** → **Sign-in method**
2. Click on **Apple**
3. Toggle **Enable**
4. Click **Save**

### Step 4: Configure Sign in with Apple in Xcode

1. In Xcode, select the **Runner** target
2. Go to **Signing & Capabilities** tab
3. Click **+ Capability**
4. Search for and add: **Sign in with Apple**

### Step 5: Enable Sign in with Apple in Apple Developer Portal

1. Go to [Apple Developer Portal](https://developer.apple.com/account)
2. Navigate to **Certificates, Identifiers & Profiles**
3. Click **Identifiers**
4. Select your app identifier: `com.example.oneClinicApp` (or create one if doesn't exist)
5. Check **Sign in with Apple**
6. Click **Save**

### Step 6: Create Service ID (for OAuth)

This is needed for Firebase to work with Apple Sign-In:

1. In Apple Developer Portal, go to **Identifiers**
2. Click **+** to create a new identifier
3. Select **Services IDs** → Continue
4. Fill in:
   - **Description**: `One Clinic Apple Sign In`
   - **Identifier**: `com.example.oneClinicApp.signin` (must be unique)
5. Click **Continue** → **Register**
6. Click on your new Services ID
7. Check **Sign in with Apple**
8. Click **Configure** next to it
9. Fill in:
   - **Primary App ID**: Select `com.example.oneClinicApp`
   - **Domains**: `for-apple-login.firebaseapp.com` (from your Firebase project)
   - **Return URLs**: `https://for-apple-login.firebaseapp.com/__/auth/handler`
10. Click **Save** → **Continue** → **Save**

### Step 7: Create Private Key (for Firebase)

1. In Apple Developer Portal, go to **Keys**
2. Click **+** to create a new key
3. Fill in:
   - **Key Name**: `Apple Sign In Key`
   - Check **Sign in with Apple**
4. Click **Configure** next to Sign in with Apple
5. Select your Primary App ID: `com.example.oneClinicApp`
6. Click **Save** → **Continue** → **Register**
7. **Download the .p8 file** (you can only download once!)
8. Note the **Key ID** shown

### Step 8: Configure Firebase with Apple Credentials

1. Go back to Firebase Console → **Authentication** → **Sign-in method**
2. Click on **Apple** (should already be enabled)
3. Click **Web SDK configuration** section
4. Fill in:
   - **Services ID**: `com.example.oneClinicApp.signin`
   - **Apple Team ID**: Get from Apple Developer Portal (top right corner)
   - **Key ID**: From Step 7
   - **Private Key**: Open the .p8 file and paste contents
5. Click **Save**

### Step 9: Test the Integration

1. Run your Flutter app on iOS simulator or device:
   ```bash
   flutter run -d <device-id>
   ```

2. Tap the Apple Sign-In button on the login page
3. You should see the Apple authentication dialog
4. Sign in with your Apple ID
5. Check the console for any errors

## 🧪 Testing

### iOS Simulator Testing
- Use your Apple ID credentials
- First time will ask for permission
- Subsequent logins should be faster

### Physical Device Testing
- Must be signed with proper provisioning profile
- Test with a real Apple ID
- Check that Face ID/Touch ID works

## 🔍 Troubleshooting

### Issue: "Sign in with Apple is not supported on this device"
**Solution**: Make sure you're testing on iOS 13+ simulator or device

### Issue: "Invalid client configuration"
**Solution**: Double-check:
- Bundle ID matches exactly: `com.example.oneClinicApp`
- Services ID is correctly configured
- Firebase has correct Team ID and Key ID

### Issue: Button shows but nothing happens when tapped
**Solution**: 
- Check that Sign in with Apple capability is added in Xcode
- Verify App ID has Sign in with Apple enabled in Apple Developer Portal

### Issue: "AppleID credential failed"
**Solution**: Make sure you've created the Service ID and configured it with Firebase domains

## 📝 Current Implementation

Your code is already set up in [one_clinic_sign_in_page.dart](lib/presentation/pages/one_clinic_sign_in_page.dart#L604-L633):

```dart
await SignInWithApple.getAppleIDCredential(
  scopes: [
    AppleIDAuthorizationScopes.email,
    AppleIDAuthorizationScopes.fullName,
  ],
);
```

## 🚀 Next: Backend Integration

After Apple Sign-In works, you'll need to:

1. Send the Apple credential to your backend
2. Verify the token with Apple's servers
3. Create or login user in your system
4. Return authentication token

Example:
```dart
final credential = await SignInWithApple.getAppleIDCredential(
  scopes: [
    AppleIDAuthorizationScopes.email,
    AppleIDAuthorizationScopes.fullName,
  ],
);

// Send to your backend
final response = await http.post(
  Uri.parse('$baseUrl/customer/auth/apple-signin'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'identityToken': credential.identityToken,
    'authorizationCode': credential.authorizationCode,
    'email': credential.email,
    'givenName': credential.givenName,
    'familyName': credential.familyName,
  }),
);
```

## 📋 Summary Checklist

- [ ] Register iOS app in Firebase with bundle ID `com.example.oneClinicApp`
- [ ] Download and add GoogleService-Info.plist to Xcode
- [ ] Enable Apple provider in Firebase Authentication
- [ ] Add Sign in with Apple capability in Xcode
- [ ] Enable Sign in with Apple for App ID in Apple Developer Portal
- [ ] Create and configure Services ID
- [ ] Create private key (.p8)
- [ ] Configure Firebase with Apple credentials (Services ID, Team ID, Key ID, Private Key)
- [ ] Test on iOS device/simulator
- [ ] Implement backend verification (next step)

## 🔗 Useful Links

- [Firebase iOS Setup](https://firebase.google.com/docs/ios/setup)
- [Apple Sign In Documentation](https://developer.apple.com/sign-in-with-apple/)
- [Firebase Apple Auth](https://firebase.google.com/docs/auth/ios/apple)
- [Apple Developer Portal](https://developer.apple.com/account)

---

**Your Bundle ID**: `com.example.oneClinicApp`  
**Firebase Project**: `for-apple-login`  
**Current Status**: Ready to register iOS app in Firebase
