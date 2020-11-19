import 'package:advanced_skill_exam/widgets/inherited/inherited_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//checking the role of the user and routing them to the corresponding page
//user -> Home
//admin -> Dashboard
class LoginVisual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = InheritedDataProvider.of(context).data;

    // Future.delayed(const Duration(seconds: 2), () {
    //   if (data.role == "admin") {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (BuildContext context) => InheritedDataProvider(
    //           data: data,
    //           child: Dashboard(),
    //         ),
    //       ),
    //     );
    //   } else {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (BuildContext context) => InheritedDataProvider(
    //           data: data,
    //           child: Home(),
    //         ),
    //       ),
    //     );
    //   }
    // });
    return Container(
      color: Color.fromRGBO(255, 129, 128, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text("Advanced Skill toets Jasper Paardekooper"),
          Container(
            color: Color.fromRGBO(255, 129, 128, 1),
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Color.fromRGBO(72, 72, 72, 1),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
