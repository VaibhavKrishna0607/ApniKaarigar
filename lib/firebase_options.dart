// Firebase configuration for ApnaKaarigar
// Generated from Firebase Console

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyB035-Bww3LqPLipg5OuY1b1WA8FFuKhx0',
    appId: '1:862580396720:web:e823d79092a1108ce0e175',
    messagingSenderId: '862580396720',
    projectId: 'apnakaarigar-5c619',
    authDomain: 'apnakaarigar-5c619.firebaseapp.com',
    storageBucket: 'apnakaarigar-5c619.firebasestorage.app',
    measurementId: 'G-HSK1THF1NK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDlsK7DRSdqAKoanCMhGxmhylroYLlzjkk',
    appId: '1:862580396720:android:efe26b54083525e1e0e175',
    messagingSenderId: '862580396720',
    projectId: 'apnakaarigar-5c619',
    storageBucket: 'apnakaarigar-5c619.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB035-Bww3LqPLipg5OuY1b1WA8FFuKhx0',
    appId: '1:862580396720:ios:e823d79092a1108ce0e175',
    messagingSenderId: '862580396720',
    projectId: 'apnakaarigar-5c619',
    storageBucket: 'apnakaarigar-5c619.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB035-Bww3LqPLipg5OuY1b1WA8FFuKhx0',
    appId: '1:862580396720:macos:e823d79092a1108ce0e175',
    messagingSenderId: '862580396720',
    projectId: 'apnakaarigar-5c619',
    storageBucket: 'apnakaarigar-5c619.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB035-Bww3LqPLipg5OuY1b1WA8FFuKhx0',
    appId: '1:862580396720:web:e823d79092a1108ce0e175',
    messagingSenderId: '862580396720',
    projectId: 'apnakaarigar-5c619',
    storageBucket: 'apnakaarigar-5c619.firebasestorage.app',
  );
}

