import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//setting data when a dropdown menu item is selected
typedef void StringCallback(String val);

// ignore: must_be_immutable
class SelectCategory extends StatelessWidget {
  SelectCategory({this.selectedCategory, this.callBack});
  String selectedCategory;

  final StringCallback callBack;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("categories").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Text("Er zijn geen categoriën gevonden");
        return DropdownButton(
          hint: Text(
            "Categorieën lijst",
            style: TextStyle(fontSize: 14),
          ),
          icon: Icon(
            Icons.arrow_downward,
          ),
          iconSize: 24,
          elevation: 16,
          onChanged: (value) {
            selectedCategory = value['category'];
            callBack(value['category']);
          },
          items: [
            for (var child in snapshot.data.docs)
              DropdownMenuItem(
                child: Text(
                  child['category'],
                ),
                value: child,
              ),
          ],
        );
      },
    );
  }
}
