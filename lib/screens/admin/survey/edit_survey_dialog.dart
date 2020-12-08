import 'package:advanced_skill_exam/controllers/survey_controller.dart';
import 'package:advanced_skill_exam/models/survey_model.dart';
import 'package:advanced_skill_exam/screens/admin/survey/select_category.dart';
import 'package:advanced_skill_exam/widgets/forms/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class EditSurveyView extends StatefulWidget {
  EditSurveyView({this.surveyInfo, this.newItem});
  final SurveyModel surveyInfo;
  final bool newItem;

  @override
  _EditSurveyViewState createState() => _EditSurveyViewState();
}

class _EditSurveyViewState extends State<EditSurveyView> {
  final SurveyController _surveyController = SurveyController();
  TextEditingController _surveyNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _selectedCategory;

  void initState() {
    super.initState();
    _selectedCategory = widget.surveyInfo.category ?? "";
    _surveyNameController.text = widget.surveyInfo.title ?? "";
  }

  Widget showTitle(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          child: Text(
            "Titel:",
          ),
        ),
        Flexible(
          child: CustomTextFormField(
            keyboardType: TextInputType.name,
            textcontroller: _surveyNameController,
            errorMessage: "Geen geldige titel",
            validator: 1,
            secureText: false,
          ),
        ),
      ],
    );
  }

  set string(String value) => setState(() => _selectedCategory = value);

  Widget showCategories(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: SelectCategory(
            selectedCategory: _selectedCategory,
            callBack: (val) => setState(() => _selectedCategory = val),
          ),
        ),
        Flexible(child: Text(_selectedCategory)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.newItem
          ? Text("Nieuwe survey")
          : Text(
              "ID: ${widget.surveyInfo.id}",
              style: TextStyle(fontSize: 11),
            ),
      content: Container(
        width: math.min(MediaQuery.of(context).size.width, 1200),
        height: math.min(MediaQuery.of(context).size.height, 400),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                showTitle(context),
                SizedBox(
                  height: 25,
                ),
                showCategories(context),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () => Navigator.pop(context, null),
        ),
        RaisedButton(
            child: Text('Opslaan'), onPressed: () => saveSurveyChanges(context))
      ],
    );
  }

  void saveSurveyChanges(BuildContext context) {
    if (_formKey.currentState.validate()) {
      Map<String, String> data = {
        "title": _surveyNameController.text,
        "category": _selectedCategory,
      };

      _surveyController
          .updateSurvey(widget.surveyInfo.id, data, widget.newItem)
          .then((value) => Navigator.pop(context));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _surveyNameController.dispose();
  }
}
