// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDtpjLY5p_vc8r0M7CB4EYFkJjJbe81Yig',
    appId: '1:642727729945:web:90530348ad6356e21dc388',
    messagingSenderId: '642727729945',
    projectId: 'pasonshr',
    authDomain: 'pasonshr.firebaseapp.com',
    storageBucket: 'pasonshr.appspot.com',
    measurementId: 'G-3G8XV43WKW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA12iXB41sSdKFHVnhm_32jSPJMgNJEUtU',
    appId: '1:642727729945:android:940ab2119338556d1dc388',
    messagingSenderId: '642727729945',
    projectId: 'pasonshr',
    storageBucket: 'pasonshr.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2OeqTpFbnCHQVmdvR24X1lzvmv6moERc',
    appId: '1:642727729945:ios:9859061be10aa2811dc388',
    messagingSenderId: '642727729945',
    projectId: 'pasonshr',
    storageBucket: 'pasonshr.appspot.com',
    iosClientId: '642727729945-qktd6aqdihugo9tj31l6bpjrtp0dlm5g.apps.googleusercontent.com',
    iosBundleId: 'com.pasons.pasonshr',
  );
}
