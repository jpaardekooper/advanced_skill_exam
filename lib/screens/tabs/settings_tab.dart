import 'package:advanced_skill_exam/controllers/auth_controller.dart';
import 'package:advanced_skill_exam/widgets/button/confirm_orange_button.dart';
import 'package:advanced_skill_exam/widgets/inherited/inherited_widget.dart';
import 'package:advanced_skill_exam/widgets/painter/top_large_wave_painter.dart';
import 'package:advanced_skill_exam/widgets/theme/color_theme.dart';
import 'package:advanced_skill_exam/widgets/theme/h1_text.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

class SettingsTab extends StatefulWidget {
  SettingsTab({Key key}) : super(key: key);

  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  Widget confirmLogout(context) {
    return AlertDialog(
      title: Text('Uitloggen'),
      content: Text('Weet u zeker dat u wilt uitloggen?'),
      actions: [
        RaisedButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Theme.of(context).primaryColor,
          child: Text(
            'Annuleren',
            style: TextStyle(color: Colors.white),
          ),
        ),
        FlatButton(
          onPressed: () async {
            await AuthController().signOut(context);
          },
          splashColor: Colors.red[300],
          highlightColor: Colors.transparent,
          child: Text(
            'Uitloggen',
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    );
  }

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
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 70,
                ),
                H1Text(text: "Instellingen"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Locatie"),
                    OutlineButton(
                        onPressed: () => AppSettings.openLocationSettings(),
                        child: Text("GPS")),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Camera"),
                    OutlineButton(
                        onPressed: () => AppSettings.openAppSettings(),
                        child: Text("Camera")),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Email"),
                    Text(_userData.data.email),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Gebruikersnaam:"),
                    Text(_userData.data.userName),
                  ],
                ),
                SizedBox(
                  height: 90,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: ConfirmOrangeButton(
                        text: "Uitloggen",
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return confirmLogout(context);
                            },
                          );
                        }),
                  ),
                ),
              ],
            ),
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
