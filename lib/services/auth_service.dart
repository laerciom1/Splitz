import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oauth2/oauth2.dart';
import 'package:splitz/services/log_service.dart';
import 'package:splitz/data/repositories/storage_repo.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Splitz
final _googleAccount = GoogleSignIn();

// Splitwise
const _consumerKey = String.fromEnvironment('SW_CONSUMER_KEY');
const _consumerSecret = String.fromEnvironment('SW_CONSUMER_SECRET');
final _authEndpoint =
    Uri.parse(const String.fromEnvironment('SW_AUTH_ENDPOINT'));
final _tokenEndpoint =
    Uri.parse(const String.fromEnvironment('SW_TOKEN_ENDPOINT'));
final _redirectUrl = Uri.parse(const String.fromEnvironment('SW_REDIRECT_URL'));
const _storageKey = 'SW_AUTH_STORAGE_KEY';

final _grant = AuthorizationCodeGrant(
  _consumerKey,
  _authEndpoint,
  _tokenEndpoint,
  secret: _consumerSecret,
  basicAuth: false,
);

abstract class AuthService {
  // Splitz
  static bool get isSignedInToSplitz {
    try {
      return FirebaseAuth.instance.currentUser != null;
    } catch (e, s) {
      LogService.log('Error on Auth.isSignedInToSplitz', error: e, stackTrace: s);
      return false;
    }
  }

  static Future<bool?> splitzSignIn() async {
    try {
      if (AuthService.isSignedInToSplitz) return null;
      final googleAccount = await _googleAccount.signIn();
      final googleAuth = await googleAccount?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      return true;
    } catch (e, s) {
      LogService.log('Error on Auth.splitzSignIn', error: e, stackTrace: s);
      return false;
    }
  }

  // Splitwise
  static String? _splitwiseToken;
  static Future<String?> get splitwiseToken async {
    try {
      if (_splitwiseToken != null) return _splitwiseToken;
      final storedCredentials = await StorageService.read(_storageKey);
      if (storedCredentials == null) return null;
      final credentials = Credentials.fromJson(storedCredentials);
      _splitwiseToken = credentials.accessToken;
      return _splitwiseToken;
    } catch (e, s) {
      LogService.log('Error on Auth.splitwiseToken', error: e, stackTrace: s);
      return null;
    }
  }

  static Future<bool> get isSignedInToSplitwise async {
    try {
      return (await splitwiseToken) != null;
    } catch (e, s) {
      LogService.log('Error on Auth.isSignedInToSplitwise', error: e, stackTrace: s);
      return false;
    }
  }

  static Uri getSplitwiseAuthURL() => _grant.getAuthorizationUrl(_redirectUrl);

  static Future<NavigationDecision> onNavigationRequest(
    NavigationRequest request,
    void Function(bool success) onResult,
  ) async {
    try {
      if (request.url.contains(_redirectUrl.toString())) {
        final uri = Uri.parse(request.url);
        final queryParams = uri.queryParameters;
        if (queryParams.containsKey('code')) {
          final credentials =
              (await _grant.handleAuthorizationResponse(queryParams))
                  .credentials;
          await StorageService.save(_storageKey, credentials.toJson());
          onResult(true);
          return NavigationDecision.prevent;
        }
      }
      return NavigationDecision.navigate;
    } catch (e, s) {
      LogService.log('Auth.onNavigationRequest', error: e, stackTrace: s);
      onResult(false);
      return NavigationDecision.prevent;
    }
  }

  // Common
  static Future<void> signOut() async {
    try {
      var futures = <Future<void>>[];
      if (await AuthService.isSignedInToSplitwise) {
        futures.add(StorageService.clear(_storageKey));
      }
      if (AuthService.isSignedInToSplitz) {
        futures.add(FirebaseAuth.instance.signOut());
      }
      await Future.wait(futures);
      await _googleAccount.disconnect();
    } catch (e, s) {
      LogService.log('Error on Auth.signOut', error: e, stackTrace: s);
    }
  }
}
