import 'dart:convert';
import 'package:advanced_skill_exam/models/parse_marker_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MarkersOverView extends StatefulWidget {
  MarkersOverView({Key key}) : super(key: key);

  @override
  _MarkersOverViewState createState() => _MarkersOverViewState();
}

class _MarkersOverViewState extends State<MarkersOverView> {
  int count = 0;

  String lastToken = "";
  String token = "";

  Future<ParseMarker> fetchMarkers(String token) async {
    final response = await http.get(
        'https://firestore.googleapis.com/v1/projects/advanced-skill-exam/databases/(default)/documents/markers?pageSize=20&pageToken=$token');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      count += ParseMarker.fromJson(jsonDecode(response.body)).documents.length;

      return ParseMarker.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  void addMarkers() {
    //  _mapController.setMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Opgehaalde markers ${count <= 20 ? 20 : count}"),
            IconButton(
                icon: Icon(Icons.next_plan),
                onPressed: () {
                  setState(() {});
                }),
          ],
        ),
        FutureBuilder<ParseMarker>(
          future: fetchMarkers(token),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var item = snapshot.data;
              token = item.nextPageToken;

              return Expanded(
                //   height: 500,
                child: ListView.builder(
                  shrinkWrap: true,
                  //   physics: NeverScrollableScrollPhysics(),
                  itemCount: item.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    var marker = item.documents[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                      child: Material(
                        elevation: 10,
                        child: ListTile(
                          leading: Container(
                            constraints: BoxConstraints(
                              maxWidth: 50,
                              maxHeight: 50,
                            ),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                              imageUrl: marker.fields.url.stringValue,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(marker.fields.company.stringValue),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("latitude: " +
                                  marker.fields.lat.doubleValue.toString()),
                              Text("longitude: " +
                                  marker.fields.long.doubleValue.toString()),
                            ],
                          ),
                          trailing: Icon(
                            Icons.circle,
                            color: marker.fields.isClosed.booleanValue
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }
}
