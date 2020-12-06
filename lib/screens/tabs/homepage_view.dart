import 'package:advanced_skill_exam/screens/tabs/maps_tab.dart';
import 'package:advanced_skill_exam/screens/tabs/settings_tab.dart';
import 'package:advanced_skill_exam/screens/tabs/tensorflow_tab.dart';
import 'package:advanced_skill_exam/widgets/theme/bottom_navigation_logo.theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ask_question_tab.dart';

final ValueNotifier<int> counter = ValueNotifier<int>(0);

class HomepageView extends StatefulWidget {
  HomepageView({Key key}) : super(key: key);

  @override
  _HomepageViewState createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView> {
  List<Widget> _widgetOptions;

  @override
  void initState() {
    _widgetOptions = <Widget>[
      MapsTab(),
      TensorflowTab(),
      AskQuestionTab(),
      SettingsTab(),
    ];
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      counter.value = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: ValueListenableBuilder(
          builder: (BuildContext context, int value, Widget child) {
            // This builder will only get called when the counter
            // is updated.
            return _widgetOptions.elementAt(counter.value);
          },
          valueListenable: counter,
        ),
        bottomNavigationBar: ValueListenableBuilder(
            valueListenable: counter,
            builder: (BuildContext context, int value, Widget child) {
              return BottomNavigationBar(
                iconSize: MediaQuery.of(context).size.width * 0.05,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.black,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: BottomNavigationLogo(
                      bottomAppIcon: Icons.map,
                      bottomAppName: 'Maps',
                      visible: counter.value == 0,
                    ),
                    label: 'Maps',
                  ),
                  BottomNavigationBarItem(
                    icon: BottomNavigationLogo(
                      bottomAppIcon: Icons.camera_alt,
                      bottomAppName: 'Tensorflow',
                      visible: counter.value == 1,
                    ),
                    label: 'Tensorflow',
                  ),
                  BottomNavigationBarItem(
                    icon: BottomNavigationLogo(
                      bottomAppIcon: Icons.question_answer,
                      bottomAppName: 'QNA',
                      visible: counter.value == 2,
                    ),
                    label: 'QNA',
                  ),
                  // BottomNavigationBarItem(
                  //   icon: BottomNavigationLogo(
                  //     bottomAppIcon: Icons.list,
                  //     bottomAppName: 'survey',
                  //     visible: counter.value == 3,
                  //   ),
                  //   label: 'survey',
                  // ),
                  BottomNavigationBarItem(
                    icon: BottomNavigationLogo(
                      bottomAppIcon: Icons.settings,
                      bottomAppName: 'instellingen',
                      visible: counter.value == 3,
                    ),
                    label: 'instellingen',
                  ),
                ],
                currentIndex: counter.value,
                //    selectedItemColor: Colors.red[800],
                onTap: _onItemTapped,
              );
            }),
      ),
    );
  }
}
