import 'package:advanced_skill_exam/controllers/questionnaire_controller.dart';
import 'package:advanced_skill_exam/models/questionnaire_model.dart';
import 'package:advanced_skill_exam/models/answer_model.dart';
import 'package:advanced_skill_exam/repositories/question_model.dart';
import 'package:advanced_skill_exam/screens/survey/screening_selected_answer.dart';
import 'package:advanced_skill_exam/widgets/theme/color_theme.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ScreeningQnaView extends StatelessWidget {
  ScreeningQnaView({
    Key key,
    @required this.addAnswer,
    @required this.addController,
    @required this.value,
    @required this.category,
  }) : super(key: key);

  final VoidCallback addController;

  final double value;

  final String category;

  final Function(int, QuestionnaireModel, String) addAnswer;

  final QuestionnaireController _questionnaireController =
      QuestionnaireController();

  List<QuestionModel> _questionList = [];

  List<TextEditingController> textControllerList = [];

  Widget showAnsers(QuestionModel question, int i) {
    return FutureBuilder<List<AnswerModel>>(
      //fetching data from the corresponding questionId
      future: _questionnaireController.fetchAnswer(question.id),
      builder: (context, snapshot) {
        List<AnswerModel> _answerList = snapshot.data;
        if (_answerList == null || _answerList.isEmpty) {
          return Container();
        } else {
          return ScreeningSelectedAnswer(
            //    question: question.question,
            question: question.question,
            addAnswer: addAnswer,
            answerList: _answerList,
            textController: textControllerList[i],
            i: i,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation<Color>(
            ColorTheme.accentOrange,
          ),
          minHeight: 5,
        ),
        FutureBuilder<List<QuestionModel>>(
          future: _questionnaireController.fetchScreeningQuestion(category),
          builder: (context, snapshot) {
            _questionList = snapshot.data;

            if (_questionList == null || _questionList.isEmpty) {
              return Center(child: CircularProgressIndicator());
            } else {
              //get the correct question from the list
              //       _questionList.sort((a, b) => a.order.compareTo(b.order));

              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _questionList.length,
                itemBuilder: (BuildContext context, index) {
                  var question = _questionList[index];
                  addController();
                  textControllerList.add(TextEditingController());

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "${question.order}. ${question.question}",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.03),
                        ),
                        showAnsers(
                          question,
                          index,
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}
