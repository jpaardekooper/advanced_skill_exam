import 'package:advanced_skill_exam/screens/signin.dart';
import 'package:advanced_skill_exam/screens/signup.dart';
import 'package:advanced_skill_exam/widgets/button/confirm_orange_button.dart';
import 'package:advanced_skill_exam/widgets/painter/top_large_wave_painter.dart';
import 'package:advanced_skill_exam/widgets/theme/color_theme.dart';
import 'package:advanced_skill_exam/widgets/theme/h1_text.dart';
import 'package:advanced_skill_exam/widgets/transistion/route_transition.dart';
import 'package:flutter/material.dart';

class StartUp extends StatefulWidget {
  StartUp({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<StartUp> {
  void _goToSignIn() {
    Navigator.of(context).push(
      createRoute(SignIn()),
    );
  }

  void tutorial() {
    Navigator.of(context).push(
      createRoute(SignUp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: 'background',
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height),
              painter: TopLargeWavePainter(
                color: ColorTheme.extraLightOrange,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'intro-text',
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2.2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              H1Text(
                                text: "Welkom bij",
                              ),
                              H1Text(
                                text: "Jasper Paardekooper Advanced Skill Exam",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Hero(
                      tag: 'welcome-logo',
                      child: Image.asset(
                        'assets/images/poppetje1.png',
                        scale: 2,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      ConfirmOrangeButton(
                        text: "Inloggen",
                        onTap: _goToSignIn,
                        color: Theme.of(context).primaryColor,
                        bottomColor: ColorTheme.darkGreen,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ConfirmOrangeButton(text: "Registreren", onTap: tutorial)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
