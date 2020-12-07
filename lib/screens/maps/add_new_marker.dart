import 'package:advanced_skill_exam/controllers/map_controller.dart';
import 'package:advanced_skill_exam/models/marker_model.dart';
import 'package:advanced_skill_exam/widgets/forms/custom_textformfield.dart';
import 'package:advanced_skill_exam/widgets/theme/h1_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  TextEditingController nameController2 = TextEditingController();

  TextEditingController nameController3 = TextEditingController();

  TextEditingController nameController4 = TextEditingController();

  TextEditingController nameController5 = TextEditingController();

  bool isOpen = false;

  @override
  void dispose() {
    nameController.dispose();
    nameController1.dispose();
    nameController2.dispose();
    nameController3.dispose();
    nameController4.dispose();
    nameController5.dispose();

    super.dispose();
  }

  void addMarkervalidation() {
    if (_formKey.currentState.validate()) {
      MarkerModel newMapMarker = MarkerModel(
        company: nameController.text,
        info: nameController1.text,
        url: faker.image.image(),
        email: nameController3.text,
        code: nameController4.text,
        name: nameController5.text,
        location: GeoPoint(
            widget.viewLocation.latitude, widget.viewLocation.longitude),
        isClosed: isOpen,
        lat: widget.viewLocation.latitude,
        long: widget.viewLocation.longitude,
        time: Timestamp.now(),
      );

      GMapController().setMarkerAsUser(newMapMarker).then((value) {
        widget.onTap(newMapMarker);
      });
    } else {}
  }

  void autofill() {
    setState(() {
      //company
      nameController.text = faker.company.name();
      //sentence
      nameController1.text = faker.lorem.sentence();
      //image
      nameController2.text = faker.image.image();
      //email
      nameController3.text = faker.internet.email();
      //code
      nameController4.text = faker.currency.code();
      //name
      nameController5.text = faker.person.name();
      //bool
      isOpen = faker.randomGenerator.boolean();
    });
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
                errorMessage: "Geen geldige gebruikersnaam",
                validator: 1,
                secureText: false,
                hintText: 'Hiermee kunnen wij u aanspreken',
              ),
              Text("Bedrijfs quote:"),
              CustomTextFormField(
                keyboardType: TextInputType.visiblePassword,
                textcontroller: nameController1,
                errorMessage: "Geen geldige gebruikersnaam",
                validator: 1,
                secureText: false,
                hintText: 'Hiermee kunnen wij u aanspreken',
              ),
              Text("Foto"),
              CustomTextFormField(
                keyboardType: TextInputType.visiblePassword,
                textcontroller: nameController2,
                errorMessage: "Geen geldige gebruikersnaam",
                validator: 1,
                secureText: false,
                hintText: 'Hiermee kunnen wij u aanspreken',
              ),
              Text("Email:"),
              CustomTextFormField(
                keyboardType: TextInputType.visiblePassword,
                textcontroller: nameController3,
                errorMessage: "Geen geldige gebruikersnaam",
                validator: 1,
                secureText: false,
                hintText: 'Hiermee kunnen wij u aanspreken',
              ),
              Text("Code"),
              CustomTextFormField(
                keyboardType: TextInputType.visiblePassword,
                textcontroller: nameController4,
                errorMessage: "Geen geldige gebruikersnaam",
                validator: 1,
                secureText: false,
                hintText: 'Hiermee kunnen wij u aanspreken',
              ),
              Text("Naam"),
              CustomTextFormField(
                keyboardType: TextInputType.visiblePassword,
                textcontroller: nameController5,
                errorMessage: "Geen geldige gebruikersnaam",
                validator: 1,
                secureText: false,
                hintText: 'Hiermee kunnen wij u aanspreken',
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
          splashColor: Theme.of(context).accentColor,
          highlightColor: Colors.transparent,
          child: Text(
            'annuleren',
            style: TextStyle(color: Colors.red),
          ),
        ),
        RaisedButton(
          onPressed: () => addMarkervalidation(),
          color: Theme.of(context).accentColor,
          child: Text(
            'Toevoegen',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
