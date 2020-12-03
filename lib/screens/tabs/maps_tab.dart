import 'package:advanced_skill_exam/screens/maps/maps_view.dart';
import 'package:advanced_skill_exam/widgets/button/confirm_orange_button.dart';
import 'package:advanced_skill_exam/widgets/painter/top_large_wave_painter.dart';
import 'package:advanced_skill_exam/widgets/theme/color_theme.dart';
import 'package:flutter/material.dart';

class MapsTab extends StatefulWidget {
  MapsTab({Key key}) : super(key: key);

  @override
  _MapsTabState createState() => _MapsTabState();
}

class _MapsTabState extends State<MapsTab> {
  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ConfirmOrangeButton(
                    text: "open maps",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapsView()),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Image.asset(
            'assets/images/poppetje1.png',
            scale: 2.5,
          ),
        ),
      ],
    );
  }
}
