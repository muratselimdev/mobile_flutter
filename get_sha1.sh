#!/bin/bash

echo "============================================"
echo "Getting SHA-1 Fingerprint for Google Sign-In"
echo "============================================"
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    exit 1
fi

echo "📱 Package Name: com.example.one_clinic_app"
echo ""

# Try to get SHA-1 using Flutter's method
echo "🔑 Attempting to get SHA-1 fingerprint..."
echo ""

# Method 1: Using Gradle (requires Java)
if [ -f "android/gradlew" ]; then
    echo "Method 1: Using Gradle signingReport"
    cd android
    if ./gradlew signingReport 2>/dev/null | grep -A 10 "Variant: debug"; then
        echo ""
        echo "✅ SHA-1 fingerprint found above (look for SHA1 line)"
    else
        echo "⚠️  Gradle method failed (Java might not be installed)"
    fi
    cd ..
    echo ""
fi

# Method 2: Direct keystore reading
echo "Method 2: Reading debug keystore directly"
if [ -f "$HOME/.android/debug.keystore" ]; then
    echo "Debug keystore found at: $HOME/.android/debug.keystore"
    echo ""
    echo "To get SHA-1, run this command:"
    echo ""
    echo "keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android | grep SHA1"
    echo ""
    echo "Or use this online tool:"
    echo "https://developers.google.com/android/guides/client-auth"
else
    echo "❌ Debug keystore not found"
fi

echo ""
echo "============================================"
echo "Next Steps:"
echo "============================================"
echo "1. Get your SHA-1 fingerprint using one of the methods above"
echo "2. Go to https://console.cloud.google.com/apis/credentials"
echo "3. Create OAuth 2.0 Client ID for Android with:"
echo "   - Package name: com.example.one_clinic_app"
echo "   - SHA-1: <your SHA-1 fingerprint>"
echo "4. Also create OAuth 2.0 Client ID for Web application"
echo "5. Copy the Web Client ID and add it to the code"
echo ""
echo "See GOOGLE_SIGNIN_SETUP.md for detailed instructions"
