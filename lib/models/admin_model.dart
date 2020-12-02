import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  AdminModel(
      {this.id,
      this.expert_email,
      this.image,
      this.medical,
      this.name,
      this.profession})
      : reference = null;

  final String id;
  final String expert_email;
  final String image;
  final bool medical;
  final String name;
  final String profession;

  final DocumentReference reference;

  AdminModel.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        expert_email = snapshot.data()['email'],
        image = snapshot.data()['image'] ?? "",
        medical = snapshot.data()['medical'] ?? false,
        name = snapshot.data()['userName'],
        profession = snapshot.data()['profession'],
        reference = snapshot.reference;
}
