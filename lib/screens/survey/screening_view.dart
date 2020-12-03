import 'package:advanced_skill_exam/controllers/questionnaire_controller.dart';
import 'package:advanced_skill_exam/models/category_model.dart';
import 'package:advanced_skill_exam/models/questionnaire_model.dart';
import 'package:advanced_skill_exam/screens/survey/fetch_question_and_answer_view.dart';
import 'package:advanced_skill_exam/widgets/button/confirm_orange_button.dart';
import 'package:advanced_skill_exam/widgets/inherited/inherited_timer_service.dart';
import 'package:flutter/material.dart';

class ScreeningView extends StatefulWidget {
  ScreeningView({Key key}) : super(key: key);

  @override
  _ScreeningViewState createState() => _ScreeningViewState();
}

class _ScreeningViewState extends State<ScreeningView> {
  int nextQuestionInQue;

  double progressIndicator;

  double valueforQuestion;

  List<TextEditingController> _textControllerList;

  final QuestionnaireController _questionnaireController =
      QuestionnaireController();

  List<CategoryModel> _categoryList;

  final _formKey = GlobalKey<FormState>();

  int indexValue;

  int screeningDuration;

  final timerService = TimerService();

  @override
  void initState() {
    nextQuestionInQue = 1;

    valueforQuestion = 0.0;

    _textControllerList = [];

    _categoryList = [];

    indexValue = 0;
    super.initState();
  }

  @override
  void dispose() {
    _textControllerList.clear();
    super.dispose();
  }

  void nextQuestion() {
    for (int i = 0; i < _textControllerList.length; i++) {
      //   print(_textControllerList[i].text);
    }

    if (_formKey.currentState.validate()) {
      screeningDuration = timerService.currentDuration.inSeconds;
      //   print("HET HEEFT ${timerService.currentDuration.inSeconds} geduurd");

      timerService.reset();
      setState(() {
        progressIndicator = valueforQuestion + 1;
        indexValue += 1;
      });

      //add data to databse soon;;;;

      _textControllerList.clear();
    }
  }

  void addAnswerToList(String question, String answer, int points) {
    // print(question + " " + answer + " " + points.toString());
  }

  Widget showNextQuestionButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ConfirmOrangeButton(
        text: "Volgende",
        onTap: nextQuestion,
      ),
    );
  }

//question loading side
  void addController() {
    _textControllerList.add(TextEditingController());
  }

//check radio button with current list tile
  void addAnswer(int index, QuestionnaireModel userAnswer) {
    // print(index);
    _textControllerList.elementAt(index).text = userAnswer.answer;
  }

  @override
  Widget build(BuildContext context) {
    timerService.start();
    return TimerServiceProvider(
      service: timerService,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "HealthPoint Screening",
            style: TextStyle(fontSize: 14),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<List<CategoryModel>>(
          //fetching data from the corresponding questionId
          future: _questionnaireController.fetchCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return Center(
                child: CircularProgressIndicator(),
              );
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              _categoryList = snapshot.data;
              valueforQuestion = 1.0 / _categoryList.length.toDouble();

              if (indexValue > _categoryList.length - 1) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Bedankt voor uw deelname"),
                      ConfirmOrangeButton(
                        text: "Terug",
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                );
              }
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ScreeningQnaView(
                        addController: addController,
                        addAnswer: addAnswer,
                        value: progressIndicator ?? valueforQuestion,
                        category: _categoryList[indexValue].category,
                      ),
                      AnimatedBuilder(
                        animation: timerService, // listen to ChangeNotifier
                        builder: (context, child) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Elapsed: ${timerService.currentDuration}'),
                            ],
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: showNextQuestionButton(),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
