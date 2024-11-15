import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:splitz/firebase_options.dart';
import 'package:splitz/presentation/screens/home.dart';
import 'package:splitz/presentation/screens/login.dart';
import 'package:splitz/services/auth.dart';
import 'package:splitz/services/navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppNavigator.navigator,
      home: const LoginScreen(),
    );
  }
}
