import 'package:advanced_skill_exam/controllers/auth_controller.dart';
import 'package:advanced_skill_exam/widgets/forms/custom_textformfield.dart';
import 'package:advanced_skill_exam/widgets/inherited/inherited_widget.dart';
import 'package:advanced_skill_exam/widgets/login/login_visual.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  static const Color black = Color.fromRGBO(72, 72, 72, 1);
  static const Color red = Color.fromRGBO(255, 129, 128, 1);

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordChecker = TextEditingController();
  final _key = GlobalKey<ScaffoldState>();
  final AuthController _authController = AuthController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordChecker.dispose();
    super.dispose();
  }

  void goBack() {
    Navigator.pop(context);
  }

  void registerAccount() {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      checkAccountDetails();
    } else {
      resetSignInPage();
    }
  }

  checkAccountDetails() async {
    var _appUser = await _authController.signUpWithEmailAndPassword(
      _emailController.text,
      _usernameController.text,
      _passwordController.text,
    );

    //   .then((value) {
    if (_appUser != null) {
      /// mapping user data
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => InheritedDataProvider(
            data: _appUser,
            child: LoginVisual(),
          ),
        ),
      );
    } else {
      resetSignInPage();
    }
  }

  void resetSignInPage() {
    setState(() {
      _isLoading = false;

      _key.currentState.showSnackBar(
        SnackBar(
          backgroundColor: black,
          content: Text(
            "Er is iets misgegaan",
            style: TextStyle(color: Colors.red, fontSize: 14),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold is used to utilize all the material widgets
    return Scaffold(
      key: _key,
      backgroundColor: Color.fromRGBO(255, 129, 128, 1),
      body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 28),
                Text("Advanced skill set"),

                SizedBox(height: MediaQuery.of(context).size.height / 14),
                Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text("Vul hier uw gebruikersnaam adres in")),
                // username
                CustomTextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  textcontroller: _usernameController,
                  errorMessage: "Geen geldige gebruikersnaam",
                  validator: 1,
                  secureText: false,
                ),
                //email
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 16),
                  child: Text("Vul hier uw e-mail adres in"),
                ),
                CustomTextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textcontroller: _emailController,
                  errorMessage: "Gebruik een geldige e-mail adres",
                  validator: 2,
                  secureText: false,
                ),

                Padding(
                    padding: const EdgeInsets.only(left: 8, top: 16),
                    child: Text("Vul hier uw wachtwoord in")),
                //Password
                CustomTextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  textcontroller: _passwordController,
                  errorMessage: "Gebruik minimaal 6 karakters",
                  validator: 1,
                  secureText: true,
                ),

                Padding(
                    padding: const EdgeInsets.only(left: 8, top: 16),
                    child: Text("Herhaal wachtwoord")),
                //Password Checker
                CustomTextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  textcontroller: _passwordChecker,
                  errorMessage: "wachtwoord komt niet overeen",
                  validator: 3,
                  secureText: true,
                  passwordChecker: _passwordController.text,
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 30),
                // inloggen
                Container(
                  margin: const EdgeInsets.only(left: 60, right: 60),
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : FlatButton(
                          onPressed: registerAccount,
                          child: Text("Aanmelden"),
                        ),
                ),
                SizedBox(
                  height: 16,
                ),
                // terug
                Container(
                  margin: const EdgeInsets.only(left: 60, right: 60),
                  child: FlatButton(
                    onPressed: goBack,
                    child: Text("Terug"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
