import 'package:advanced_skill_exam/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminMessageTile extends StatefulWidget {
  AdminMessageTile({this.message});

  final MessageModel message;

  @override
  _AdminMessageTileState createState() => _AdminMessageTileState();
}

class _AdminMessageTileState extends State<AdminMessageTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
            margin: !widget.message.sender
                //true
                ? EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 3.5,
                    right: 8,
                    top: 8,
                    bottom: 8)
                //false
                : EdgeInsets.only(
                    left: 8,
                    top: 8,
                    bottom: 8,
                    right: MediaQuery.of(context).size.width / 3.5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: !widget.message.sender
                  //true
                  ? const Color(0xFFFFF4E6)
                  //false
                  : const Color(0xFFEFFAF6),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Text(
              widget.message.description,
            )),
        !widget.message.sender
            //true
            ? Container(
                padding: EdgeInsets.only(right: 16),
                child: Text(
                  DateFormat("yyy-MM-dd hh:mm")
                      .format(widget.message.timestamp.toDate()),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ))
            //false
            : Container(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  DateFormat("yyy-MM-dd hh:mm")
                      .format(widget.message.timestamp.toDate()),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
      ],
    );
  }
}
