import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yellow_paper/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
