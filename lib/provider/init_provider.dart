import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class InitProvider with ChangeNotifier{
  bool refresh = false;
  Position? position;
  String? locationId = '';

  bool get isRefresh => refresh;

  String? get myLocationId => locationId;

  Position? get myPosition => position;

  void setPosition(Position? value){
    position = value;
    notifyListeners();
  }

// 15.487981027192175, 121.00402491524594
  void setLocationId(String? value){
    locationId = value;
    notifyListeners();
  }

 void billRefresh() {
    refresh = !refresh;
    notifyListeners();
  }
}