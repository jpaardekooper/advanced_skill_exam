import 'package:advanced_skill_exam/controllers/auth_controller.dart';
import 'package:advanced_skill_exam/models/firebase_user.dart';
import 'package:advanced_skill_exam/widgets/button/confirm_orange_button.dart';
import 'package:advanced_skill_exam/widgets/forms/custom_textformfield.dart';
import 'package:advanced_skill_exam/widgets/inherited/inherited_widget.dart';
import 'package:advanced_skill_exam/screens/login_visual.dart';
import 'package:advanced_skill_exam/widgets/painter/top_small_wave_painter.dart';
import 'package:advanced_skill_exam/widgets/theme/color_theme.dart';
import 'package:advanced_skill_exam/widgets/theme/logo_theme.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  AuthController _authController = AuthController();

  bool _isLoading = false;
  String userName = "";
  bool rememberMe = false;
  String userRole;

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
      });

  void changeValue() {
    setState(() {
      rememberMe = !rememberMe;
    });
  }

  void goBack() {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _key,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              Hero(
                tag: 'background',
                child: CustomPaint(
                  size: Size(size.width, size.height),
                  painter: TopSmallWavePainter(
                    color: ColorTheme.extraLightOrange,
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Center(
                          child: LifestyleLogo(
                            size: 100,
                            description: "Log in met uw account",
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Vul hier uw e-mail adres in",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.025),
                            ),

                            // username
                            CustomTextFormField(
                              keyboardType: TextInputType.emailAddress,
                              textcontroller: _emailController,
                              errorMessage: "Geen geldige e-mail adres",
                              validator: 1,
                              secureText: false,
                              hintText: 'email@example.nl',
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            Text(
                              "Vul hier uw wachtwoord in",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.025),
                            ),
                            // username
                            CustomTextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              textcontroller: _passwordController,
                              errorMessage: "Geen geldige e-mail adres",
                              validator: 1,
                              secureText: true,
                            ),
                            ListTile(
                              autofocus: false,
                              onTap: changeValue,
                              contentPadding: const EdgeInsets.all(0),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Mij onthouden",
                                    style: TextStyle(color: ColorTheme.grey),
                                    textAlign: TextAlign.right,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Checkbox(
                                      value: rememberMe,
                                      onChanged: _onRememberMeChanged,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                onTap: goBack,
                                title: Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_back,
                                      size: 18,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("terug"),
                                  ],
                                ),
                              ),
                            ),
                            _isLoading
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ConfirmOrangeButton(
                                    text: "Aanmelden",
                                    onTap: signIn,
                                  )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  signIn() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      AppUser result = await _authController.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      if (result != null) {
        await _authController.saveUserDetailsOnLogin(
            result, _passwordController.text, rememberMe);

        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InheritedDataProvider(
              data: result,
              child: LoginVisual(),
            ),
          ),
        );
      } else {
        resetSignInPage();
      }
    } else {
      resetSignInPage();
    }
  }

  void resetSignInPage() {
    setState(() {
      _isLoading = false;
      _key.currentState.showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: ColorTheme.accentOrange,
          content: Text(
            "Er is iets mis gegaan probeer het nog eens",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    });
  }
}
