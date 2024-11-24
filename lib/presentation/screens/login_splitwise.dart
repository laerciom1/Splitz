import 'package:flutter/material.dart';
import 'package:splitz/presentation/screens/groups_list.dart';
import 'package:splitz/presentation/widgets/button_primary.dart';
import 'package:splitz/presentation/widgets/snackbar.dart';
import 'package:splitz/services/auth_service.dart';
import 'package:splitz/navigator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SplitwiseLoginScreen extends StatefulWidget {
  const SplitwiseLoginScreen({super.key});

  @override
  State<SplitwiseLoginScreen> createState() => _SplitwiseLoginScreenState();
}

class _SplitwiseLoginScreenState extends State<SplitwiseLoginScreen> {
  bool shouldLoadPage = false;
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(onNavigationRequest: onNavigationRequest),
      );
  }

  Future<NavigationDecision> onNavigationRequest(
    NavigationRequest request,
  ) async =>
      await AuthService.onNavigationRequest(request, onResult);

  Future<void> doLogin() async {
    setState(() {
      shouldLoadPage = true;
      controller.loadRequest(AuthService.getSplitwiseAuthURL());
    });
  }

  void onResult(bool success) {
    if (success) {
      AppNavigator.replaceAll([const GroupsListScreen()]);
    } else {
      showToast('Login to Splitwise has failed');
      setState(() {
        shouldLoadPage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shouldLoadPage
          ? WebViewWidget(controller: controller)
          : Center(
              child:
                  PrimaryButton(onPressed: doLogin, text: 'Login to Splitwise'),
            ),
    );
  }
}
