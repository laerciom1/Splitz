import 'package:flutter/material.dart';
import 'package:splitz/presentation/screens/login_splitwise.dart';
import 'package:splitz/presentation/widgets/button_primary.dart';
import 'package:splitz/presentation/widgets/snackbar.dart';
import 'package:splitz/services/auth_service.dart';
import 'package:splitz/navigator.dart';

class SplitzLoginScreen extends StatelessWidget {
  const SplitzLoginScreen({super.key});

  Future<void> doLogin() async {
    final result = await AuthService.splitzSignIn();
    if (result == false) {
      showToast('Login with Google has failed');
    } else {
      AppNavigator.replaceAll([const SplitwiseLoginScreen()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PrimaryButton(onPressed: doLogin, text: 'Login with Google'),
      ),
    );
  }
}
