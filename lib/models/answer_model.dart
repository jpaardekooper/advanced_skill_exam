import 'package:cloud_firestore/cloud_firestore.dart';

class AnswerModel {
  AnswerModel(
      {this.id,
      this.next,
      this.option,
      this.order,
      this.isMultipleChoice,
      this.points,
      this.pointsCalculator})
      : reference = null;
  final String id;
  final int next;
  final String option;
  final int order;
  final bool isMultipleChoice;
  final int points;
  final int pointsCalculator;

  final DocumentReference reference;

  AnswerModel.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        next = snapshot.data()['next'],
        option = snapshot.data()['option'],
        order = snapshot.data()['order'],
        isMultipleChoice = snapshot.data()['isMultipleChoice'],
        points = snapshot.data()['points'],
        pointsCalculator = snapshot.data()['pointsCalculator'],
        reference = snapshot.reference;
}
