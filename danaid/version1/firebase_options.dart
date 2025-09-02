// This file is generated automatically by FlutterFire CLI.
// You can also manually configure your Firebase project.
// For more information, see: https://firebase.google.com/docs/flutter/setup

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyCVPsa1UlEub_vJ8P5LULryEhvyD6sQwF0',
    appId: '1:539245823880:web:afe3db6ddcaca773ae9c3d',
    messagingSenderId: '539245823880',
    projectId: 'danaid-f4a66',
    authDomain: 'danaid-f4a66.firebaseapp.com',
    storageBucket: 'danaid-f4a66.firebasestorage.app',
    measurementId: 'G-KQC7W7HBZJ',
  );

  // TODO: Replace with your Firebase project configuration

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBd3ZOchwEdQl-mL73XPe_nHUuei5o_Qgw',
    appId: '1:539245823880:android:db2e9164da9fa4dcae9c3d',
    messagingSenderId: '539245823880',
    projectId: 'danaid-f4a66',
    storageBucket: 'danaid-f4a66.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAjY5cdcJgHqvOctDCx5Yi3BDYxe-ecc84',
    appId: '1:539245823880:ios:91169a18888e5946ae9c3d',
    messagingSenderId: '539245823880',
    projectId: 'danaid-f4a66',
    storageBucket: 'danaid-f4a66.firebasestorage.app',
    iosBundleId: 'com.example.danaid',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAjY5cdcJgHqvOctDCx5Yi3BDYxe-ecc84',
    appId: '1:539245823880:ios:91169a18888e5946ae9c3d',
    messagingSenderId: '539245823880',
    projectId: 'danaid-f4a66',
    storageBucket: 'danaid-f4a66.firebasestorage.app',
    iosBundleId: 'com.example.danaid',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCVPsa1UlEub_vJ8P5LULryEhvyD6sQwF0',
    appId: '1:539245823880:web:0913e621d141689fae9c3d',
    messagingSenderId: '539245823880',
    projectId: 'danaid-f4a66',
    authDomain: 'danaid-f4a66.firebaseapp.com',
    storageBucket: 'danaid-f4a66.firebasestorage.app',
    measurementId: 'G-ZL16RV8CEZ',
  );

}