import 'package:advanced_skill_exam/models/questionnaire_model.dart';
import 'package:advanced_skill_exam/repositories/answer_model.dart';
import 'package:advanced_skill_exam/widgets/forms/custom_answerfield.dart';
import 'package:advanced_skill_exam/widgets/theme/color_theme.dart';
import 'package:flutter/material.dart';

class ScreeningSelectedAnswer extends StatefulWidget {
  ScreeningSelectedAnswer({
    Key key,
    @required this.question,
    @required this.answerList,
    @required this.addAnswer,
    @required this.textController,
    @required this.i,
  }) : super(key: key);

  // final Function(QuestionnaireModel) onTap;
  final String question;
  final List<AnswerModel> answerList;
  final TextEditingController textController;
  final int i;
  final Function(int, QuestionnaireModel, String) addAnswer;

  @override
  _ScreeningSelectedAnswerState createState() =>
      _ScreeningSelectedAnswerState();
}

class _ScreeningSelectedAnswerState extends State<ScreeningSelectedAnswer> {
  String selectedAnswer = "";
  QuestionnaireModel answered;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAnswerFormField(
          keyboardType: TextInputType.text,
          textcontroller: widget.textController,
          errorMessage: "vergeten in te vullen",
          validator: 1,
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.answerList.length,
          itemBuilder: (context, index) {
            AnswerModel _answer = widget.answerList[index];
            return RadioListTile(
              //   dense: true,
              value: _answer.option,
              groupValue: selectedAnswer,
              activeColor: ColorTheme.accentOrange,
              title: Text(_answer.option),
              onChanged: (value) {
                setState(() {
                  selectedAnswer = value;
                  widget.textController.text = value;
                });
                answered = QuestionnaireModel(
                    question: "",
                    answer: selectedAnswer,
                    points: _answer.points ?? 0);

                //          widget.onTap(answered);
                widget.addAnswer(widget.i, answered, widget.question);
              },
              selected: selectedAnswer == _answer.option,
            );
          },
        ),
      ],
    );
  }
}
