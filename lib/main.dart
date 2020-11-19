import 'package:advanced_skill_exam/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeWidgets().then((value) => runApp(MyApp()));
}

Future<void> initializeWidgets() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp();
  await initializeDateFormatting();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignUp(),
    );
  }
}
