import 'package:advanced_skill_exam/controllers/auth_controller.dart';
import 'package:advanced_skill_exam/widgets/button/confirm_orange_button.dart';
import 'package:advanced_skill_exam/widgets/inherited/inherited_widget.dart';
import 'package:advanced_skill_exam/widgets/painter/top_large_wave_painter.dart';
import 'package:advanced_skill_exam/widgets/theme/color_theme.dart';
import 'package:flutter/material.dart';

class SettingsTab extends StatefulWidget {
  SettingsTab({Key key}) : super(key: key);

  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);
    return Stack(
      children: [
        Hero(
          tag: 'background',
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
            painter: TopLargeWavePainter(
              color: ColorTheme.extraLightGreen,
            ),
          ),
        ),
        Positioned.fill(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_userData.data.userName),
              Text(_userData.data.email),
              Text(_userData.data.role),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ConfirmOrangeButton(
                      text: "Uitloggen",
                      onTap: () => AuthController().signOut(context)),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Image.asset(
            'assets/images/poppetje4.png',
            scale: 2.5,
          ),
        ),
      ],
    );
  }
}
