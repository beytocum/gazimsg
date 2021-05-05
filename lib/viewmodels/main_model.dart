
import 'package:gazimsg/screens/contacts_page.dart';
import 'package:gazimsg/viewmodels/base_model.dart';

class GaziMainModel extends BaseModel {
  Future<void> navigateToContacts() {
    return navigatorService.navigateTo(ContactsPage());
  }
  
}