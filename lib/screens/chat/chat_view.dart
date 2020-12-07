import 'dart:async';

import 'package:advanced_skill_exam/controllers/chat_controller.dart';
import 'package:advanced_skill_exam/models/admin_model.dart';
import 'package:advanced_skill_exam/models/message_model.dart';
import 'package:advanced_skill_exam/models/user_message_model.dart';
import 'package:advanced_skill_exam/screens/chat/message_tile.dart';
import 'package:advanced_skill_exam/widgets/theme/fade_transition.dart';
import 'package:advanced_skill_exam/widgets/theme/h1_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {@required this.ref, @required this.model, @required this.email});
  final AdminModel model;
  final UserMessageModel ref;
  final String email;

  @override
  _ChatScreen createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> {
  ChatController _chatController = ChatController();
  final TextEditingController messageController = TextEditingController();

  StreamSubscription<QuerySnapshot> _currentSubscription;

  List<MessageModel> messageList = <MessageModel>[];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _currentSubscription =
        _chatController.streamUserChat(widget.ref.id).listen(_updateMessage);
  }

  void _updateMessage(QuerySnapshot snapshot) {
    setState(() {
      loading = false;
      messageList = _chatController.getMessageList(snapshot);
    });
  }

  @override
  void dispose() {
    _currentSubscription?.cancel();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: ListTile(
          visualDensity:
              VisualDensity(horizontal: VisualDensity.maximumDensity),
          title: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: H1Text(
              text: widget.model.name,
            ),
          ),
          subtitle: Text(
            widget.model.profession,
          ),
          leading: Transform.scale(
            scale: 1.2,
            child: CircleAvatar(
              // backgroundImage: NetworkImage(widget.model.image),
              child: Icon(Icons.person),
              backgroundColor: widget.model.medical
                  ? const Color(0xFFA1CFBE)
                  : const Color(0xFFFFDFB9),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        //    centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: widget.model.medical
              ? Theme.of(context).primaryColor
              : Theme.of(context).accentColor,
          onPressed: () =>
              {FocusScope.of(context).unfocus(), Navigator.of(context).pop()},
        ),
        bottom: PreferredSize(
            child: Container(
              color: widget.model.medical
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).accentColor,
              height: 4.0,
            ),
            preferredSize: Size.fromHeight(4.0)),
      ),
      body: loading
          ? Center(child: Text("Data wordt geladen"))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    reverse: false,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(20),
                    itemCount: messageList.length,
                    itemBuilder: (BuildContext context, int index) {
                      MessageModel message = messageList[index];
                      return FadeInTransition(
                        child: MessageTile(
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
                          cursorColor: Theme.of(context).accentColor,
                          controller: messageController,
                          decoration: InputDecoration(
                              hintText: "Typ uw bericht...",
                              fillColor: Colors.grey[400],
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey[500], width: 1.0),
                                borderRadius: BorderRadius.circular(23),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(23),
                              ),
                              contentPadding:
                                  EdgeInsets.only(left: 32, right: 32)),
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
                            color: Theme.of(context).accentColor,
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
        'sender': true,
        'timestamp': DateTime.now(),
      };

      _chatController.sendMessageData(
          widget.email, chatMessage, widget.model.expert_email, widget.ref.id);

      setState(() {
        messageController.clear();
      });
    }
  }
}
