import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:payong/models/system_ads_model.dart';

class InitProvider with ChangeNotifier{
  bool refresh = false;
  bool _isLoading = false;
  Position? position;
  String? locationId = '';
  List<AdsModel> _adsList = [];
  String _backImgAssetUrl = 'assets/backgroundImg/cloud.png';
  bool _withRain = false;

  bool get withRain => _withRain;

  String get backImgAssetUrl => _backImgAssetUrl;

  List<AdsModel> get adsList => _adsList;

   bool get isLoading => _isLoading;

  bool get isRefresh => refresh;

  String? get myLocationId => locationId;

  Position? get myPosition => position;

  void setBackImg(String value, bool withRain){
    _backImgAssetUrl = value;
    _withRain = withRain;
    notifyListeners();
  }

  void setAdsList(List<AdsModel> value){
    _adsList = value;
    notifyListeners();
  }

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

void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}