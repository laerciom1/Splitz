import 'package:flutter/material.dart';
import 'package:splitz/presentation/screens/home.dart';
import 'package:splitz/presentation/widgets/buttons/primary_button.dart';
import 'package:splitz/presentation/widgets/snackbar/snackbar.dart';
import 'package:splitz/services/auth.dart';
import 'package:splitz/services/navigator.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> doLogin() async {
    final user = await Auth.signIn();
    if (user != null) {
      AppNavigator.replaceAll([const HomeScreen()]);
    } else {
      showToast('Login with Google has failed');
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
