import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:splitz/data/repositories/functions_repo.dart';
import 'package:splitz/util/extensions/strings.dart';
import 'package:splitz/application/services/log_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Splitz
final _googleAccount = GoogleSignIn();

abstract class AuthService {
  // Splitz (Google)
  static Future<bool> get isSignedInToSplitz async {
    try {
      return FirebaseAuth.instance.currentUser != null && (await isAllowedUser);
    } catch (e, s) {
      LogService.log('Error on Auth.isSignedInToSplitz', e, s);
      return false;
    }
  }

  static Future<bool?> splitzSignIn() async {
    try {
      if (await isSignedInToSplitz) return null;
      if (kIsWeb) {
        await _splitzSignInWeb();
      } else {
        await _splitzSignInMobile();
      }
      return true;
    } catch (e, s) {
      LogService.log('Error on Auth.splitzSignIn', e, s);
      return false;
    }
  }

  static Future<void> _splitzSignInMobile() async {
    final googleAccount = await _googleAccount.signIn();
    if (googleAccount == null) throw Exception('Could not sign in to a Google account');
    final googleAuth = await googleAccount.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<void> _splitzSignInWeb() async {
    final provider = GoogleAuthProvider();
    await FirebaseAuth.instance.signInWithPopup(provider);
  }

  static Future<bool> get isAllowedUser async {
    try {
      final data = await FunctionsRepository.call('checkIsAllowedUser');
      final result = data['allowed'] as bool?;
      return result ?? false;
    } catch (e, s) {
      LogService.log('Error on Auth.isAllowedUser', e, s);
      return false;
    }
  }

  // Splitwise
  static Future<bool> get isSignedInToSplitwise async {
    try {
      final data = await FunctionsRepository.call('checkSplitwiseSession');
      final result = data['signed_in'] as bool?;
      return result ?? false;
    } catch (e, s) {
      LogService.log('Error on Auth.isSignedInToSplitwise', e, s);
      return false;
    }
  }

  static Uri getSplitwiseAuthURL() {
    return Uri.parse('https://secure.splitwise.com/oauth/authorize').replace(
      queryParameters: {
        'response_type': 'code',
        'client_id': const String.fromEnvironment('SW_CONSUMER_KEY'),
        'redirect_uri': const String.fromEnvironment('SW_REDIRECT_URL'),
      },
    );
  }

  static Future<NavigationDecision> onNavigationRequest(
    NavigationRequest request,
    Future<void> Function(bool success) onResult,
  ) async {
    try {
      final redirectUrl = const String.fromEnvironment('SW_REDIRECT_URL');
      if (request.url.contains(redirectUrl.toString())) {
        final uri = Uri.parse(request.url);
        final queryParams = uri.queryParameters;
        final code = queryParams['code'];
        if (!code.isNullOrEmpty) {
          await exchangeSplitwiseAuthorizationCode(code!);
          onResult(true);
          return NavigationDecision.prevent;
        }
      }
      return NavigationDecision.navigate;
    } catch (e, s) {
      LogService.log('Auth.onNavigationRequest', e, s);
      onResult(false);
      return NavigationDecision.prevent;
    }
  }

  static Future<void> exchangeSplitwiseAuthorizationCode(String code) async {
    final data = await FunctionsRepository.call('exchangeSplitwiseAuthorizationCode', {'code': code});
    if (data['success'] != true) throw Exception('Could not authenticate with Splitwise.');
  }

  // Common
  static Future<void> signOut() async {
    try {
      final [signedToSplitwise, signedToSplitz] = await Future.wait([isSignedInToSplitwise, isSignedInToSplitz]);
      var futures = <Future<void>>[];
      if (signedToSplitwise) {
        futures.add(FunctionsRepository.call('deleteSplitwiseSession'));
      }
      if (signedToSplitz) {
        futures.add(FirebaseAuth.instance.signOut());
      }
      await Future.wait(futures);
      if (_googleAccount.clientId != null) await _googleAccount.disconnect();
    } catch (e, s) {
      LogService.log('Error on Auth.signOut', e, s);
    }
  }
}
