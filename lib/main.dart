import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gazimsg/core/locator.dart';
import 'package:gazimsg/core/services/navigator_service.dart';
import 'package:gazimsg/gazi_main.dart';
import 'package:gazimsg/screens/sign_in_page.dart';
import 'package:gazimsg/viewmodels/sign_in_model.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

bool USE_FIRESTORE_EMULATOR = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (USE_FIRESTORE_EMULATOR) {
    FirebaseFirestore.instance.settings = const Settings(
        host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
  }
  setupLocators();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context)=>getIt<SignInModel>(),
          child: MaterialApp(
        title: 'Gazi Msg',
        navigatorKey: getIt<NavigatorService>().navigatorKey,
        theme: ThemeData(
          primaryColor: Colors.red,
          accentColor: Colors.white,
        ),
        home: Consumer<SignInModel>(
          builder: (BuildContext context,SignInModel signInModel, Widget child) =>
          signInModel.currentUser == null ? SignInPage() : GaziMain(),
      ),
    ),
    );

  }
}
