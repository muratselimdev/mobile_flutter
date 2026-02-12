// Configuration file for Google Sign-In
//
// **IMPORTANT**: You must add your Web Client ID here for Google Sign-In to work
//
// Steps to get your Web Client ID:
// 1. Go to https://console.cloud.google.com
// 2. Select your project "for-google-login"
// 3. Navigate to APIs & Services > Credentials
// 4. Find your "Web client" OAuth 2.0 Client ID
// 5. Copy the Client ID (format: xxxxxx.apps.googleusercontent.com)
// 6. Replace the placeholder below with your actual Client ID
//
// See ANDROID_GOOGLE_SIGNIN_CONFIG.md for detailed setup instructions

class GoogleSignInConfig {
  /// Your Web Client ID from Google Cloud Console
  ///
  /// Get it from: https://console.cloud.google.com/apis/credentials
  ///
  /// **TODO**: Replace this with your actual Web Client ID
  static const String webClientId =
      "728985836381-isgfa9vm1j2lar3q6n9stf49o96481i1.apps.googleusercontent.com";

  /// Scopes to request from Google
  static const List<String> scopes = ['email', 'profile'];

  /// Check if the Web Client ID has been configured
  static bool get isConfigured =>
      webClientId != "YOUR_WEB_CLIENT_ID_HERE.apps.googleusercontent.com";
}
