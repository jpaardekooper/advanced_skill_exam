import 'package:flutter/material.dart';

class ConfirmGreyButton extends StatelessWidget {
  const ConfirmGreyButton({
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
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [const Color(0xFF2E5350), Theme.of(context).primaryColor],
            stops: [0.1, 0.1],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          constraints: BoxConstraints(
              minWidth: 100,
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
