import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:splitz/core/navigator.dart';
import 'package:splitz/core/url_strategy/url_strategy.dart';
import 'package:splitz/application/entities/splitz/init_result_entity.dart';
import 'package:splitz/firebase_options.dart';
import 'package:splitz/presentation/screens/expenses_list.dart';
import 'package:splitz/presentation/screens/groups_list.dart';
import 'package:splitz/presentation/screens/loading.dart';
import 'package:splitz/presentation/screens/login_splitwise.dart';
import 'package:splitz/presentation/screens/login_splitz.dart';
import 'package:splitz/presentation/theme/theme.dart';
import 'package:splitz/presentation/theme/util.dart';
import 'package:splitz/presentation/widgets/web_viewport.dart';
import 'package:splitz/application/services/splitz_service.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  configureUrlStrategy();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  InitResultEntity? initResult;

  @override
  void initState() {
    super.initState();
    checkAuth(Uri.base);
  }

  Future<void> checkAuth(Uri initialUri) async {
    final result = await SplitzService.init(initialUri);
    setState(() {
      initResult = result;
      FlutterNativeSplash.remove();
    });
  }

  Widget getFirstScreen() {
    switch (initResult?.firstScreen) {
      case null:
      case FirstScreen.splitzLogin:
        return const SplitzLoginScreen();
      case FirstScreen.splitwiseLogin:
        return SplitwiseLoginScreen(code: initResult!.args as String?);
      case FirstScreen.groupsList:
        return const GroupsListScreen();
      case FirstScreen.group:
        return ExpensesListScreen(groupId: initResult!.args as String);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Lexend", "Lexend");
    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      navigatorKey: AppNavigator.navigator,
      home: initResult == null ? const LoadingScreen() : getFirstScreen(),
      builder: (context, child) {
        final content = child ?? const SizedBox.shrink();
        if (!kIsWeb) {
          return content;
        }
        return WebViewport(child: content);
      },
      theme: theme.dark(),
    );
  }
}
