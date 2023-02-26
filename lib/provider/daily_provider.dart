import 'package:flutter/foundation.dart';
import 'package:payong/models/daily_model.dart';

class DailyProvider with ChangeNotifier{
  List<DailyModel> dailyList = [];
  DailyModel? daily;
  String dailyID = '';
  bool refresh = false;
  DateTime selectedDate = DateTime.now();

  DateTime  get dateSelect => selectedDate; 

  bool  get isRefresh => refresh; 

  String  get dailyIDSelected => dailyID; 

  DailyModel?  get dailyDetails => daily; 

  List<DailyModel> get myDailyList => dailyList;

  void setDailyList(List<DailyModel> dailyListValue) {
    dailyList = dailyListValue;
    notifyListeners();
  }

  void setDailyId(String value) {
    dailyID = value;
    notifyListeners();
  }

  void setDailyDetails(DailyModel value) {
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