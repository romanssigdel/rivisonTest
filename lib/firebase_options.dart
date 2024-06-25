// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBcygbydJRldWISn2Ipih4Lzpa6bHV12oE',
    appId: '1:410547798523:web:9a0334bfed5c3d4f630b5e',
    messagingSenderId: '410547798523',
    projectId: 'rivisontest',
    authDomain: 'rivisontest.firebaseapp.com',
    storageBucket: 'rivisontest.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDwUz9YHt32TU4y-yh3uFbvDja2Akqfx5s',
    appId: '1:410547798523:android:8960d520d606acb7630b5e',
    messagingSenderId: '410547798523',
    projectId: 'rivisontest',
    storageBucket: 'rivisontest.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDGhvfgGfSxo2lF8zNICrJfueLCxf4AXr8',
    appId: '1:410547798523:ios:aca6ec467710352b630b5e',
    messagingSenderId: '410547798523',
    projectId: 'rivisontest',
    storageBucket: 'rivisontest.appspot.com',
    iosBundleId: 'com.example.flutterRivisonAgain',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDGhvfgGfSxo2lF8zNICrJfueLCxf4AXr8',
    appId: '1:410547798523:ios:aca6ec467710352b630b5e',
    messagingSenderId: '410547798523',
    projectId: 'rivisontest',
    storageBucket: 'rivisontest.appspot.com',
    iosBundleId: 'com.example.flutterRivisonAgain',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBcygbydJRldWISn2Ipih4Lzpa6bHV12oE',
    appId: '1:410547798523:web:66264a32f432f702630b5e',
    messagingSenderId: '410547798523',
    projectId: 'rivisontest',
    authDomain: 'rivisontest.firebaseapp.com',
    storageBucket: 'rivisontest.appspot.com',
  );
}