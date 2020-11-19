import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  AppUser({this.id, this.email, this.userName, this.role}) : reference = null;

  String id;
  String email;
  String role;
  String userName;

  final DocumentReference reference;

  AppUser.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        email = snapshot.data()['email'],
        role = snapshot.data()['role'],
        userName = snapshot.data()['userName'],
        reference = snapshot.reference;
}
