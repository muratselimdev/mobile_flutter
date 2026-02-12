#!/bin/bash

echo "======================================"
echo "Google Sign-In Android Setup Helper"
echo "======================================"
echo ""
echo "Project: for-google-login"
echo "Account: flutterauth2026@gmail.com"
echo "Package: com.example.one_clinic_app"
echo ""

# Check if Java is installed
if ! command -v keytool &> /dev/null; then
    echo "⚠️  keytool not found. Installing Java..."
    echo ""
    echo "Installing OpenJDK 17 via Homebrew..."
    if command -v brew &> /dev/null; then
        brew install openjdk@17
        
        echo ""
        echo "Adding Java to PATH..."
        echo 'export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
        export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
        
        echo ""
        echo "✅ Java installed!"
    else
        echo "❌ Homebrew not found. Please install Homebrew first:"
        echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
else
    echo "✅ Java is installed"
fi

echo ""
echo "======================================"
echo "Getting SHA-1 Fingerprint"
echo "======================================"
echo ""

if [ -f "$HOME/.android/debug.keystore" ]; then
    echo "Debug keystore found. Extracting SHA-1..."
    echo ""
    
    SHA1=$(keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android 2>/dev/null | grep "SHA1:" | cut -d' ' -f3)
    
    if [ -n "$SHA1" ]; then
        echo "✅ SHA-1 Fingerprint:"
        echo ""
        echo "    $SHA1"
        echo ""
        echo "Copy this SHA-1 fingerprint!"
    else
        echo "⚠️  Could not extract SHA-1. Trying alternative method..."
        keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
    fi
else
    echo "❌ Debug keystore not found at ~/.android/debug.keystore"
    echo ""
    echo "Run your Flutter app first to generate the keystore:"
    echo "    flutter run"
fi

echo ""
echo "======================================"
echo "Next Steps"
echo "======================================"
echo ""
echo "1. Copy your SHA-1 fingerprint (shown above)"
echo ""
echo "2. Go to Google Cloud Console:"
echo "   https://console.cloud.google.com/apis/credentials"
echo ""
echo "3. Make sure you're in project: for-google-login"
echo ""
echo "4. Create OAuth 2.0 Client IDs:"
echo ""
echo "   A. Android Client:"
echo "      - Type: Android"
echo "      - Name: One Clinic Android"
echo "      - Package: com.example.one_clinic_app"
echo "      - SHA-1: [paste your SHA-1]"
echo ""
echo "   B. Web Client (REQUIRED!):"
echo "      - Type: Web application"
echo "      - Name: One Clinic Web"
echo "      - Copy the Client ID after creation"
echo ""
echo "5. Update the Web Client ID in:"
echo "   lib/data/services/google_signin_config.dart"
echo ""
echo "6. Run: flutter clean && flutter pub get && flutter run"
echo ""
echo "See ANDROID_GOOGLE_SIGNIN_CONFIG.md for detailed instructions"
echo ""
