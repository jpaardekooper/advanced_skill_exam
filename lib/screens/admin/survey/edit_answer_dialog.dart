import 'package:advanced_skill_exam/controllers/questionnaire_controller.dart';
import 'package:advanced_skill_exam/models/answer_model.dart';
import 'package:advanced_skill_exam/repositories/question_model.dart';
import 'package:advanced_skill_exam/widgets/forms/custom_textformfield.dart';
import 'package:flutter/material.dart';

class Formule {
  const Formule(this.id, this.text);
  final int id;
  final String text;
}

class EditAnswerDialog extends StatefulWidget {
  const EditAnswerDialog({
    @required this.surveyId,
    @required this.question,
    @required this.answer,
    @required this.insertNewAnswer,
    @required this.totalQuestion,
  });
  final String surveyId;
  final QuestionModel question;
  final AnswerModel answer;
  final bool insertNewAnswer;
  final int totalQuestion;

  @override
  _EditAnswerDialogState createState() => _EditAnswerDialogState();
}

class _EditAnswerDialogState extends State<EditAnswerDialog> {
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  final QuestionnaireController _questionnaireController =
      QuestionnaireController();
  TextEditingController nextController = TextEditingController();
  TextEditingController orderController = TextEditingController();
  TextEditingController optionController = TextEditingController();
  TextEditingController pointsController = TextEditingController();

  Formule selectedPointsCalculator;
  List<Formule> formulas = <Formule>[
    const Formule(0, 'handmatig'),
    const Formule(1, 'Gegeven antwoord x 0.5'),
    const Formule(2, 'Gegeven antwoord x 1'),
    const Formule(3, 'Gegeven antwoord x 2'),
  ];

  bool _isMultipleChoice;
  @override
  void initState() {
    super.initState();

    _isMultipleChoice = widget.answer.isMultipleChoice ?? true;
    orderController.text = (widget.answer.order ?? 0).toString();
    optionController.text = widget.answer.option ?? "";
    pointsController.text = (widget.answer.points ?? 0).toString();
    nextController.text =
        (widget.answer.next ?? widget.totalQuestion).toString();

    _isLoading = false;
  }

  Widget showQuestion(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("vraag: ${widget.question.order}"),
        Text(widget.question.question),
      ],
    );
  }

  Widget showAnswer(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: _isMultipleChoice ? Text("Optie: ") : Text("Antwoord in... "),
        ),
        SizedBox(
          width: 150,
          child: CustomTextFormField(
            keyboardType: TextInputType.text,
            textcontroller: optionController,
            errorMessage: "Geen geldige optie",
            validator: 1,
            secureText: false,
          ),
        ),
      ],
    );
  }

  Widget showOrder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text("Volgorde van het antwoord"),
        ),
        SizedBox(
          width: 50,
          child: CustomTextFormField(
            keyboardType: TextInputType.number,
            textcontroller: orderController,
            errorMessage: "Geen geldige getal",
            validator: 6,
            secureText: false,
          ),
        ),
      ],
    );
  }

  Widget showPoints(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text("Aantal punten als er gekozen is voor dit antwoord"),
        ),
        SizedBox(
          width: 50,
          child: CustomTextFormField(
            keyboardType: TextInputType.number,
            textcontroller: pointsController,
            errorMessage: "Geen geldige getal",
            validator: 6,
            secureText: false,
          ),
        ),
      ],
    );
  }

  Widget showPointsFormula(BuildContext context) {
    return DropdownButton<Formule>(
      value: selectedPointsCalculator,
      hint: Text("selecteer een formule"),
      onChanged: (Formule newValue) {
        setState(() {
          selectedPointsCalculator = newValue;
          pointsController.text = 0.toString();
        });
      },
      items: formulas.map((Formule formule) {
        return DropdownMenuItem<Formule>(
          value: formule,
          child: Text(
            formule.text,
          ),
        );
      }).toList(),
    );
  }

  void toggleType() {
    setState(() {
      _isMultipleChoice = !_isMultipleChoice;
    });
  }

  Widget showType(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text("Multiple choice")),
        Switch(
            value: _isMultipleChoice,
            onChanged: (val) {
              toggleType();
            }),
      ],
    );
  }

  Widget showGoToNextQuestion(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: Text(
                "Indien de gebruiker heeft geantwoord ga door naar vraag...")),
        SizedBox(
          width: 50,
          child: CustomTextFormField(
            keyboardType: TextInputType.number,
            textcontroller: nextController,
            errorMessage: "Geen geldige getal",
            validator: 6,
            secureText: false,
          ),
        ),
      ],
    );
  }

  Widget showEditWidgets(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showType(context),
        SizedBox(
          height: 20,
        ),
        showAnswer(context),
        SizedBox(
          height: 20,
        ),
        showGoToNextQuestion(context),
        SizedBox(
          height: 20,
        ),
        showOrder(context),
        SizedBox(
          height: 20,
        ),
        showPointsFormula(context),
        selectedPointsCalculator == formulas[0]
            ? showPoints(context)
            : Container()
      ],
    );
  }

  void saveAnswerChanges(BuildContext context) {
    if (_formKey.currentState.validate()) {
      // category,example,has_followup,next,order,question,

      Map<String, dynamic> data = {
        "next": int.parse(nextController.text),
        "option": optionController.text,
        "order": int.parse(orderController.text),
        "points": int.parse(pointsController.text),
        "isMultipleChoice": _isMultipleChoice,
        "pointsCalculator": selectedPointsCalculator.id
      };
      _questionnaireController
          .setAnswer(widget.surveyId, widget.question.id, widget.answer.id,
              data, widget.insertNewAnswer)
          .then((value) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      // title: widget.answer. ? Text("NIEUW") : Text(widget.question.id),
      content: SingleChildScrollView(
        child: _isLoading
            ? CircularProgressIndicator()
            : Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    showQuestion(context),
                    showEditWidgets(context),
                  ],
                ),
              ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () => Navigator.pop(context),
        ),
        RaisedButton(
          child: Text('Opslaan'),
          onPressed: () => saveAnswerChanges(context),
        )
      ],
    );
  }
}
