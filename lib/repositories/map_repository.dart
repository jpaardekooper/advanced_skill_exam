import 'dart:math';

import 'package:advanced_skill_exam/models/marker_model.dart';
import 'package:advanced_skill_exam/repositories/map_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:faker/faker.dart';

class MapRepository implements IMapRepository {
  @override
  Future<List<ClusterItem<MarkerModel>>> getMapMarkersList(GeoPoint topLeft,
      GeoPoint topright, GeoPoint bottomLeft, GeoPoint bottomRight) async {
    List<MarkerModel> fetchMarkers = [];
    List<ClusterItem<MarkerModel>> loadedMarkers = [];

    var snapshot = await FirebaseFirestore.instance
        .collection("markers")
        .where('location', isLessThanOrEqualTo: topLeft)
        .where('location', isGreaterThanOrEqualTo: bottomLeft)
        // .where('location', isGreaterThanOrEqualTo: bottomLeft)
        // .where('location', isLessThanOrEqualTo: bottomRight)
        .get();

    snapshot.docs.map((DocumentSnapshot doc) {
      return fetchMarkers.add(MarkerModel.fromSnapshot(doc));
    }).toList();

    for (int i = 0; i < fetchMarkers.length; i++) {
      if (fetchMarkers[i].lat >= bottomLeft.latitude &&
          fetchMarkers[i].lat >= bottomRight.latitude &&
          fetchMarkers[i].long >= bottomLeft.longitude &&
          fetchMarkers[i].long <= bottomRight.longitude) {
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
    }

    fetchMarkers.clear();

    return loadedMarkers;
  }

  final random = Random();
  double nextDouble(num min, num max) =>
      min + random.nextDouble() * (max - min);

  @override
  Future<void> setMarkers() async {
    for (int i = 0; i < 2500; i++) {
      double lat = nextDouble(51.3, 53.2);
      double long = nextDouble(4.1, 6.6);

      Map<String, dynamic> data = {
        "company": faker.company.name(),
        "info": faker.lorem.sentence(),
        "url": faker.image.image(width: 1200, height: 900),
        "name": faker.person.name(),
        "email": faker.internet.email(),
        "code": faker.currency.code(),
        'isClosed': faker.randomGenerator.boolean(),
        'location': GeoPoint(lat, long),
        'lat': lat,
        'long': long,
      };

      await FirebaseFirestore.instance
          .collection("markers")
          .doc()
          .set(data)
          .catchError((e) {});
    }
  }

  @override
  Future<void> setMarkerAsUser(MarkerModel marker) async {
    Map<String, dynamic> data = {
      "company": marker.company,
      "info": marker.info,
      "email": marker.email,
      "code": marker.code,
      "favorite_id": marker.id,
      "url": marker.url,
      "name": marker.name,
      'location': marker.location,
      'lat': marker.lat,
      'long': marker.long,
      'isClosed': marker.isClosed,
      'datetime': DateTime.now()
    };

    await FirebaseFirestore.instance
        .collection("markers")
        .doc()
        .set(data)
        .catchError((e) {});
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

  @override
  Future<void> addMarkerInfo(String userId, MarkerModel marker) async {
    Map<String, dynamic> data = {
      "company": marker.company,
      "info": marker.info,
      "email": marker.email,
      "code": marker.code,
      "favorite_id": marker.id,
      "url": marker.url,
      "name": marker.name,
      'location': marker.location,
      'lat': marker.lat,
      'long': marker.long,
      'isClosed': marker.isClosed,
      'datetime': DateTime.now()
    };

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("favorite")
        .doc()
        .set(data)
        .catchError((e) {});
  }

  @override
  Future<List<MarkerModel>> getFavoriteListOnce(userId) async {
    var snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("favorite")
        .orderBy('datetime', descending: false)
        .get();

    return snapshot.docs.map((DocumentSnapshot doc) {
      return (MarkerModel.fromSnapshot(doc));
    }).toList();
  }
}
