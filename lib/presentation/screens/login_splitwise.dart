import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:splitz/util/extensions/strings.dart';
import 'package:splitz/presentation/screens/groups_list.dart';
import 'package:splitz/presentation/templates/base_screen.dart';
import 'package:splitz/presentation/widgets/button_primary.dart';
import 'package:splitz/presentation/widgets/snackbar.dart';
import 'package:splitz/application/services/auth_service.dart';
import 'package:splitz/core/navigator.dart';
import 'package:splitz/application/services/splitz_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SplitwiseLoginScreen extends StatefulWidget {
  const SplitwiseLoginScreen({super.key, this.code});

  final String? code;

  @override
  State<SplitwiseLoginScreen> createState() => _SplitwiseLoginScreenState();
}

class _SplitwiseLoginScreenState extends State<SplitwiseLoginScreen> {
  bool shouldShowWebview = false;
  bool loading = false;
  WebViewController? controller;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(onNavigationRequest: onNavigationRequest),
        );
    } else {
      proccessCode(widget.code);
    }
  }

  Future<NavigationDecision> onNavigationRequest(NavigationRequest request) async {
    final code = SplitzService.checkRedirectUrlAndGetCode(Uri.parse(request.url));
    if (code.isNotEmpty) {
      await proccessCode(code);
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  Future<void> doLogin() async {
    final authUrl = AuthService.getSplitwiseAuthURL();
    if (!kIsWeb) {
      setState(() {
        shouldShowWebview = true;
      });
      WebViewCookieManager().clearCookies();
      await controller?.clearCache();
      controller?.loadRequest(authUrl);
      return;
    }
    await launchUrl(authUrl, webOnlyWindowName: '_self');
  }

  Future<void> proccessCode(String? code) async {
    if (code.isNullOrEmpty) return;
    try {
      setState(() {
        loading = true;
      });
      await AuthService.exchangeSplitwiseAuthorizationCode(code!);
      await SplitzService.getAndSaveCurrentSplitwiseUser();
      AppNavigator.replaceAll([const GroupsListScreen()]);
    } catch (e) {
      showToast('Login to Splitwise has failed');
      setState(() {
        loading = false;
        shouldShowWebview = false;
      });
    }
  }

  Future<void> cancelLogin() async => await SplitzService.signOut();

  @override
  Widget build(BuildContext context) {
    return shouldShowWebview
        ? WebViewWidget(controller: controller!)
        : BaseScreen(
            onPop: (_, __) async {},
            appBar: false,
            child: Center(
              child: Column(
                children: [
                  PrimaryButton(onPressed: doLogin, text: 'Login to Splitwise', enabled: !loading),
                  SizedBox(height: 16),
                  PrimaryButton(onPressed: cancelLogin, text: 'Cancel', enabled: !loading),
                  if (loading) ...[SizedBox(height: 16), const CircularProgressIndicator()],
                ],
              ),
            ),
          );
  }
}
