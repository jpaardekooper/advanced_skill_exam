import 'package:advanced_skill_exam/controllers/auth_controller.dart';
import 'package:advanced_skill_exam/screens/login_visual.dart';
import 'package:advanced_skill_exam/widgets/button/confirm_orange_button.dart';
import 'package:advanced_skill_exam/widgets/forms/custom_textformfield.dart';
import 'package:advanced_skill_exam/widgets/inherited/inherited_widget.dart';
import 'package:advanced_skill_exam/widgets/theme/logo_theme.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  SignUp({
    Key key,
  }) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordChecker = TextEditingController();
  final _key = GlobalKey<ScaffoldState>();
  final AuthController _authController = AuthController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController.text = "";
  }

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
        isLoading = true;
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
      isLoading = false;

      _key.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).accentColor,
          content: Text(
            "Er is iets misgegaan",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Scaffold is used to utilize all the material widgets
    return Scaffold(
      key: _key,
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.08, vertical: size.height * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: LifestyleLogo(
                      size: 100,
                      description: "Meld je aan voor een nieuw account",
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text("Vul hier uw gebruikersnaam in"),
                  ),
                  // username
                  CustomTextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    textcontroller: _usernameController,
                    errorMessage: "Geen geldige gebruikersnaam",
                    validator: 1,
                    secureText: false,
                    hintText: 'Hiermee kunnen wij u aanspreken',
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
                    hintText: 'Vul hier uw e-mail adres in',
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 16),
                    child: Text("Vul hier uw wachtwoord in"),
                  ),
                  //Password
                  CustomTextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    textcontroller: _passwordController,
                    errorMessage: "Gebruik minimaal 6 karakters",
                    validator: 1,
                    secureText: true,
                    hintText: 'Minimaal 8 karakters',
                  ),

                  Padding(
                      padding: const EdgeInsets.only(left: 8, top: 16),
                      child: Text("Herhaal uw wachtwoord")),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                        child: ListTile(
                          autofocus: false,
                          contentPadding: const EdgeInsets.all(0),
                          onTap: () => Navigator.of(context).pop(),
                          title: Row(
                            children: [
                              Icon(Icons.arrow_back),
                              SizedBox(
                                width: 10,
                              ),
                              Text("terug"),
                            ],
                          ),
                        ),
                      ),
                      ConfirmOrangeButton(
                        text: "Volgende",
                        onTap: registerAccount,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
