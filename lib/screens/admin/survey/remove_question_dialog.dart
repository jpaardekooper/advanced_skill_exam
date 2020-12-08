import 'package:advanced_skill_exam/controllers/questionnaire_controller.dart';
import 'package:advanced_skill_exam/repositories/question_model.dart';
import 'package:flutter/material.dart';

class RemoveQuestion extends StatelessWidget {
  RemoveQuestion({this.surveyId, this.question});
  final String surveyId;
  final QuestionModel question;

  final QuestionnaireController _questionnaireController =
      QuestionnaireController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Waarschuwing", style: TextStyle(color: Colors.red)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("id: " + question.id),
          Text("Titel: " + question.question),
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
          onPressed: () => _questionnaireController
              .removeQuestion(surveyId, question.id)
              .then((value) => Navigator.of(context).pop()),
        )
      ],
    );
  }
}
