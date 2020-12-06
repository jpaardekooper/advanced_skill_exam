import 'dart:math';

import 'package:advanced_skill_exam/models/marker_model.dart';
import 'package:advanced_skill_exam/repositories/map_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:faker/faker.dart';

class MapRepository implements IMapRepository {
  @override
  Future<List<ClusterItem<MarkerModel>>> getMapMarkersList(
      GeoPoint north, GeoPoint south) async {
    List<MarkerModel> fetchMarkers = [];
    List<ClusterItem<MarkerModel>> loadedMarkers = [];

    var snapshot = await FirebaseFirestore.instance
        .collection("markers")
        .where('location', isLessThanOrEqualTo: north)
        .where('location', isGreaterThanOrEqualTo: south)
        .get();

    snapshot.docs.map((DocumentSnapshot doc) {
      return fetchMarkers.add(MarkerModel.fromSnapshot(doc));
    }).toList();

    for (int i = 0; i < fetchMarkers.length; i++) {
      loadedMarkers.add(
        ClusterItem<MarkerModel>(
          LatLng(
            fetchMarkers[i].location.latitude,
            fetchMarkers[i].location.longitude,
          ),
          item: fetchMarkers[i],
        ),
      );
    }

    fetchMarkers.clear();

    return loadedMarkers;
  }

  final random = Random();
  double nextDouble(num min, num max) =>
      min + random.nextDouble() * (max - min);

  @override
  Future<void> setMarkers() async {
    // double randomLat = nextDouble(51.5, 53);
    // double randomLng = nextDouble(4.2, 6.5);
    // print('$randomLat, $randomLng');

    for (int i = 0; i < 1000; i++) {
      var test = MarkerModel(
          name: faker.person.name(),
          isClosed: i % 4 == 0 ? true : false,
          location: GeoPoint(nextDouble(51.5, 53), nextDouble(4.2, 6.5)));

      Map<String, dynamic> data = {
        'name': test.name,
        'isClosed': i % 4 == 0 ? true : false,
        'location': test.location
      };

      await FirebaseFirestore.instance
          .collection("markers")
          .doc()
          .set(data)
          .catchError((e) {});
    }
  }

  @override
  Future<void> updateMarker(Map data) async {
    await FirebaseFirestore.instance
        .collection("markers")
        .doc()
        .set(data)
        .catchError((e) {});
  }

  @override
  Future<void> removeSurvey(String id) async {
    await FirebaseFirestore.instance
        .collection("surveys")
        .doc(id)
        .delete()
        .catchError((e) {});
  }
}
