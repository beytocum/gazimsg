import 'package:gazimsg/core/services/auth_service.dart';
import 'package:gazimsg/core/services/chats_service.dart';
import 'package:gazimsg/core/services/navigator_service.dart';
import 'package:gazimsg/core/services/storage_service.dart';
import 'package:gazimsg/viewmodels/chats_model.dart';
import 'package:gazimsg/viewmodels/contacts_model.dart';
import 'package:gazimsg/viewmodels/convarsation_model.dart';
import 'package:gazimsg/viewmodels/main_model.dart';
import 'package:gazimsg/viewmodels/sign_in_model.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;


setupLocators() {
  getIt.registerLazySingleton(() => NavigatorService());
  getIt.registerLazySingleton(() => ChatService());
  getIt.registerLazySingleton(() => AuthService());
  getIt.registerLazySingleton(() => StorageService());

  getIt.registerFactory(() => GaziMainModel());
  getIt.registerFactory(() => ChatsModel());
  getIt.registerFactory(() => SignInModel());
  getIt.registerFactory(() => ContactsModel());
  getIt.registerFactory(() => ConversationModel());
}