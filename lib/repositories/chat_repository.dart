import 'package:advanced_skill_exam/models/admin_model.dart';
import 'package:advanced_skill_exam/models/message_model.dart';
import 'package:advanced_skill_exam/models/user_message_model.dart';
import 'package:advanced_skill_exam/repositories/chat_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository extends IChatRepository {
  //fetching data with the future builder
  @override
  Future<List<UserMessageModel>> getUserChatRef(
      String email, String expert_email) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('messages')
        .where('ref', isEqualTo: email + "_" + expert_email)
        .get();

    return snapshot.docs.map((DocumentSnapshot doc) {
      return UserMessageModel.fromSnapshot(doc);
    }).toList();
  }

//streaming data with the corresponding ref
  @override
  Stream<QuerySnapshot> streamUserChat(String ref) {
    return FirebaseFirestore.instance
        .collection('messages')
        .doc(ref)
        .collection('user_message')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot> streamAdminChat(String userId) {
    return FirebaseFirestore.instance
        .collection("messages")
        .doc(userId)
        .collection("user_message")
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot> streamUserMessage(String email) {
    return FirebaseFirestore.instance
        .collection("messages")
        // .where({"ref", "!=", "closed"})
        .snapshots();
  }

  @override
  List<UserMessageModel> getUserMessageList(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      return UserMessageModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  List<MessageModel> getMessageList(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      return MessageModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Future<List<AdminModel>> getExperts() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'admin')
        .get();

    return snapshot.docs.map((DocumentSnapshot doc) {
      return AdminModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Future<void> sendMessageData(
      String email, Map chatMessage, String expert_email, String id) async {
    if (id == null || id.isEmpty) {
      await FirebaseFirestore.instance
          .collection("messages")
          .add({
            'open': true,
            'expert': expert_email,
            'ref': email + "_" + expert_email,
          })
          .catchError((e) {})
          .then((value) async {
            await FirebaseFirestore.instance
                .collection("messages")
                .doc(value.id)
                .collection("user_message")
                .doc()
                .set(chatMessage)
                .catchError((e) {
              //    print(e);
            });
          });
    } else {
      await FirebaseFirestore.instance.collection("messages").doc(id).update({
        'open': true,
      }).catchError((e) {});

      await FirebaseFirestore.instance
          .collection("messages")
          .doc(id)
          .collection("user_message")
          .doc()
          .set(chatMessage)
          .catchError((e) {
        //    print(e);
      });
    }
  }

  @override
  Future<void> sendMessageDataAsAdmin(String id, Map chatMessage) async {
    await FirebaseFirestore.instance
        .collection("messages")
        .doc(id)
        .collection("user_message")
        .doc()
        .set(chatMessage)
        .catchError((e) {
      //    print(e);
    });

    await FirebaseFirestore.instance.collection("messages").doc(id).update({
      'open': false,
    }).catchError((e) {
      //    print(e);
    });
  }

  @override
  Future<void> closeChat(String id) async {
    await FirebaseFirestore.instance.collection("messages").doc(id).update({
      'ref': 'closed',
    }).catchError((e) {
      //    print(e);
    });
  }
}
