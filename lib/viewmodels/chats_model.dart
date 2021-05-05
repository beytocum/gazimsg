import 'package:gazimsg/core/services/chats_service.dart';
import 'package:gazimsg/models/conversation.dart';
import 'package:gazimsg/viewmodels/base_model.dart';
import 'package:get_it/get_it.dart';

class ChatsModel extends BaseModel {
  final ChatService _db = GetIt.instance<ChatService>();

  Stream<List<Conversation>> conversations(String userId) {
    return _db.getConversations(userId);
  }
}