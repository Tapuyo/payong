import 'package:flutter/foundation.dart';
import 'package:payong/models/daily_10_model.dart';

class Daily10Provider with ChangeNotifier{
  List<DailyModel10> dailyList = [];
  DailyModel10? daily;
  String dailyID = '';
  bool refresh = false;
  DateTime selectedDate = DateTime.now();

  DateTime  get dateSelect => selectedDate; 

  bool  get isRefresh => refresh; 

  String  get dailyIDSelected => dailyID; 

  DailyModel10?  get dailyDetails => daily; 

  List<DailyModel10> get myDailyList => dailyList;

  void setDailyList(List<DailyModel10> dailyListValue) {
    dailyList = dailyListValue;
    notifyListeners();
  }

  void setDailyId(String value) {
    dailyID = value;
    notifyListeners();
  }

  void setDailyDetails(DailyModel10 value) {
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