import 'package:advanced_skill_exam/models/survey_model.dart';
import 'package:advanced_skill_exam/repositories/map_repository.dart';
import 'package:advanced_skill_exam/repositories/map_repository_interface.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class MapController {
  final IMapRepository _surveyRepository = MapRepository();

  List<SurveyModel> getSurveyList(QuerySnapshot snapshot) {
    return _surveyRepository.getSurveyList(snapshot);
  }

  Future<void> updateSurvey(String id, Map data, bool newItem) {
    return _surveyRepository.updateSurvey(id, data, newItem);
  }

  Future<void> removeSurvey(String id) {
    return _surveyRepository.removeSurvey(id);
  }
}
