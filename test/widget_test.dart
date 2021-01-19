// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:advanced_skill_exam/main.dart';

void main() {
  // testWidgets('Button text widget has text', (WidgetTester tester) async {
  //   await tester.pumpWidget(MaterialApp(
  //     home: StartUp(
  //       body: Stack(
  //         children: [
  //           Container(
  //             child: Column(
  //               children: [
  //                 Row(
  //                   children: [
  //                     Hero(
  //                       child: H1Text(
  //                         text: "Welkom bij",
  //                       ),
  //                     )
  //                   ],
  //                 )
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   ));

  //   final titleFinder = find.text('Welkom bij');

  //   expect(titleFinder, findsNothing);
  // });

  test('my first unit test', () {
    var answer = 42;
    expect(answer, 42);
  });
}
