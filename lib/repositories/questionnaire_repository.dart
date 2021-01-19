import 'package:advanced_skill_exam/models/category_model.dart';
import 'package:advanced_skill_exam/models/answer_model.dart';
import 'package:advanced_skill_exam/repositories/question_model.dart';
import 'package:advanced_skill_exam/repositories/questionainre_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuestionnaireRepository implements IQuestionnaireRepository {
  @override
  Future<List<QuestionModel>> getDTDQuestion() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("surveys")
        .doc('T9W4kwyCioP6o7bQ6g3J')
        .collection("questions")
        .orderBy('order', descending: false)
        //    .where('order', isEqualTo: questionOrder)
        //  .limit(1)
        .get();

    return snapshot.docs.map((DocumentSnapshot doc) {
      return QuestionModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Future<List<QuestionModel>> getScreeningQuestion(String category) async {
    List<QuestionModel> screeningList = [];

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("surveys")
        .doc('T9W4kwyCioP6o7bQ6g3J')
        .collection("questions")
        .where("category", isEqualTo: category)
        .get();

    snapshot.docs.map((DocumentSnapshot doc) {
      return screeningList.add(QuestionModel.fromSnapshot(doc));
    }).toList();

    screeningList.sort((a, b) => a.order.compareTo(b.order));

    return screeningList;
  }

  @override
  Future<List<CategoryModel>> fetchCategories() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("categories")
        .orderBy('order', descending: false)
        .get();

    return snapshot.docs.map((DocumentSnapshot doc) {
      return CategoryModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Future<List<AnswerModel>> getAnswer(String id) async {
    List<AnswerModel> _answerList = [];

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("surveys")
        .doc('T9W4kwyCioP6o7bQ6g3J')
        .collection("questions")
        .doc(id)
        .collection('answers')
        .orderBy('order', descending: false)
        .get();

    snapshot.docs.map((DocumentSnapshot doc) {
      _answerList.add(AnswerModel.fromSnapshot(doc));
    }).toList();

    return _answerList;
  }

  @override
  Stream<QuerySnapshot> streamQuestions(String id) {
    return FirebaseFirestore.instance
        .collection('surveys')
        .doc(id)
        .collection('questions')
        .orderBy('order', descending: false)
        .snapshots();
  }

  @override
  List<QuestionModel> fetchQuestions(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      return QuestionModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Stream<QuerySnapshot> streamAnswers(String id, String questionId) {
    return FirebaseFirestore.instance
        .collection('surveys')
        .doc(id)
        .collection('questions')
        .doc(questionId)
        .collection('answers')
        .orderBy('order', descending: false)
        .snapshots();
  }

  @override
  List<AnswerModel> fetchAnswers(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs.map((DocumentSnapshot doc) {
      return AnswerModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Future<void> setQuestion(
      String parentId, String id, Map data, bool newQuestion) async {
    if (newQuestion) {
      await FirebaseFirestore.instance
          .collection("surveys")
          .doc(parentId)
          .collection("questions")
          .doc()
          .set(data)
          .catchError((e) {});
    } else {
      await FirebaseFirestore.instance
          .collection("surveys")
          .doc(parentId)
          .collection("questions")
          .doc(id)
          .set(data)
          .catchError((e) {});
    }
  }

  @override
  Future<void> removeQuestion(String surveyId, String questionId) async {
    await FirebaseFirestore.instance
        .collection("surveys")
        .doc(surveyId)
        .collection('questions')
        .doc(questionId)
        .delete()
        .catchError((e) {
      //    print(e);
    });
  }

  @override
  Future<void> setAnswer(String surveyId, String questionId, String answerId,
      Map data, bool insertNewAnswer) async {
    if (insertNewAnswer) {
      await FirebaseFirestore.instance
          .collection("surveys")
          .doc(surveyId)
          .collection("questions")
          .doc(questionId)
          .collection('answers')
          .doc()
          .set(data)
          .catchError((e) {
        //    print(e);
      });
    } else {
      await FirebaseFirestore.instance
          .collection("surveys")
          .doc(surveyId)
          .collection("questions")
          .doc(questionId)
          .collection('answers')
          .doc(answerId)
          .set(data)
          .catchError((e) {
        //   print(e);
      });
    }
  }

  @override
  Future<void> removeAnswerFromQuestion(
      String surveyId, String questionId, String answerId) async {
    await FirebaseFirestore.instance
        .collection("surveys")
        .doc(surveyId)
        .collection('questions')
        .doc(questionId)
        .collection('answers')
        .doc(answerId)
        .delete()
        .catchError((e) {
      //    print(e);
    });
  }
}
