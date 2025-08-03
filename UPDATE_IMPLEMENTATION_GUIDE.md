# App Update System Implementation Guide

## Overview
This guide explains how to implement the app update system for the KeyWorld Flutter app on both Android and iOS platforms.

## Components Created

### 1. Models
- **`lib/models/update_model.dart`**: Handles update response data and version comparison logic

### 2. Services
- **`lib/services/app_update_service.dart`**: Manages version checking, API calls, and user preferences

### 3. Widgets
- **`lib/widgets/update_dialog.dart`**: Beautiful animated dialog for showing update prompts

### 4. Integration
- **Updated `lib/main.dart`**: Integrated update checking in the splash screen

## Dependencies Added
```yaml
dependencies:
  package_info_plus: ^8.0.2  # For getting app version info
  device_info_plus: ^10.1.2  # For device information
```

## API Endpoint Setup

### Required Endpoint
Your backend needs to implement a POST endpoint at:
```
POST https://your-api-domain.com/api/app/version-check
```

### Request Format
```json
{
  "current_version": "1.0.1",
  "platform": "android", // or "ios"
  "device_model": "SM-G975F",
  "os_version": "11",
  "package_name": "com.key.worldship.keyworld"
}
```

### Response Format
```json
{
  "latest_version": "1.0.2",
  "force_update": false,
  "is_required": false,
  "title": "Update Available",
  "message": "A new version of KeyWorld is available with exciting new features!",
  "android_url": "https://play.google.com/store/apps/details?id=com.key.worldship.keyworld",
  "ios_url": "https://apps.apple.com/app/keyworld/id123456789",
  "features": [
    "Improved performance",
    "Bug fixes",
    "New user interface",
    "Enhanced security"
  ],
  "release_date": "2024-01-15T10:00:00Z",
  "release_notes": "Bug fixes and performance improvements",
  "success": true
}
```

## Configuration

### 1. Update the API URL
In `lib/services/app_update_service.dart`, replace:
```dart
static const String _updateCheckUrl = 'https://your-api-domain.com/api/app/version-check';
```

### 2. Update Package Names
Replace the package names in the service:
```dart
'package_name': Platform.isAndroid ? 'com.key.worldship.keyworld' : 'com.keyworld.app'
```

### 3. Update Store URLs
Update the app store URLs in your API responses:
- **Android**: `https://play.google.com/store/apps/details?id=YOUR_PACKAGE_NAME`
- **iOS**: `https://apps.apple.com/app/your-app-name/idYOUR_APP_ID`

## Features

### 1. Automatic Update Checking
- Checks for updates every 24 hours
- Runs during app startup (splash screen)
- Handles network errors gracefully

### 2. User Experience
- Beautiful animated dialog
- Skip version functionality
- Remind me later option
- Force update support
- Direct app store navigation

### 3. Version Management
- Intelligent version comparison
- Support for semantic versioning (1.0.1, 1.2.3, etc.)
- Build number handling (1.0.1+2)

### 4. Platform Support
- Android (Google Play Store)
- iOS (Apple App Store)
- Automatic platform detection

## Testing

### 1. Test with Mock Data
You can test the update dialog using the mock data creator:

```dart
// In your test or debug code
final mockResponse = AppUpdateService.createMockUpdateResponse(
  latestVersion: '1.0.2',
  forceUpdate: false,
  title: 'Test Update',
  message: 'This is a test update message',
);

final updateModel = UpdateModel.fromJson(mockResponse, '1.0.1');
await UpdateDialog.show(context, updateModel);
```

### 2. Test Update Scenarios
- **No update available**: Current version >= latest version
- **Optional update**: Update available but not required
- **Force update**: Update required, no skip option
- **Network error**: API call fails
- **Invalid response**: Malformed JSON

## Customization

### 1. Update Frequency
Change the check interval in `app_update_service.dart`:
```dart
static const int _checkIntervalHours = 24; // Change this value
```

### 2. Dialog Appearance
Modify the `update_dialog.dart` file to customize:
- Colors and themes
- Button text
- Animation timing
- Layout and spacing

### 3. Update Logic
Customize the update checking logic in `app_update_service.dart`:
- Add custom version comparison
- Implement beta version support
- Add regional app store support

## Security Considerations

1. **HTTPS Only**: Always use HTTPS for the update check API
2. **Input Validation**: Validate all API responses
3. **URL Verification**: Verify app store URLs before launching
4. **Rate Limiting**: Implement rate limiting on your API
5. **Error Handling**: Handle all network and parsing errors

## Deployment Checklist

- [ ] Update API endpoint URL
- [ ] Configure correct package names
- [ ] Set up app store URLs
- [ ] Test on both Android and iOS
- [ ] Verify force update behavior
- [ ] Test network error scenarios
- [ ] Update app version in pubspec.yaml
- [ ] Submit to app stores with new version

## Monitoring

Consider implementing analytics to track:
- Update check frequency
- Update acceptance rate
- Skip rate by version
- Platform distribution
- Error rates

## Support

For issues or questions about the update system:
1. Check the console logs for error messages
2. Verify API endpoint is accessible
3. Test with mock data first
4. Ensure app store URLs are correct
5. Check device network connectivity