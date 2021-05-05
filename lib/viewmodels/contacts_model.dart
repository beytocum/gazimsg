import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:gazimsg/core/locator.dart';
import 'package:gazimsg/core/services/chats_service.dart';
import 'package:gazimsg/models/profile.dart';
import 'package:gazimsg/screens/converstaion_page.dart';
import 'package:gazimsg/viewmodels/base_model.dart';

class ContactsModel extends BaseModel {
  final ChatService _chatService = getIt<ChatService> ();

  Future<List<Profile>> getContacts(String query) async {
    var contacts = await _chatService.getContacts();

    var filteredContacts = contacts.where(
      (Profile) => Profile.userName.startsWith(query ?? ""),
    )
    .toList();

    return filteredContacts;

  }

  Future<Void>startConversation(User user, Profile profile) async {
    var conversation = await _chatService.startConversation(user, profile);

    navigatorService.navigateTo(
      ConversationPage(conversation: conversation, userId: user.uid,
      ),
      );
  }
}