import 'package:advanced_skill_exam/widgets/theme/color_theme.dart';
import 'package:flutter/material.dart';

class BottomNavigationLogo extends StatelessWidget {
  BottomNavigationLogo({this.bottomAppIcon, this.bottomAppName, this.visible});

  final IconData bottomAppIcon;
  final String bottomAppName;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width * 0.19,
        maxWidth: MediaQuery.of(context).size.width * 0.19,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: visible ? Theme.of(context).primaryColor : Colors.transparent,
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            bottomAppIcon,
            color: visible ? Colors.white : ColorTheme.green,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            bottomAppName,
            style: TextStyle(
              fontSize: 12,
              color: visible ? Colors.white : ColorTheme.green,
            ),
          ),
        ],
      ),
    );
  }
}
