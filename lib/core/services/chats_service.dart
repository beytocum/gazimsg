import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gazimsg/models/conversation.dart';
import 'package:gazimsg/models/profile.dart';
import 'package:rxdart/rxdart.dart';

class ChatService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<Conversation>> getConversations(String userId) {
    var ref = _firestore
    .collection('conversations')
    .where('members', arrayContains: userId);
    
    var conversationsStream = ref.snapshots();

    var profilesStreams = getContacts().asStream();

    return Rx.combineLatest2(
      conversationsStream, 
      profilesStreams, 
      (QuerySnapshot conversations, List<Profile> profiles) => conversations.docs
      .map(
        (snapshot) {
          List<String> members = List.from(snapshot['members']);

          var profile = profiles.firstWhere((element) => element.id == members.firstWhere((element) => element != userId),
          );

          return Conversation.fromSnapshot(snapshot, profile);
        }
        ).toList());

  
  }

  Future<List<Profile>> getContacts() async {
    var ref = _firestore.collection("profile");

    var documents = await ref.get();

    return documents.docs
    .map((snapshot) => Profile.fromSnapshot(snapshot))
    .toList();

  }

  Future<Conversation>startConversation(User user, Profile profile) async {
    var ref = _firestore.collection("conversations");

    var documentRef = await ref.add({
      'displayMessage': '',
      'members': [user.uid, profile.id]

    });

    return Conversation(
      id: documentRef.id,
       displayMessage: '',
       name: profile.userName,
       profileImage: profile.image,
    );
  }
}
