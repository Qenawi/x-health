# Release Information

## Current Version
- Version: 1.0.0
- Release Date: 2025-07-02

## Release Notes
- Initial release of x-health app
- Core features: add/update records, view history, compare, manage doctors/body parts, image gallery

## Upgrade Notes
- No previous versions

## Known Issues
- None reported

## Distributing the App

Follow these steps when you are ready to ship a build to TestFlight or the App Store:

1. **Archive the app**
   - Open `x-health.xcodeproj` in Xcode.
   - Select the *Any iOS Device* destination and choose **Product > Archive**.
2. **Upload via Xcode**
   - In the Organizer window, choose **Distribute App** and select **App Store Connect**.
   - Pick either **TestFlight** for beta testing or **App Store** for a production release.
3. **Enter metadata** in App Store Connect
   - Fill in version information, description, screenshots, and compliance details.
   - Ensure the `Version` listed above matches the value you submit.
4. **Submit for review**
   - After validation, submit the build for TestFlight beta review or App Store review.

These steps assume you have configured an App Store Connect account with the appropriate Bundle ID and provisioning profiles.
