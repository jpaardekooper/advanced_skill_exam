import 'package:advanced_skill_exam/controllers/questionnaire_controller.dart';
import 'package:advanced_skill_exam/repositories/question_model.dart';
import 'package:advanced_skill_exam/screens/admin/survey/select_category.dart';
import 'package:advanced_skill_exam/widgets/forms/custom_textformfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditQuestionDialog extends StatefulWidget {
  const EditQuestionDialog(
      {@required this.parentId,
      @required this.question,
      this.newQuestion,
      this.totalQuestion});
  final String parentId;
  final QuestionModel question;
  final bool newQuestion;
  final int totalQuestion;

  @override
  _EditQuestionDialogState createState() => _EditQuestionDialogState();
}

class _EditQuestionDialogState extends State<EditQuestionDialog> {
  //Question: category,example,has_followup,next,order,question,
  String _selectedCategory = "";
  TextEditingController orderController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  final QuestionnaireController _questionnaireController =
      QuestionnaireController();

  @override
  void initState() {
    super.initState();
    //if its a new question set all parameters to empty
    orderController.text =
        (widget.question.order ?? widget.totalQuestion).toString();
    questionController.text = widget.question.question ?? "";
    _selectedCategory = widget.question.category ?? "";

    _isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
    orderController.dispose();
    questionController.dispose();
  }

  Widget showOrder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Vraag volgorde"),
        CustomTextFormField(
          keyboardType: TextInputType.number,
          textcontroller: orderController,
          errorMessage: "Geen geldige titel",
          validator: 6,
          secureText: false,
        )
      ],
    );
  }

  set string(String value) => setState(() => _selectedCategory = value);

  Widget showCategories(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SelectCategory(
          selectedCategory: _selectedCategory,
          callBack: (val) => setState(() => _selectedCategory = val),
        ),
        Flexible(
            child: Text(
          _selectedCategory,
          textDirection: TextDirection.rtl,
        )),
      ],
    );
  }

  Widget showQuestion(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Vraagstelling: "),
        CustomTextFormField(
          keyboardType: TextInputType.multiline,
          textcontroller: questionController,
          errorMessage: "Geen geldige vraag",
          validator: 1,
          secureText: false,
        )
      ],
    );
  }

  void saveQuestionChanges(BuildContext context) {
    if (_formKey.currentState.validate()) {
      // category,example,has_followup,next,order,question,
      Map<String, dynamic> data = {
        "category": _selectedCategory,
        "order": int.parse(orderController.text),
        "question": questionController.text,
      };
      _questionnaireController
          .setQuestion(
              widget.parentId, widget.question.id, data, widget.newQuestion)
          .then((value) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: widget.newQuestion ? Text("NIEUW") : Text(widget.question.id),
      content: SingleChildScrollView(
        child: _isLoading
            ? CircularProgressIndicator()
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    showQuestion(context),
                    showOrder(context),
                    showCategories(context),
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
            onPressed: () => saveQuestionChanges(context))
      ],
    );
  }
}
