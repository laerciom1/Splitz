import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:splitz/firebase_options.dart';
import 'package:splitz/presentation/screens/home.dart';
import 'package:splitz/presentation/screens/login_settle_up.dart';
import 'package:splitz/presentation/screens/login_splitz.dart';
import 'package:splitz/services/auth.dart';
import 'package:splitz/services/navigator.dart';
import 'package:splitz/presentation/theme/theme.dart';
import 'package:splitz/presentation/theme/util.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
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
  bool _isSignedInToSplitz = true;
  bool _isSignedInToSettleUp = true;

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  Future<void> checkAuth() async {
    final isSignedInToSplitz = Auth.isSignedInToSplitz;
    final isSignedInToSettleUp = await Auth.isSignedInToSettleUp;
    setState(() {
      _isSignedInToSplitz = isSignedInToSplitz;
      _isSignedInToSettleUp = isSignedInToSettleUp;
      FlutterNativeSplash.remove();
    });
  }

  Widget getFirstScreen() {
    if (_isSignedInToSplitz && _isSignedInToSettleUp) return const HomeScreen();
    if (_isSignedInToSplitz && !_isSignedInToSettleUp) {
      return SettleUpLoginScreen();
    }
    return const SplitzLoginScreen();
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
