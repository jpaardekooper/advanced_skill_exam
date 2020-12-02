import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LifestyleLogo extends StatelessWidget {
  LifestyleLogo({@required this.size, this.description});

  final double size;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'intro-text',
      child: Material(
        color: Colors.transparent,
        borderOnForeground: false,
        child: Container(
          color: Colors.transparent,
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height * 0.2,
          ),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/images/hart.png'),
                  width: size,
                  height: size,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(description ?? ""),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
