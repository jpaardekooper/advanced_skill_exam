import 'package:advanced_skill_exam/models/marker_model.dart';

import 'package:flutter/material.dart';

class MapsSinglePage extends StatefulWidget {
  MapsSinglePage({Key key, @required this.place}) : super(key: key);
  final MarkerModel place;

  @override
  _MapsSinglePageState createState() => _MapsSinglePageState();
}

class _MapsSinglePageState extends State<MapsSinglePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.name),
      ),
      body: Text(widget.place.name),
    );
  }
}
