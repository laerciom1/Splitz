import 'package:flutter/material.dart';
import 'package:splitz/presentation/screens/login_splitwise.dart';
import 'package:splitz/presentation/widgets/button_primary.dart';
import 'package:splitz/presentation/widgets/snackbar.dart';
import 'package:splitz/services/auth.dart';
import 'package:splitz/services/navigator.dart';

class SplitzLoginScreen extends StatelessWidget {
  const SplitzLoginScreen({super.key});

  Future<void> doLogin() async {
    final result = await Auth.splitzSignIn();
    if (result == false) {
      showToast('Login with Google has failed');
    } else {
      AppNavigator.push(const SplitwiseLoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(onPressed: doLogin, text: 'Login with Google'),
          ],
        ),
      ),
    );
  }
}
