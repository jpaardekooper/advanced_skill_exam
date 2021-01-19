import 'dart:io';

import 'package:advanced_skill_exam/controllers/map_controller.dart';
import 'package:advanced_skill_exam/models/marker_model.dart';
import 'package:advanced_skill_exam/widgets/forms/custom_textformfield.dart';
import 'package:advanced_skill_exam/widgets/theme/color_theme.dart';
import 'package:advanced_skill_exam/widgets/theme/h1_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddNewMarker extends StatefulWidget {
  AddNewMarker({Key key, @required this.onTap, @required this.viewLocation})
      : super(key: key);

  final Function(MarkerModel) onTap;
  final LatLng viewLocation;

  @override
  _AddNewMarkerState createState() => _AddNewMarkerState();
}

class _AddNewMarkerState extends State<AddNewMarker> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  TextEditingController nameController1 = TextEditingController();

  // TextEditingController nameController2 = TextEditingController();

  TextEditingController nameController3 = TextEditingController();

  TextEditingController nameController4 = TextEditingController();

  TextEditingController nameController5 = TextEditingController();

  TextEditingController firebase_controller = TextEditingController();

  bool isOpen = false;

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        _image = null;
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    nameController1.dispose();
    //   nameController2.dispose();
    nameController3.dispose();
    nameController4.dispose();
    nameController5.dispose();
    firebase_controller.dispose();

    super.dispose();
  }

  String myImgURL;
  addMarkervalidation() async {
    if (_formKey.currentState.validate()) {
      myImgURL = await uploadImage(_image);

      MarkerModel newMapMarker = MarkerModel(
        company: nameController.text,
        info: nameController1.text,
        //   url: nameController2.text,
        email: nameController3.text,
        code: nameController4.text,
        name: nameController5.text,
        location: GeoPoint(
            widget.viewLocation.latitude, widget.viewLocation.longitude),
        isClosed: isOpen,
        lat: widget.viewLocation.latitude,
        long: widget.viewLocation.longitude,
        firebase_url: myImgURL,
        time: Timestamp.now(),
      );

      await GMapController().setMarkerAsUser(newMapMarker).then((value) {
        widget.onTap(newMapMarker);
      });
    }
  }

  Future<String> uploadImage(File img) async {
    String fileName = basename(img.path);
    Reference storageRef =
        FirebaseStorage.instance.ref().child('marker_images/$fileName');
    UploadTask uploadTask = storageRef.putFile(img);
    TaskSnapshot taskSnapshot = await uploadTask;

    return taskSnapshot.ref.getDownloadURL().then((fileURL) {
      return fileURL;
    });
  }

  void autofill() {
    setState(() {
      //company
      nameController.text = faker.company.name();
      //sentence
      nameController1.text = faker.lorem.sentence();
      //image
      //   nameController2.text = faker.image.image();
      //email
      nameController3.text = faker.internet.email();
      //code
      nameController4.text = faker.currency.code();
      //name
      nameController5.text = faker.person.name();

      firebase_controller.text = faker.image.image();
      //bool
      isOpen = faker.randomGenerator.boolean();
    });
  }

  Widget showFotoUrl(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Foto:"),
        SizedBox(
          width: 20,
        ),
        RaisedButton(
          child: Text(
            "Kies een foto",
            style: TextStyle(color: Colors.white),
          ),
          color: Theme.of(context).primaryColor,
          onPressed: () => showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Kies een bron:",
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                        child: Text("Camera"),
                        onPressed: () {
                          getImage();
                          Navigator.of(context).pop();
                        }),
                    FlatButton(
                      child: Text("Gallerij"),
                      onPressed: () {
                        getImage();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Nieuwe marker'),
          OutlineButton(
            onPressed: () {
              autofill();
            },
            child: Icon(Icons.text_snippet),
          )
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Bedrijfsnaam:"),
              CustomTextFormField(
                keyboardType: TextInputType.visiblePassword,
                textcontroller: nameController,
                errorMessage: "Geen geldige Bedrijfsnaam",
                validator: 1,
                secureText: false,
                hintText: '',
              ),
              Text("Bedrijfs quote:"),
              CustomTextFormField(
                keyboardType: TextInputType.visiblePassword,
                textcontroller: nameController1,
                errorMessage: "Geen geldige Bedrijfs quote",
                validator: 1,
                secureText: false,
                hintText: '',
              ),
              Text("Foto"),
              showFotoUrl(context),
              SafeArea(
                child: _image != null
                    ? Center(
                        child: SizedBox(
                            height: 200,
                            width: 175,
                            child: FittedBox(
                                fit: BoxFit.contain,
                                child: Image.file(_image))),
                      )
                    : Container(),
              ),
              Text("Email:"),
              CustomTextFormField(
                keyboardType: TextInputType.emailAddress,
                textcontroller: nameController3,
                errorMessage: "Geen geldige email",
                validator: 1,
                secureText: false,
                hintText: 'Hiermee kunnen wij u aanspreken',
              ),
              Text("Code"),
              CustomTextFormField(
                keyboardType: TextInputType.visiblePassword,
                textcontroller: nameController4,
                errorMessage: "Geen geldige code",
                validator: 1,
                secureText: false,
                hintText: '',
              ),
              Text("Naam"),
              CustomTextFormField(
                keyboardType: TextInputType.visiblePassword,
                textcontroller: nameController5,
                errorMessage: "Geen geldige naam",
                validator: 1,
                secureText: false,
                hintText: '',
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  !isOpen ? Text("gesloten") : Text("open"),
                  CupertinoSwitch(
                    value: isOpen,
                    onChanged: (value) {
                      setState(() {
                        isOpen = value;
                      });
                    },
                  ),
                ],
              ),
              H1Text(text: "locatie"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Latitude"),
                  OutlineButton(
                    onPressed: null,
                    child: Text(widget.viewLocation.latitude.toString()),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("longitude"),
                  OutlineButton(
                    onPressed: null,
                    child: Text(widget.viewLocation.longitude.toString()),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          splashColor: ColorTheme.accentOrange,
          highlightColor: Colors.transparent,
          child: Text(
            'Annuleren',
            style: TextStyle(color: Colors.red),
          ),
        ),
        RaisedButton(
          onPressed: () => addMarkervalidation(),
          color: ColorTheme.accentOrange,
          child: Text(
            'Toevoegen',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
