import 'package:cloud_firestore/cloud_firestore.dart';

class MarkerModel {
  final String id;
  final String company;
  final String info;
  final String url;
  final String name;
  final String email;
  final String code;
  final bool isClosed;
  final GeoPoint location;
  final double lat;
  final double long;
  final Timestamp time;

  const MarkerModel(
      {this.id,
      this.company,
      this.info,
      this.url,
      this.email,
      this.code,
      this.name,
      this.location,
      this.isClosed,
      this.lat,
      this.long,
      this.time})
      : reference = null;

  final DocumentReference reference;

  MarkerModel.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        company = snapshot.data()['company'] ?? "",
        info = snapshot.data()['info'] ?? "",
        url = snapshot.data()['url'] ??
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOESuwW93UpyPghmkG7tJiay7oWX38oy2ZETP9ICS4y0PcloOxHHwv0iP-aAVSS_1fayPonE7Ee9ZpyKjxihOOLc04Cg5S1OK2uw&usqp=CAU&ec=45732302",
        email = snapshot.data()['email'] ?? "",
        code = snapshot.data()['code'] ?? "",
        name = snapshot.data()['name'] ?? "",
        location = snapshot.data()['location'] ?? GeoPoint(52.0, 4.5),
        isClosed = snapshot.data()['isClosed'] ?? false,
        lat = snapshot.data()['lat'] ?? 0.0,
        long = snapshot.data()['long'] ?? 0.0,
        time = snapshot.data()['datetime'] ?? Timestamp.now(),
        reference = snapshot.reference;

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return 'id: $id, Place $name (closed : $isClosed) Lat: ${location.latitude} Long: ${location.longitude}';
  }
}
