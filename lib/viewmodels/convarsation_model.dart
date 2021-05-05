import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazimsg/core/locator.dart';
import 'package:gazimsg/core/services/storage_service.dart';
import 'package:gazimsg/viewmodels/base_model.dart';
import 'package:image_picker/image_picker.dart';

class ConversationModel extends BaseModel {
  CollectionReference _ref;
  final StorageService _storageService = getIt<StorageService>();
  String mediaUrl = '';

  Stream<QuerySnapshot> getConversation(String id) {
   _ref = FirebaseFirestore.instance
     .collection('conversations/$id/messages');
     _ref.orderBy('timeStamp').snapshots();
  }

  Future<DocumentReference> add(Map<String, dynamic> data){
    mediaUrl= '';

    notifyListeners();

    return _ref.add(data);
  }

  uploadMedia(ImageSource source) async {
    var pickedFile = await ImagePicker().getImage(source: source);

    if(pickedFile == null) return;

    mediaUrl = await _storageService.uploadMedia(File(pickedFile.path));

    notifyListeners();
  }

}