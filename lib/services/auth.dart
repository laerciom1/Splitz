import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:splitz/services/log.dart';

final _googleAccount = GoogleSignIn(
    // scopes: [
    //   'https://www.googleapis.com/auth/userinfo.email',
    //   'https://www.googleapis.com/auth/userinfo.profile,'
    // ],
    );

abstract class Auth {
  static Future<bool> get isSignedIn async {
    try {
      return await _googleAccount.isSignedIn();
    } catch (error, stackTrace) {
      Log.that('Error on Auth.isSignedIn',
          error: error, stackTrace: stackTrace);
      return false;
    }
  }

  static Future<User?> signIn() async {
    try {
      Log.that(
          'Auth.signIn | (_googleAccount.currentUser == null): ${_googleAccount.currentUser == null}');
      final isSignedIn = await Auth.isSignedIn;
      if (isSignedIn) return null;
      final googleAccount = await _googleAccount.signIn();
      final googleAuth = await googleAccount?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      Log.that(
          'Auth.signIn | (_googleAccount.currentUser == null): ${_googleAccount.currentUser == null}');
      return userCredential.user;
    } catch (error, stackTrace) {
      Log.that('Error on Auth.signIn', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      Log.that(
          'Auth.signOut | (_googleAccount.currentUser == null): ${_googleAccount.currentUser == null}');
      final isSignedIn = await Auth.isSignedIn;
      if (!isSignedIn) return;
      await FirebaseAuth.instance.signOut();
      await _googleAccount.disconnect();
      Log.that(
          'Auth.signOut | (_googleAccount.currentUser == null): ${_googleAccount.currentUser == null}');
    } catch (error, stackTrace) {
      Log.that('Error on Auth.signOut', error: error, stackTrace: stackTrace);
    }
  }
}
