import 'package:advanced_skill_exam/screens/signin.dart';
import 'package:advanced_skill_exam/screens/signup.dart';
import 'package:flutter/material.dart';

class StartUp extends StatelessWidget {
  void _goToSignIn(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SignIn(),
      ),
    );
  }

  void _goToSignUp(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SignUp(),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FlatButton(
            onPressed: () => _goToSignIn(context),
            child: Text("inloggen"),
          ),
          SizedBox(height: 30),
          FlatButton(
            onPressed: () => _goToSignUp(context),
            child: Text("Aanmelden"),
          )
        ],
      ),
    ));
  }
}
