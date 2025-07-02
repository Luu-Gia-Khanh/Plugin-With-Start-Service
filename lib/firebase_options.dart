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
    apiKey: 'AIzaSyAXxzIflPzVucCCZ448FBlKiXD-KnVH-6M',
    appId: '1:280964325169:web:745d78776553f1efdf5a10',
    messagingSenderId: '280964325169',
    projectId: 'multiple-listen',
    authDomain: 'multiple-listen.firebaseapp.com',
    storageBucket: 'multiple-listen.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAXxzIflPzVucCCZ448FBlKiXD-KnVH-6M',
    appId: '1:280964325169:android:745d78776553f1efdf5a10',
    messagingSenderId: '280964325169',
    projectId: 'multiple-listen',
    storageBucket: 'multiple-listen.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAXxzIflPzVucCCZ448FBlKiXD-KnVH-6M',
    appId: '1:280964325169:ios:745d78776553f1efdf5a10',
    messagingSenderId: '280964325169',
    projectId: 'multiple-listen',
    storageBucket: 'multiple-listen.firebasestorage.app',
    iosBundleId: 'com.example.startServiceFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAXxzIflPzVucCCZ448FBlKiXD-KnVH-6M',
    appId: '1:280964325169:ios:745d78776553f1efdf5a10',
    messagingSenderId: '280964325169',
    projectId: 'multiple-listen',
    storageBucket: 'multiple-listen.firebasestorage.app',
    iosBundleId: 'com.example.startServiceFlutter',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAXxzIflPzVucCCZ448FBlKiXD-KnVH-6M',
    appId: '1:280964325169:web:745d78776553f1efdf5a10',
    messagingSenderId: '280964325169',
    projectId: 'multiple-listen',
    authDomain: 'multiple-listen.firebaseapp.com',
    storageBucket: 'multiple-listen.firebasestorage.app',
  );
}
