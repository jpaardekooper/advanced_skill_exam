import 'package:advanced_skill_exam/models/survey_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ISurveyRepository {
  Stream<QuerySnapshot> streamSurveys();

  List<SurveyModel> getSurveyList(QuerySnapshot snapshot);

  Future<void> updateSurvey(String id, Map data, bool newItem);

  Future<void> removeSurvey(String id);

  Future<void> addSurveyData(String userId, Map data);
}
