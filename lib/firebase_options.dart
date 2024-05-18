// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
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
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static FirebaseOptions android = FirebaseOptions(
    apiKey: dotenv.env['AndroidApiKey'] ?? '',
    appId: dotenv.env['AndroidAppId'] ?? '',
    messagingSenderId: dotenv.env['AndroidMessagingSenderId'] ?? '',
    projectId: dotenv.env['AndroidProjectId'] ?? '',
    storageBucket: dotenv.env['AndroidStorageBucket'] ?? '',
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: dotenv.env['iOSApiKey'] ?? '',
    appId: dotenv.env['iOSAppId'] ?? '',
    messagingSenderId: dotenv.env['iOSMessagingSenderId'] ?? '',
    projectId: dotenv.env['iOSProjectId'] ?? '',
    storageBucket: dotenv.env['iOSStorageBucket'] ?? '',
    iosBundleId: dotenv.env['iOSBundleId'] ?? '',
  );
}
