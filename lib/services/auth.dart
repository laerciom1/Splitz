import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:splitz/services/firebase/settle_up_firebase.dart';
import 'package:splitz/services/firebase/splitz_firebase.dart';
import 'package:splitz/services/log.dart';

final _googleAccount = GoogleSignIn(
    // scopes: [
    //   'https://www.googleapis.com/auth/userinfo.email',
    //   'https://www.googleapis.com/auth/userinfo.profile,'
    // ],
    );

abstract class Auth {
  static bool get isSignedInToSplitz {
    try {
      return SplitzFirebase.auth.currentUser != null;
    } catch (error, stackTrace) {
      Log.that('Error on Auth.isSignedInToSplitz',
          error: error, stackTrace: stackTrace);
      return false;
    }
  }

  static Future<bool> get isSignedInToSettleUp async {
    try {
      final settleUpFirebaseAuth = await SettleUpFirebase.auth;
      return settleUpFirebaseAuth.currentUser != null;
    } catch (error, stackTrace) {
      Log.that('Error on Auth.isSignedInToSettleUp',
          error: error, stackTrace: stackTrace);
      return false;
    }
  }

  static Future<String?> get settleUpUserId async {
    try {
      final settleUpFirebaseAuth = await SettleUpFirebase.auth;
      return settleUpFirebaseAuth.currentUser?.uid;
    } catch (error, stackTrace) {
      Log.that('Error on Auth.settleUpUserId',
          error: error, stackTrace: stackTrace);
      return '';
    }
  }

  static Future<String?> get settleUpIdToken async {
    try {
      final settleUpFirebaseAuth = await SettleUpFirebase.auth;
      return settleUpFirebaseAuth.currentUser?.getIdToken();
    } catch (error, stackTrace) {
      Log.that('Error on Auth.settleUpIdToken',
          error: error, stackTrace: stackTrace);
      return '';
    }
  }

  static Future<bool?> splitzSignIn() async {
    try {
      if (Auth.isSignedInToSplitz) return null;
      final googleAccount = await _googleAccount.signIn();
      final googleAuth = await googleAccount?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await SplitzFirebase.auth.signInWithCredential(credential);
      return true;
    } catch (error, stackTrace) {
      Log.that('Error on Auth.signIn', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  static Future<bool?> settleUpSignIn(String email, String password) async {
    try {
      if (await Auth.isSignedInToSettleUp) return null;
      final settleUpFirebaseAuth = await SettleUpFirebase.auth;
      await settleUpFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (error, stackTrace) {
      Log.that('Error on Auth.signIn', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  static Future<void> signOut() async {
    try {
      var futures = <Future<void>>[];
      if (await Auth.isSignedInToSettleUp) {
        final settleUpFirebaseAuth = await SettleUpFirebase.auth;
        futures.add(settleUpFirebaseAuth.signOut());
      }
      if (Auth.isSignedInToSplitz) {
        futures.add(SplitzFirebase.auth.signOut());
      }
      await Future.wait(futures);
      await _googleAccount.disconnect();
    } catch (error, stackTrace) {
      Log.that('Error on Auth.signOut', error: error, stackTrace: stackTrace);
    }
  }
}
