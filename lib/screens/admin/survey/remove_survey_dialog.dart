import 'package:advanced_skill_exam/controllers/survey_controller.dart';
import 'package:advanced_skill_exam/models/survey_model.dart';
import 'package:flutter/material.dart';

class RemoveSurvey extends StatelessWidget {
  RemoveSurvey({this.survey});
  final SurveyModel survey;

  final SurveyController _surveyController = SurveyController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text("Waarschuwing", style: TextStyle(color: Colors.red)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("id: " + survey.id, style: TextStyle(color: Colors.white)),
          Text("Titel: " + survey.title, style: TextStyle(color: Colors.white)),
          SizedBox(
            height: 10,
          ),
          Text("Druk op opslaan om door te gaan met verwijderen ",
              style: TextStyle(color: Colors.white)),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () => Navigator.pop(context, null),
        ),
        RaisedButton(
          child: Text('Opslaan'),
          onPressed: () => _surveyController
              .removeSurvey(survey.id)
              .then((value) => Navigator.of(context).pop()),
        )
      ],
    );
  }
}
