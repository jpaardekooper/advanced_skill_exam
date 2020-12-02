import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    this.keyboardType,
    this.textcontroller,
    this.errorMessage,
    this.validator,
    this.secureText,
    this.passwordChecker,
    this.suffixText,
    this.hintText,
  });

  final TextInputType keyboardType;
  final TextEditingController textcontroller;
  final String errorMessage;
  final int validator;
  final bool secureText;
  final String passwordChecker;
  final String suffixText;
  final String hintText;

  inputDecoration(BuildContext context) {
    return InputDecoration(
      filled: true,
      suffixIcon: validator == 6
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                suffixText ?? "",
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
      hintText: hintText ?? "",
      contentPadding: const EdgeInsets.all(8),
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
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
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        obscureText: secureText,
        textInputAction: TextInputAction.next,
        controller: textcontroller,
        keyboardType: keyboardType,
        maxLines: secureText ? 1 : 5,
        minLines: 1,
        autofocus: false,
        decoration: inputDecoration(context),
        //return value if theres an value otherwise reutrn error
        // mssge
        validator: (val) {
          switch (validator) {
            case 1:
              return val.isEmpty ? errorMessage : null;
              break;
            case 2:
              return validateEmail(val) ? null : "Enter correct email";
              break;
            case 3:
              return val != passwordChecker
                  ? "wachtwoord komt niet overeen"
                  : null;
              break;
            case 4:
              return val.isEmpty
                  ? textcontroller.text =
                      "https://firebasestorage.googleapis.com/v0/b/lifestyle-screening.appspot.com/o/placeholder.png?alt=media&token=53ff4c6b-f415-4f9d-8144-e1895112062f"
                  : null;
              break;
            case 5:
              return null;
              break;
            case 6:
              if (double.tryParse(val) != null) {
                return null;
              } else {
                return 'Vul een geldig getal in';
              }

              break;
            default:
          }
          return val.isEmpty ? errorMessage : null;
        },
      ),
    );
  }
}
