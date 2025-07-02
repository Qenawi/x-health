# x-health

x-health is an iOS application for managing and tracking health records, body parts, doctors, and medical history. The app provides features for adding, updating, and comparing health records, as well as viewing history and images.

## Features
- Add and update health records
- View all history and details
- Compare records
- Manage doctors and body parts
- Image gallery and zoom

## Getting Started
1. Clone the repository
2. Open `x-health.xcodeproj` in Xcode
3. Build and run on an iOS Simulator or device (iOS 15+ recommended)

## Requirements
- Xcode 16.2 or later
- iOS 15.0 or later

## Development
- Main code is in `Views/` and root Swift files
- Assets are in `Assets.xcassets`
- CI/CD is set up with GitHub Actions (`.github/workflows/ios-build.yml`)
- Basic unit tests are located in `x-healthTests/`. Run them with
  `xcodebuild test -scheme x-health-Package` on macOS.
- TestFlight workflow: `.github/workflows/testflight.yml`
- App Store release workflow: `.github/workflows/release.yml`

## License
MIT License
