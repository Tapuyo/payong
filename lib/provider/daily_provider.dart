import 'package:flutter/foundation.dart';
import 'package:payong/models/daily_model.dart';

class DailyProvider with ChangeNotifier{
  List<DailyModel> dailyList = [];
  DailyModel? daily;
  DailyModel? daily1;
  DailyModel? daily2;
  DailyModel? daily3;
  String dailyID = '';
  bool refresh = false;
  DateTime selectedDate = DateTime.now();

  DateTime  get dateSelect => selectedDate; 

  bool  get isRefresh => refresh; 

  String  get dailyIDSelected => dailyID; 

  DailyModel?  get dailyDetails => daily; 
  DailyModel?  get dailyDetails1 => daily1; 
  DailyModel?  get dailyDetails2 => daily2; 
  DailyModel?  get dailyDetails3 => daily3; 

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
  void setDailyDetails1(DailyModel value) {
    daily1 = value;
    notifyListeners();
  }
  void setDailyDetails2(DailyModel value) {
    daily2 = value;
    notifyListeners();
  }
  void setDailyDetails3(DailyModel value) {
    daily3 = value;
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