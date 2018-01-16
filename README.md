# Trovami

A Live location app created in Flutter using Firebase as the backend 


# Features

- Create groups and choose to share your live location
- View group members on the map 
- Google Sign-in

# Preview

![preview](https://github.com/Samaritan1011001/Trovami/blob/master/ezgif.com-video-to-gif.gif)


# Dependencies

* [Flutter](https://flutter.io/) 
* [Firebase](https://firebase.google.com/) 
* [Google Sign in](https://github.com/flutter/plugins/tree/master/packages/google_sign_in) 
* [Maps Plugin](https://github.com/apptreesoftware/flutter_google_map_view) 

# Getting Started

## 1.Setup Flutter

## 2.Clone the repo

$ git clone https://github.com/Samaritan1011001/Trovami.git
$ cd trovami/

## 3. Setup Firebase

1. You'll need to create a Firebase instance. Follow the instructions at https://console.firebase.google.com.
2. Once your Firebase instance is created, you'll need to enable anonymous authentication.

* Go to the Firebase Console for your new instance.
* Click "Authentication" in the left-hand menu
* Click the "sign-in method" tab
* Click "Google" and enable it

3. (skip if not running on Android)

* Create an app within your Firebase instance for Android, with package name com.yourcompany.locatePal
* Run the following command to get your SHA-1 key:

```
keytool -exportcert -list -v \
-alias androiddebugkey -keystore ~/.android/debug.keystore
```

* In the Firebase console, in the settings of your Android app, add your SHA-1 key by clicking "Add Fingerprint".
* Follow instructions to download google-services.json
* place `google-services.json` into `Trovami/android/app/`.

4. (skip if not running on iOS)

* Create an app within your Firebase instance for iOS, with package name com.yourcompany.locatePal
* Follow instructions to download GoogleService-Info.plist, and place it into Trovami/ios/Runner in XCode
* Open Trovami/ios/Runner/Info.plist. Locate the CFBundleURLSchemes key. The second item in the array value of this key is specific to the Firebase instance. Replace it with the value for REVERSED_CLIENT_ID from GoogleService-Info.plist

## 4. Run the app

```sh
$ flutter run
```


# Tasks to complete

- [ ] Firebase Authentication 
- [x] Google Sign in
- [ ] Chat screen 
- [ ] Deleting groups
- [ ] Deleting members of the group after creation of the group
- [ ] Refresh feature of the map 
- [ ] Search for a better Map_View plugin
For help getting started with Flutter, view our online
documentation.
