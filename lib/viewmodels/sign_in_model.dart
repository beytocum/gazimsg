import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gazimsg/core/locator.dart';
import 'package:gazimsg/core/services/auth_service.dart';
import 'package:gazimsg/gazi_main.dart';
import 'package:gazimsg/viewmodels/base_model.dart';

class SignInModel extends BaseModel {
  final AuthService _authService = getIt<AuthService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User get currentUser => _authService.currentUser;
 

  Future<void> signIn(String userName) async {
    if (userName.isEmpty) return;
   

    busy = true;
    try {
    var user = await _authService.signIn();

    await _firestore.collection('profile').doc(user.uid).set({
      'userName': userName, 'image': 'https://seeklogo.com/images/G/gazi-universitesi-1926-logo-16D7B23404-seeklogo.com.png'});
    
    await navigatorService.navigateAndReplace(GaziMain());
    } catch (e) {
      busy = false;
    }

    busy = false;

  }
}