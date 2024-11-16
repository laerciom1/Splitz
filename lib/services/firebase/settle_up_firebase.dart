import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

const _settleUpFirebaseOptions = FirebaseOptions(
  apiKey: String.fromEnvironment('FB_OPTION_API_KEY'),
  appId: String.fromEnvironment('FB_OPTION_APP_ID'),
  messagingSenderId: String.fromEnvironment('FB_OPTION_SENDER_ID'),
  projectId: String.fromEnvironment('FB_OPTION_PROJECT_ID'),
);

abstract class SettleUpFirebase {
  static FirebaseApp? _app;
  static Future<FirebaseApp> get app async {
    _app ??= await Firebase.initializeApp(
      name: 'SettleUp',
      options: _settleUpFirebaseOptions,
    );
    return _app!;
  }

  static FirebaseAuth? _auth;
  static Future<FirebaseAuth> get auth async {
    _auth ??= FirebaseAuth.instanceFor(app: (await app));
    return _auth!;
  }
}
