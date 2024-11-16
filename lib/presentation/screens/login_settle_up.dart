// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:splitz/extensions/widgets.dart';
import 'package:splitz/presentation/screens/home.dart';
import 'package:splitz/presentation/widgets/button_primary.dart';
import 'package:splitz/presentation/widgets/field_primary.dart';
import 'package:splitz/presentation/widgets/snackbar.dart';
import 'package:splitz/services/auth.dart';
import 'package:splitz/services/navigator.dart';

class SettleUpLoginScreen extends StatelessWidget {
   SettleUpLoginScreen({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> doLogin() async {
    final email = emailController.value.text;
    final password = passwordController.value.text;
    final result = await Auth.settleUpSignIn(email, password);
    if (result == false) {
      showToast('Login to SettleUp has failed');
    } else {
      AppNavigator.replaceAll([const HomeScreen()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryField(
              labelText: 'E-mail',
              controller: emailController,
            ),
            SizedBox(height: 12),
            PrimaryField(
              labelText: 'Password',
              controller: passwordController,
              obscureText: true,
            ),
            SizedBox(height: 12),
            PrimaryButton(text: 'Login to SettleUp', onPressed: doLogin)
          ],
        ).withPadding(const EdgeInsets.symmetric(horizontal: 24)),
      ),
    );
  }
}
