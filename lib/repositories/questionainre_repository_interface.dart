import 'package:advanced_skill_exam/models/category_model.dart';
import 'package:advanced_skill_exam/repositories/answer_model.dart';
import 'package:advanced_skill_exam/repositories/question_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class IQuestionnaireRepository {
  //user functions

  //get question for user for DTD test
  Future<List<QuestionModel>> getDTDQuestion();

  //get question for user for Screening test
  Future<List<QuestionModel>> getScreeningQuestion(String category);

  Future<List<CategoryModel>> fetchCategories();

  //get options for question
  Future<List<AnswerModel>> getAnswer(String questionId);

  //admin functions
  Stream<QuerySnapshot> streamQuestions(String id);

  List<QuestionModel> fetchQuestions(QuerySnapshot snapshot);

  Stream<QuerySnapshot> streamAnswers(String id, String questionId);

  List<AnswerModel> fetchAnswers(AsyncSnapshot<QuerySnapshot> snapshot);

//add
  Future<void> setQuestion(
      String surveyId, String questionId, Map data, bool _newQuestion);
//delete question
  Future<void> removeQuestion(String surveyId, String questionId);
// add answer
  Future<void> setAnswer(String surveyID, String questionId, String answerId,
      Map data, bool insertNewAnswer);
//delete answer
  Future<void> removeAnswerFromQuestion(
      String surveyId, String questionId, String answerId);
}
