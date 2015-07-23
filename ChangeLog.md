ChangeLog
=====

## 1. SDK

**Version 4.0.7:**

- Fix callback issues in Android platform
- Add FBAppLinkURL in Plist (iOS)
- Fix bank issues(iOS)
- Fix Payment package not showing(Android)
- Add loading in banks payment (Android)
- Add UseSmallSDKButton() function (Android)

**Version 4.0.6:**

- Add support tracking with AppFlyer and Adwords
- Sync name functions in iOS and Android platform

**Version 4.0.5:**

- Update Facebook App Event features

**Version 4.0.4:**

- Add ActiveCode module

**Version 4.0.3:**

Update Android jar with:

- Function Init() should be called before settings other configures.
- AutoShowLoginView is true by default.

**Version 4.0.2**

- Sync functions in iOS and Android platform </br>
- Update iOS frameworks and Android jar</br>
- Fix Show User Info crash</br>

**Version 4.0.1:**

- Pre-release version for AppotaGameSDK 4 for Unity

## 2. Server

- Add `revenue` parameter in IPN callback to measure revenue of current payment method type `CARD`, `BANK`, ...
- Reimplement your hash checking function to add `revenue` parameter (it will be add in `a-z` order)
- For detail please read wiki about IPN for each payment method [https://github.com/appota/unity-game-sdk/wiki/Passive-Confirmation-via-IPN](https://github.com/appota/unity-game-sdk/wiki/Passive-Confirmation-via-IPN)