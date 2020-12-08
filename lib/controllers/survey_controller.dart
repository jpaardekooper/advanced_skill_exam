import 'package:advanced_skill_exam/models/survey_model.dart';
import 'package:advanced_skill_exam/repositories/survey_repository.dart';
import 'package:advanced_skill_exam/repositories/survey_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyController {
  final ISurveyRepository _surveyRepository = SurveyRepository();

  Stream<QuerySnapshot> streamSurveys() {
    return _surveyRepository.streamSurveys();
  }

  List<SurveyModel> getSurveyList(QuerySnapshot snapshot) {
    return _surveyRepository.getSurveyList(snapshot);
  }

  Future<void> updateSurvey(String id, Map data, bool newItem) {
    return _surveyRepository.updateSurvey(id, data, newItem);
  }

  Future<void> removeSurvey(String id) {
    return _surveyRepository.removeSurvey(id);
  }

  Future<void> addSurveyData(String userId, Map data) {
    return _surveyRepository.addSurveyData(userId, data);
  }
}
