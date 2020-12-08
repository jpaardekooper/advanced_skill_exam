import 'dart:async';

import 'package:advanced_skill_exam/controllers/chat_controller.dart';
import 'package:advanced_skill_exam/models/user_message_model.dart';
import 'package:advanced_skill_exam/screens/admin/messages/message_admin.dart';
import 'package:advanced_skill_exam/widgets/theme/fade_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageOverView extends StatefulWidget {
  MessageOverView({this.userEmail});
  final userEmail;

  @override
  _MessageOverViewState createState() => _MessageOverViewState();
}

class _MessageOverViewState extends State<MessageOverView> {
  ChatController _chatController = ChatController();
  StreamSubscription<QuerySnapshot> _currentSubscription;
  List<UserMessageModel> messageList = <UserMessageModel>[];
  bool loading = true;

  @override
  void initState() {
    _currentSubscription = _chatController
        .streamUserMessage(widget.userEmail)
        .listen(_updateMessage);
    super.initState();
  }

  @override
  void dispose() {
    _currentSubscription?.cancel();
    super.dispose();
  }

  void _updateMessage(QuerySnapshot snapshot) {
    setState(() {
      loading = false;
      messageList = _chatController.getUserMessageList(snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: false,
      padding: EdgeInsets.all(20),
      itemCount: messageList.length,
      itemBuilder: (BuildContext context, int index) {
        UserMessageModel message = messageList[index];
        return FadeInTransition(
          child: MessageCard(
            messageModel: message,
          ),
        );
      },
    );
  }
}

class MessageCard extends StatelessWidget {
  MessageCard({this.messageModel});
  final UserMessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFA1CFBE),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MessageAdmin(email: messageModel.expert, id: messageModel.id),
            ),
          );
        },
        child: ListTile(
          leading: Icon(
            Icons.question_answer,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(messageModel.id),
          subtitle: Text(messageModel.expert),
          trailing: Material(
            color: Colors.transparent,
            child: SizedBox(
              height: 45,
              width: 45,
              child: InkWell(
                customBorder: CircleBorder(),
                highlightColor: Colors.white,
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
