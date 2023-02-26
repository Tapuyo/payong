import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class InitProvider with ChangeNotifier{
  bool refresh = false;
  Position? position;

  bool get isRefresh => refresh;

  Position? get myPosition => position;

  void setPosition(Position? value){
    position = value;
    notifyListeners();
  }

 void billRefresh() {
    refresh = !refresh;
    notifyListeners();
  }
}