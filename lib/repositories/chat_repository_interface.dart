import 'package:advanced_skill_exam/models/admin_model.dart';
import 'package:advanced_skill_exam/models/message_model.dart';
import 'package:advanced_skill_exam/models/user_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IChatRepository {
  Future<List<UserMessageModel>> getUserChatRef(
      String email, String expert_email);

  Stream<QuerySnapshot> streamUserChat(String ref);

  Stream<QuerySnapshot> streamAdminChat(String userId);

  Stream<QuerySnapshot> streamUserMessage(String email);

  List<UserMessageModel> getUserMessageList(QuerySnapshot snapshot);

  List<MessageModel> getMessageList(QuerySnapshot snapshot);

  Future<List<AdminModel>> getExperts();

  Future<void> sendMessageData(
      String email, Map chatMessage, String expert_email, String id);

  Future<void> sendMessageDataAsAdmin(String id, Map chatMessage);

  Future<void> closeChat(String id);
}
