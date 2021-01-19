import 'dart:convert';
import 'package:advanced_skill_exam/models/parse_user_model.dart';
import 'package:advanced_skill_exam/widgets/theme/h1_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardOverview extends StatefulWidget {
  @override
  _DashboardOverviewState createState() => _DashboardOverviewState();
}

class _DashboardOverviewState extends State<DashboardOverview> {
  Future<DAta> fetchUsers() async {
    final response = await http.get(
        'https://firestore.googleapis.com/v1/projects/advanced-skill-exam/databases/(default)/documents/users/');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return DAta.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H1Text(text: "Welkom admin"),
          ListTile(
            leading: Icon(Icons.map),
            title: Text("Populate databse with markers"),
            onTap: null,
          ),
          FutureBuilder<DAta>(
            future: fetchUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var item = snapshot.data;
                return ListTile(
                  leading: Icon(Icons.supervised_user_circle),
                  title: Text("Aantal App gebruikers"),
                  subtitle: Text(item.documents.length.toString()),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
