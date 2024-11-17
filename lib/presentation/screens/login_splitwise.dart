// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:splitz/extensions/widgets.dart';
import 'package:splitz/presentation/screens/home.dart';
import 'package:splitz/presentation/widgets/button_primary.dart';
import 'package:splitz/presentation/widgets/snackbar.dart';
import 'package:splitz/services/auth.dart';
import 'package:splitz/services/navigator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SplitwiseLoginScreen extends StatefulWidget {
  const SplitwiseLoginScreen({super.key});

  @override
  State<SplitwiseLoginScreen> createState() => _SplitwiseLoginScreenState();
}

class _SplitwiseLoginScreenState extends State<SplitwiseLoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool shouldLoadPage = false;
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) =>
              Auth.onNavigationRequest(
            request,
            onResult,
          ),
        ),
      );
  }

  void onResult(bool success) {
    if (success) {
      AppNavigator.push(const HomeScreen());
    } else {
      showToast('Login to Splitwise has failed');
      setState(() {
        shouldLoadPage = false;
      });
    }
  }

  Future<void> doLogin() async {
    setState(() {
      shouldLoadPage = true;
      controller.loadRequest(Auth.getSplitwiseAuthURL());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shouldLoadPage
          ? WebViewWidget(controller: controller)
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryButton(text: 'Login to Splitwise', onPressed: doLogin)
                ],
              ).withPadding(const EdgeInsets.symmetric(horizontal: 24)),
            ),
    );
  }
}
