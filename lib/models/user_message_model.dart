import 'package:cloud_firestore/cloud_firestore.dart';

class UserMessageModel {
  UserMessageModel({this.id, this.expert, this.open, this.ref})
      : reference = null;

  final String id;
  final String expert;
  final bool open;
  final String ref;

  final DocumentReference reference;

  UserMessageModel.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        expert = snapshot.data()['expert'] ?? "",
        open = snapshot.data()['open'] ?? false,
        ref = snapshot.data()['ref'] ?? "",
        reference = snapshot.reference;
}
