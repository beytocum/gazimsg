import 'package:flutter/widgets.dart';
import 'package:gazimsg/core/locator.dart';
import 'package:gazimsg/core/services/navigator_service.dart';

abstract class BaseModel with ChangeNotifier {
   final NavigatorService navigatorService = getIt<NavigatorService>();


  bool _busy = false;

  bool get busy => _busy;

  set busy(bool state) {
    _busy = state;

    notifyListeners();
  }
}