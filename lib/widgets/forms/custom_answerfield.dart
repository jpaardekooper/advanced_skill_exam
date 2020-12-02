import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAnswerFormField extends StatelessWidget {
  const CustomAnswerFormField({
    this.keyboardType,
    this.textcontroller,
    this.errorMessage,
    this.validator,
    this.hintText,
  });

  final TextInputType keyboardType;
  final TextEditingController textcontroller;
  final String errorMessage;
  final int validator;
  final String hintText;

  inputDecoration(BuildContext context) {
    return InputDecoration(
      filled: true,
      hintText: hintText ?? "",
      contentPadding: const EdgeInsets.all(0),
      fillColor: Colors.transparent,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 1.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 2.0,
        ),
      ),
    );
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.03,
      child: TextFormField(
        enableInteractiveSelection: false,
        focusNode: FocusNode(canRequestFocus: false),
        readOnly: true,
        autofocus: false,
        textInputAction: TextInputAction.none,
        controller: textcontroller,
        keyboardType: keyboardType,
        minLines: 1,
        style: TextStyle(color: Colors.transparent),
        decoration: inputDecoration(context),
        //return value if theres an value otherwise reutrn error
        // mssge
        validator: (val) {
          switch (validator) {
            case 1:
              return val.isEmpty ? errorMessage : null;
              break;
            case 2:
              if (double.tryParse(val) != null) {
                return null;
              } else {
                return 'Vul een geldig getal in';
              }
              break;
            default:
              return val.isEmpty ? errorMessage : null;
          }
        },
      ),
    );
  }
}
