# Initial Setup ✅

## Configure Firebase 🔥

For each flavor of the app:

- [ ] Create a new Firebase project in the [Firebase console](https://console.firebase.google.com)
- [ ] Update the `google-services.json` files for Android.
- [ ] Update the `GoogleService-Info.plist` files for iOS
- [ ] Update the `init.js` file for web
- [ ] Double check in the [Firebase console](https://console.firebase.google.com) the traffic and connections are established successfully. 

## Update the theme 🎨

- [ ] Update the app icons/favicon and launch images on Android, iOS and web
- [ ] In the `app_ui` package, update the fonts (`assets/fonts`) and the `app_theme.dart` to reflect the brand guidelines.

## Review the testing pipelines 📝

For each package and the app:

- [ ] Validate that all Github Actions pipelines are configured correctly.

## Complete automated releases 🤖

This project uses [Codemagic](https://codemagic.io/start/) to automate the release platform.

Please make sure that:

- [ ] You have access to the [Google Play Console](https://play.google.com/console/u/0/developers)
- [ ] You have access to the [Apple Developer Console](https://developer.apple.com)
- [ ] Signing settings for Android and iOS are configured correctly in `codemagic.yaml`