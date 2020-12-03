import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  MessageModel({this.id, this.description, this.sender, this.timestamp})
      : reference = null;

  final String id;
  final String description;
  final bool sender;
  final Timestamp timestamp;

  final DocumentReference reference;

  MessageModel.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        description = snapshot.data()['description'],
        sender = snapshot.data()['sender'],
        timestamp = snapshot.data()['timestamp'],
        reference = snapshot.reference;
}
