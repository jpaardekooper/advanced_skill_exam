import 'package:advanced_skill_exam/widgets/theme/color_theme.dart';
import 'package:flutter/material.dart';

class ConfirmOrangeButton extends StatelessWidget {
  const ConfirmOrangeButton({
    this.text,
    this.onTap,
    this.color,
    this.bottomColor,
  });

  final String text;
  final VoidCallback onTap;
  final Color color;
  final Color bottomColor;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      padding: const EdgeInsets.all(0.0),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              bottomColor ?? ColorTheme.darkOrange,
              color ?? ColorTheme.accentOrange,
            ],
            stops: [0.1, 0.1],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          //   color: Colors.blue,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Container(
          constraints: BoxConstraints(
              minWidth: 150,
              minHeight: 55.0,
              maxHeight: 55.0), // min sizes for Material buttons
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'Sofia'),
          ),
        ),
      ),
    );
  }
}
