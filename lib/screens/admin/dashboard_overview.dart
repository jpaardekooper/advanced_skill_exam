import 'package:flutter/material.dart';

class DashboardOverview extends StatelessWidget {
  void addMarkers() {
    //  _mapController.setMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.map),
          title: Text("Populate databse with markers"),
          onTap: addMarkers,
        ),
        ListTile(
          leading: Icon(Icons.map),
          title: Text("Populate databse with markers"),
          onTap: null,
        ),
      ],
    );
  }
}
