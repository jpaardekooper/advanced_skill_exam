import 'package:advanced_skill_exam/models/marker_model.dart';

import 'package:advanced_skill_exam/repositories/map_repository.dart';
import 'package:advanced_skill_exam/repositories/map_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';

class GMapController {
  final IMapRepository _mapRepository = MapRepository();

  Future<List<ClusterItem<MarkerModel>>> getMapMarkerList(
      GeoPoint north, GeoPoint south) {
    return _mapRepository.getMapMarkersList(north, south);
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
}
