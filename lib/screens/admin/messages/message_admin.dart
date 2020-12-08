import 'dart:async';

import 'package:advanced_skill_exam/controllers/chat_controller.dart';
import 'package:advanced_skill_exam/models/message_model.dart';
import 'package:advanced_skill_exam/screens/admin/messages/admin_message_tile.dart';
import 'package:advanced_skill_exam/widgets/theme/fade_transition.dart';
import 'package:advanced_skill_exam/widgets/theme/h1_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageAdmin extends StatefulWidget {
  MessageAdmin({@required this.email, this.id});

  final String email;
  final String id;

  @override
  _MessageAdminState createState() => _MessageAdminState();
}

class _MessageAdminState extends State<MessageAdmin> {
  TextEditingController messageController = TextEditingController();
  ChatController _chatController = ChatController();
  StreamSubscription<QuerySnapshot> _currentSubscription;
  List<MessageModel> messageList = <MessageModel>[];
  bool loading = true;

  @override
  void initState() {
    _currentSubscription =
        _chatController.streamAdminChat(widget.id).listen(_updateMessage);
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    _currentSubscription?.cancel();
    super.dispose();
  }

  void _updateMessage(QuerySnapshot snapshot) {
    setState(() {
      loading = false;
      messageList = _chatController.getMessageList(snapshot);
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: ListTile(
          visualDensity:
              VisualDensity(horizontal: VisualDensity.maximumDensity),
          title: H1Text(text: widget.id),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Theme.of(context).primaryColor,
          onPressed: () =>
              {FocusScope.of(context).unfocus(), Navigator.of(context).pop()},
        ),
        bottom: PreferredSize(
            child: Container(
              color: Theme.of(context).primaryColor,
              height: 4.0,
            ),
            preferredSize: Size.fromHeight(4.0)),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: false,
              padding: EdgeInsets.all(20),
              itemCount: messageList.length,
              itemBuilder: (BuildContext context, int index) {
                MessageModel message = messageList[index];
                return FadeInTransition(
                  child: AdminMessageTile(
                    message: message,
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    enableSuggestions: false,
                    autocorrect: false,
                    maxLines: 4,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    cursorColor: Theme.of(context).primaryColor,
                    controller: messageController,
                    decoration: InputDecoration(
                        hintText: "Typ uw bericht...",
                        fillColor: Colors.grey[400],
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[500], width: 1.0),
                          borderRadius: BorderRadius.circular(23),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 1.0),
                          borderRadius: BorderRadius.circular(23),
                        ),
                        contentPadding: EdgeInsets.only(left: 32, right: 32)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await sendMessage();
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(40)),
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessage = {
        'description': messageController.text ?? "",
        'sender': widget.id == widget.email,
        'timestamp': DateTime.now(),
      };

      _chatController.sendMessageDataAsAdmin(widget.id, chatMessage);

      setState(() {
        messageController.clear();
      });
    }
  }
}
