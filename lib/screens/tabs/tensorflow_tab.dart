import 'package:advanced_skill_exam/screens/tflite/tensorflow_view.dart';
import 'package:advanced_skill_exam/widgets/button/confirm_orange_button.dart';
import 'package:advanced_skill_exam/widgets/painter/bottom_large_wave_painter.dart';
import 'package:advanced_skill_exam/widgets/theme/color_theme.dart';
import 'package:flutter/material.dart';

class TensorflowTab extends StatefulWidget {
  TensorflowTab({Key key}) : super(key: key);

  @override
  _TensorflowTabState createState() => _TensorflowTabState();
}

class _TensorflowTabState extends State<TensorflowTab> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: 'background',
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
            painter: BottomLargeWavePainter(
              color: ColorTheme.extraLightGreen,
            ),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: ConfirmOrangeButton(
                      text: "open TensorFlow",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TensorFlow()),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Image.asset(
            'assets/images/poppetje2.png',
            scale: 2,
          ),
        ),
      ],
    );
  }
}
