import 'package:advanced_skill_exam/models/marker_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';

abstract class IMapRepository {
  Future<List<ClusterItem<MarkerModel>>> getMapMarkersList(
      GeoPoint north, GeoPoint south);

  Future<void> setMarkers();

  Future<void> updateMarker(Map data);

  Future<void> removeSurvey(String id);
}
