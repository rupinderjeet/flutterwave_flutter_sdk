## [BREAKING CHANGES] UNKNOWN - UNRELEASED
* removes dependency on `fluttertoast: ^8.0.8`
* removes redundant dependency on `modal_bottom_sheet: ^2.1.0`
* code-refactoring
* updates min-sdk version to 2.13.0
* hides internal API

## [1.0.6] - October, 2022
* Fixed bug where transaction gets stuck after redirecting on webview
* Fixed iOS build bug by removing inAppBrowser library

## [1.0.5] - October, 2022
* Fixed null when transaction is cancelled.
* Removed modal pop up before launching web view.
* Removed intermediate make payment screen before webview.
* Deprecated FlutterwaveStyle.
* Updated README file.

## [1.0.4] - July 4, 2022
* Renamed property `isDebug` to `isTestMode`
* Made property `redirectUrl` required
* Updated README file

## [1.0.3] - October 4, 2021.
* Fixed issue with webview

## [1.0.2] - September 23, 2021.
* Fixed bug where cancel payment buttons are not clickable on iOS devices.

## [1.0.1] - September 14, 2021.
* Fixed bug where response is not returned to initiating screen when user cancels transaction.

## [1.0.0] - September 9, 2021.
* Initial release