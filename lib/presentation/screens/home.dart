import 'package:flutter/material.dart';
import 'package:splitz/presentation/screens/login_splitz.dart';
import 'package:splitz/presentation/widgets/button_primary.dart';
import 'package:splitz/services/auth.dart';
import 'package:splitz/services/navigator.dart';
import 'package:splitz/services/splitz.dart';
import 'package:splitz/services/splitwise.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> doLogout() async {
    await Auth.signOut();
    AppNavigator.replaceAll([const SplitzLoginScreen()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(onPressed: doLogout, text: 'Logout'),
            const PrimaryButton(
                onPressed: Splitwise.test, text: 'Splitwise.test'),
            const PrimaryButton(onPressed: Splitz.test, text: 'Splitz.test'),
          ],
        ),
      ),
    );
  }
}
