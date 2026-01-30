# Authentication Implementation Guide

## Overview
The login functionality has been implemented with backend integration to:
- API Endpoint: `https://system.one-clinic.net:5001/api/customer/auth/login`
- Method: POST
- Content-Type: application/json

## Test Credentials
```
Email: volkan@test.com
Password: 123456
```

## Implementation Structure

### 1. Data Layer (`lib/data/`)
- **models/login_request.dart**: Request model for login
- **models/login_response.dart**: Response model from backend
- **services/auth_service.dart**: HTTP service to communicate with backend API

### 2. Presentation Layer (`lib/presentation/`)
- **bloc/auth_event.dart**: Authentication events (LoginSubmitted, LogoutRequested)
- **bloc/auth_state.dart**: Authentication states (initial, loading, authenticated, error)
- **bloc/auth_bloc.dart**: Business logic for authentication
- **pages/one_clinic_sign_in_page.dart**: Updated sign-in page with form validation and BLoC integration

## Features Implemented

✅ Form validation (email format, password length)
✅ Loading state with circular progress indicator
✅ Error handling with user-friendly messages
✅ Success/error snackbar notifications
✅ BLoC pattern for state management
✅ HTTP integration with backend API

## How to Test

1. Run the app
2. Enter the test credentials:
   - Email: `volkan@test.com`
   - Password: `123456`
3. Click "Giriş Yap" (Login)
4. The app will make a POST request to the backend
5. On success, you'll see a green snackbar notification
6. On error, you'll see a red snackbar with the error message

## Next Steps

To complete the authentication flow:

1. **Add Navigation**: Uncomment and implement navigation to home page after successful login:
```dart
// In one_clinic_sign_in_page.dart (line ~46)
Navigator.pushReplacement(
  context, 
  MaterialPageRoute(builder: (_) => HomePage())
);
```

2. **Token Storage**: Add secure storage for the authentication token:
```dart
// Add flutter_secure_storage package
flutter pub add flutter_secure_storage

// Store token after successful login
await storage.write(key: 'auth_token', value: state.token);
```

3. **Auto-login**: Check for stored token on app startup and auto-login if valid

4. **Token Refresh**: Implement token refresh logic if the API supports it

## API Response Format

The implementation expects the backend to return:
```json
{
  "success": true,
  "token": "jwt_token_here",
  "message": "Login successful",
  "data": {
    // User data
  }
}
```

## Error Handling

The app handles various error scenarios:
- Network errors (connection failures)
- Invalid credentials (401/403 responses)
- Server errors (500 responses)
- Validation errors (empty fields, invalid email format)
