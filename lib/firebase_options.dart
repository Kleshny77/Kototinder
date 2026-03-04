import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCFbmGVBMfhbtukWISRPdqM41T6rWrJRYc',
    appId: '1:912656242746:android:2353485808b7e999aabd03',
    messagingSenderId: '912656242746',
    projectId: 'flutterhw2-kototinder',
    storageBucket: 'flutterhw2-kototinder.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDiDXd7xt3pLXy0e-6dcYpti6CW22trEYk',
    appId: '1:912656242746:ios:014d177ecbbbbb9aaabd03',
    messagingSenderId: '912656242746',
    projectId: 'flutterhw2-kototinder',
    storageBucket: 'flutterhw2-kototinder.firebasestorage.app',
    iosBundleId: 'com.example.flutterHw1',
  );
}
