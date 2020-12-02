import 'package:flutter/material.dart';

class H1Text extends StatelessWidget {
  const H1Text({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Text(
        text,
        style: TextStyle(
            color: const Color(0xFF253635),
            fontSize: MediaQuery.of(context).size.height * 0.04,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none),
      ),
    );
  }
}
