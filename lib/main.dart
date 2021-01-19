import 'package:advanced_skill_exam/controllers/auth_controller.dart';
import 'package:advanced_skill_exam/helper/functions.dart';
import 'package:advanced_skill_exam/screens/startup.dart';
import 'package:advanced_skill_exam/widgets/inherited/inherited_widget.dart';
import 'package:advanced_skill_exam/screens/login_visual.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  loadResources();
}

loadResources() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthController _authController = AuthController();
  final Location location = Location();

  bool _isLoggedin = false;
  String _email, _password;
  var result;
  PermissionStatus permissionGranted;

  @override
  void initState() {
    super.initState();
    checkUserLoggedInStatus();

    _checkPermissions();
  }

  Future checkUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      if (value ?? false) {
        getUserInfo();
      }
      setState(() {
        _isLoggedin = value;
      });
    });
  }

  Future<void> _checkPermissions() async {
    if (await location.hasPermission() == PermissionStatus.granted) {
      permissionGranted = await location.hasPermission();
      //  setState(() {

      //    });
    } else {
      permissionGranted = await location.requestPermission();
      if (permissionGranted == PermissionStatus.granted) {
        setState(() {});
      }
    }
  }

  getUserInfo() async {
    await HelperFunctions.getUserEmailSharedPreference().then((value) {
      _email = value;
    });

    await HelperFunctions.getUserPasswordSharedPreference().then((value) {
      _password = value;
    });

    result =
        await _authController.signInWithEmailAndPassword(_email, _password);
    setState(() {});
  }

  signIn() {
    if (result != null) {
      return InheritedDataProvider(child: LoginVisual(), data: result);
    } else {
      return StartUp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '17039886 Jasper Paardekooper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        primaryColor: const Color(0xFF456A67),
        // accentColor: const ,
      ),
      darkTheme: ThemeData.dark(),
      home: (_isLoggedin ?? false)
          //if the vallue is null (not found) change value to false
          ? signIn()
          : StartUp(),
    );
  }
}
