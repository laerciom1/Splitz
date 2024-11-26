import 'package:flutter/material.dart';
import 'package:splitz/presentation/screens/groups_list.dart';
import 'package:splitz/presentation/screens/login_splitz.dart';
import 'package:splitz/presentation/templates/base_screen.dart';
import 'package:splitz/presentation/widgets/button_primary.dart';
import 'package:splitz/presentation/widgets/snackbar.dart';
import 'package:splitz/services/auth_service.dart';
import 'package:splitz/navigator.dart';
import 'package:splitz/services/splitz_service.dart';
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
    });
    WebViewCookieManager().clearCookies();
    await controller.clearCache();
    controller.loadRequest(AuthService.getSplitwiseAuthURL());
  }

  Future<void> onResult(bool success) async {
    try {
      if (!success) throw Exception();
      await SplitzService.getAndSaveCurrentSplitwiseUser();
      AppNavigator.replaceAll([const GroupsListScreen()]);
    } catch (e) {
      showToast('Login to Splitwise has failed');
      setState(() {
        shouldLoadPage = false;
      });
    }
  }

  Future<void> cancelLogin() async {
    await SplitzService.signOut();
    AppNavigator.replaceAll([const SplitzLoginScreen()]);
  }

  @override
  Widget build(BuildContext context) {
    return shouldLoadPage
        ? WebViewWidget(controller: controller)
        : BaseScreen(
            onPop: (_, __) async {},
            appBar: false,
            child: Center(
              child: Column(
                children: [
                  PrimaryButton(onPressed: doLogin, text: 'Login to Splitwise'),
                  PrimaryButton(onPressed: cancelLogin, text: 'Cancel'),
                ],
              ),
            ),
          );
  }
}
