import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:splitz/data/entities/init_result.dart';
import 'package:splitz/firebase_options.dart';
import 'package:splitz/presentation/screens/expenses_list.dart';
import 'package:splitz/presentation/screens/groups_list.dart';
import 'package:splitz/presentation/screens/login_splitwise.dart';
import 'package:splitz/presentation/screens/login_splitz.dart';
import 'package:splitz/navigator.dart';
import 'package:splitz/presentation/theme/theme.dart';
import 'package:splitz/presentation/theme/util.dart';
import 'package:splitz/services/splitz_service.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
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
  InitResult? initResult;

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  Future<void> checkAuth() async {
    final result = await SplitzService.init();
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
        return const SplitwiseLoginScreen();
      case FirstScreen.groupsList:
        return const GroupsListScreen();
      case FirstScreen.group:
        return ExpensesListScreen(groupId: initResult!.args as String);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme =
        createTextTheme(context, "Roboto Slab", "Roboto Serif");
    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      navigatorKey: AppNavigator.navigator,
      home: getFirstScreen(),
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
    );
  }
}
