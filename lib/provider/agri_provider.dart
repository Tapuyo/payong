import 'package:flutter/foundation.dart';
import 'package:payong/models/agri_model.dart';

class AgriProvider with ChangeNotifier{
  List<AgriModel> dailyList = [];
  AgriModel? daily;
  String dailyID = '';
  bool refresh = false;
  DateTime selectedDate = DateTime.now();

  DateTime  get dateSelect => selectedDate; 

  bool  get isRefresh => refresh; 

  String  get dailyIDSelected => dailyID; 

  AgriModel?  get dailyDetails => daily; 

  List<AgriModel> get myDailyList => dailyList;

  void setDailyList(List<AgriModel> dailyListValue) {
    dailyList = dailyListValue;
    notifyListeners();
  }

  void setDailyId(String value) {
    dailyID = value;
    notifyListeners();
  }

  void setDailyDetails(AgriModel value) {
    daily = value;
    notifyListeners();
  }

  void setRefresh(bool value) {
    refresh = value;
    notifyListeners();
  }

  void setDateSelect(DateTime value) {
    selectedDate = value;
    notifyListeners();
  }
}