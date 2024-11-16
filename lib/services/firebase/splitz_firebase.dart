import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

abstract class SplitzFirebase {
  static FirebaseApp get app => Firebase.app();
  static FirebaseAuth get auth => FirebaseAuth.instance;
}