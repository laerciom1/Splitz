import 'package:flutter/material.dart';
import 'package:splitz/presentation/screens/login_splitwise.dart';
import 'package:splitz/presentation/templates/base_screen.dart';
import 'package:splitz/presentation/widgets/button_primary.dart';
import 'package:splitz/presentation/widgets/snackbar.dart';
import 'package:splitz/application/services/auth_service.dart';
import 'package:splitz/core/navigator.dart';

class SplitzLoginScreen extends StatefulWidget {
  const SplitzLoginScreen({super.key});

  @override
  State<SplitzLoginScreen> createState() => _SplitzLoginScreenState();
}

class _SplitzLoginScreenState extends State<SplitzLoginScreen> {
  bool loading = false;

  Future<void> doLogin() async {
    setState(() {
      loading = true;
    });

    final loginSuccess = await AuthService.splitzSignIn();
    if (loginSuccess == false) {
      showToast('Login with Google has failed');
      setState(() {
        loading = false;
      });
      return;
    }

    final isAllowedUser = await AuthService.isAllowedUser;
    if (!isAllowedUser) {
      showToast('You are not allowed to use Splitz');
      await AuthService.signOut();
      setState(() {
        loading = false;
      });
      return;
    }

    AppNavigator.replaceAll([const SplitwiseLoginScreen()]);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      onPop: (_, __) async {},
      appBar: false,
      child: Center(
        child: Column(
          children: [
            PrimaryButton(onPressed: doLogin, text: 'Login with Google', enabled: !loading),
            if (loading) ...[SizedBox(height: 16.0), const CircularProgressIndicator()],
          ],
        ),
      ),
    );
  }
}
