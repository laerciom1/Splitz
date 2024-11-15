import 'package:flutter/material.dart';
import 'package:splitz/presentation/widgets/buttons/primary_button.dart';
import 'package:splitz/services/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> doLogout() async {
    await Auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(onPressed: doLogout, text: 'Logout'),
          ],
        ),
      ),
    );
  }
}
