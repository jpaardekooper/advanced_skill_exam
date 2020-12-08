import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  AppUser({this.id, this.email, this.userName, this.role}) : reference = null;

  final String id;
  final String email;
  final String role;
  final String userName;

  final DocumentReference reference;

  AppUser.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        email = snapshot.data()['email'] ?? "",
        role = snapshot.data()['role'] ?? "user",
        userName = snapshot.data()['userName'] ?? "",
        reference = snapshot.reference;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      email: json['email'],
      role: json['role'],
      userName: json['userName'],
    );
  }
}
