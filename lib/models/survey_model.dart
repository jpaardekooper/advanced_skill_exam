import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyModel {
  SurveyModel({this.id, this.category, this.title}) : reference = null;

  final String id;
  final String category;
  final String title;

  final DocumentReference reference;

  SurveyModel.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        category = snapshot.data()['category'],
        title = snapshot.data()['title'],
        reference = snapshot.reference;
}
