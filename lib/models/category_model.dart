import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  CategoryModel({this.id, this.order, this.category}) : reference = null;

  final String id;
  final int order;
  final String category;

  final DocumentReference reference;

  CategoryModel.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        order = snapshot.data()['order'],
        category = snapshot.data()['category'],
        reference = snapshot.reference;
}
