import 'package:cloud_firestore/cloud_firestore.dart';

class MarkerModel {
  final String id;
  final String name;
  final bool isClosed;
  final GeoPoint location;

  const MarkerModel({this.id, this.name, this.location, this.isClosed})
      : reference = null;

  final DocumentReference reference;

  MarkerModel.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        name = snapshot.data()['name'] ?? "",
        location = snapshot.data()['location'] ?? 0.0,
        isClosed = snapshot.data()['isClosed'] ?? false,
        reference = snapshot.reference;

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return 'id: $id, Place $name (closed : $isClosed) Lat: ${location.latitude} Long: ${location.longitude}';
  }
}
