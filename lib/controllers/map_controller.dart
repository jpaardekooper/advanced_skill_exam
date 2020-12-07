import 'package:advanced_skill_exam/models/marker_model.dart';

import 'package:advanced_skill_exam/repositories/map_repository.dart';
import 'package:advanced_skill_exam/repositories/map_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';

class GMapController {
  final IMapRepository _mapRepository = MapRepository();

  Future<List<ClusterItem<MarkerModel>>> getMapMarkerList(GeoPoint topLeft,
      GeoPoint topright, GeoPoint bottomLeft, GeoPoint bottomRight) {
    return _mapRepository.getMapMarkersList(
        topLeft, topright, bottomLeft, bottomRight);
  }

  Future<void> setMarkers() {
    return _mapRepository.setMarkers();
  }

  Future<void> updateMarker(Map data) {
    return _mapRepository.updateMarker(data);
  }

  Future<void> removeSurvey(String id) {
    return _mapRepository.removeSurvey(id);
  }

  Future<void> addMarkerInfo(String userId, MarkerModel marker) {
    return _mapRepository.addMarkerInfo(userId, marker);
  }

  Future<void> getFavoriteListOnce(String id) {
    return _mapRepository.getFavoriteListOnce(id);
  }

  Future<void> setMarkerAsUser(MarkerModel marker) {
    return _mapRepository.setMarkerAsUser(marker);
  }
}
