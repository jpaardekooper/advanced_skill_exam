import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  QuestionModel({
    this.id,
    this.category,
    this.order,
    this.question,
  }) : reference = null;
  final String id;
  final String category;
  final int order;
  final String question;

  final DocumentReference reference;

  QuestionModel.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        category = snapshot.data()['category'],
        order = snapshot.data()['order'],
        question = snapshot.data()['question'],
        reference = snapshot.reference;
}
