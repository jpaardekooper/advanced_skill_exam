import 'dart:async';
import 'package:advanced_skill_exam/controllers/questionnaire_controller.dart';
import 'package:advanced_skill_exam/models/survey_model.dart';
import 'package:advanced_skill_exam/models/answer_model.dart';
import 'package:advanced_skill_exam/repositories/question_model.dart';
import 'package:advanced_skill_exam/screens/admin/survey/edit_answer_dialog.dart';
import 'package:advanced_skill_exam/screens/admin/survey/edit_question_dialog.dart';
import 'package:advanced_skill_exam/screens/admin/survey/remove_question_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class QuestionView extends StatefulWidget {
  const QuestionView({@required this.surveyDetails});
  final SurveyModel surveyDetails;

  @override
  _QuestionViewState createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  final QuestionnaireController _questionnaireController =
      QuestionnaireController();

  StreamSubscription<QuerySnapshot> _currentSubscription;

  bool _isLoading = true;
  List<QuestionModel> _questionList = [];

  @override
  void initState() {
    _currentSubscription = _questionnaireController
        .streamQuestion(widget.surveyDetails.id)
        .listen(_updateQNA);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _currentSubscription?.cancel();
  }

  void _updateQNA(QuerySnapshot snapshot) {
    setState(() {
      _isLoading = false;
      _questionList = _questionnaireController.fetchQuestions(snapshot);
    });
  }

  void _addQuestion(BuildContext contect) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditQuestionDialog(
          parentId: widget.surveyDetails.id,
          question: QuestionModel(),
          newQuestion: true,
          totalQuestion: _questionList.length + 1,
        );
      },
    );
  }

  void _editQuestion(QuestionModel question) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditQuestionDialog(
          parentId: widget.surveyDetails.id,
          question: question,
          newQuestion: false,
          totalQuestion: 0,
        );
      },
    );
  }

  void _removeQuestion(QuestionModel question) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return RemoveQuestion(
          surveyId: widget.surveyDetails.id,
          question: question,
        );
      },
    );
  }

  void _addAnswer(QuestionModel question) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditAnswerDialog(
          surveyId: widget.surveyDetails.id,
          answer: AnswerModel(),
          question: question,
          insertNewAnswer: true,
          totalQuestion: _questionList.length + 1,
        );
      },
    );
  }

  void _editAnswer(QuestionModel question, AnswerModel answer) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditAnswerDialog(
          surveyId: widget.surveyDetails.id,
          answer: answer,
          question: question,
          insertNewAnswer: false,
          totalQuestion: 0,
        );
      },
    );
  }

  void _deleteAnswer(AnswerModel answer, QuestionModel question) {
    _questionnaireController.removeAnswerFromQuestion(
        widget.surveyDetails.id, question.id, answer.id);
  }

  Widget showHeaderInfo(QuestionModel question) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Vraag: ${question.order}"),
        Text("categorie: ${question.category}"),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit, size: 16),
              onPressed: () {
                _editQuestion(question);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, size: 16, color: Colors.red),
              onPressed: () {
                _removeQuestion(question);
              },
            ),
          ],
        )
      ],
    );
  }

  Widget showQuestion(QuestionModel question) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text("Vraagstelling: "),
          Text(question.question)
        ],
      ),
    );
  }

  Widget showAnswers(QuestionModel question, int index) {
    return StreamBuilder<QuerySnapshot>(
      stream: _questionnaireController.streamAnswers(
        widget.surveyDetails.id,
        question.id,
      ),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          List<AnswerModel> _answerList =
              _questionnaireController.fetchAnswers(snapshot);

          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _answerList.length,
            itemBuilder: (context, index) {
              AnswerModel answer = _answerList[index];

              if (_answerList.isEmpty) {
                return Text("Er zijn geen vragen gevonden");
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      // ignore: missing_required_param
                      child: RadioListTile(
                        dense: true,
                        value: answer.option,
                        activeColor: Colors.blue,
                        title: Text(answer.option),
                        secondary: Text(
                          answer.points.toString(),
                        ),
                        subtitle: Text(
                            "Ga door naar vraag ${answer.next.toString()}"),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            size: 18,
                          ),
                          onPressed: () {
                            _editAnswer(question, answer);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                            size: 18,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _deleteAnswer(answer, question);
                          },
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          );
        }
      },
    );
  }

  Widget showHeaderForAnswers(BuildContext context, QuestionModel question) {
    return Center(
      child: RaisedButton(
        onPressed: () {
          _addAnswer(question);
        },
        child:
            const Text('Voeg een antwoord toe', style: TextStyle(fontSize: 10)),
      ),
    );
  }

  Widget showQuestionAndAnswer(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _questionList.length,
            itemBuilder: (BuildContext ctxt, int index) {
              QuestionModel question = _questionList[index];
              if (_questionList.isEmpty) {
                return CircularProgressIndicator();
              } else {
                return Container(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, bottom: 30, top: 0),
                  child: Material(
                    elevation: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        showHeaderInfo(question),
                        showQuestion(question),
                        Divider(),
                        showHeaderForAnswers(context, question),
                        showAnswers(question, index),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surveyDetails.title),
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : _questionList.isNotEmpty
              ? showQuestionAndAnswer(context)
              : Center(
                  child: Text('Geen vragen gevonden'),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addQuestion(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
