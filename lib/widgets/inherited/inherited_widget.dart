import 'package:advanced_skill_exam/models/firebase_user.dart';
import 'package:flutter/material.dart';

class InheritedDataProvider extends InheritedWidget {
  const InheritedDataProvider({
    Key key,
    @required this.data,
    @required Widget child,
  })  : assert(data != null),
        assert(child != null),
        super(key: key, child: child);

  final AppUser data;

  static InheritedDataProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedDataProvider>();
  }

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(InheritedDataProvider old) => data != old.data;
}
