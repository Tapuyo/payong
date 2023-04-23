import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:payong/models/daily_model.dart';

import '../models/daily_legend_model.dart';

class DailyProvider with ChangeNotifier{
  List<DailyModel> dailyList = [];
  List<DailyLegendModel> _dailyLegend = [];
  DailyModel? daily;
  DailyModel? daily1;
  DailyModel? daily2;
  DailyModel? daily3;
  String dailyID = '';
  String _option = 'ActualRainfall';
  bool refresh = false;
  DateTime selectedDate = DateTime.now();
  Set<Polygon> polygon = {};

  DateTime  get dateSelect => selectedDate; 

  bool  get isRefresh => refresh; 

  String  get dailyIDSelected => dailyID; 

  List<DailyLegendModel> get dailyLegend => _dailyLegend;
  DailyModel?  get dailyDetails => daily; 
  DailyModel?  get dailyDetails1 => daily1; 
  DailyModel?  get dailyDetails2 => daily2; 
  DailyModel?  get dailyDetails3 => daily3; 

  Set<Polygon>?  get polygons => polygon; 

  List<DailyModel> get myDailyList => dailyList;

  String  get option => _option;

  void clearPolygon() {
    polygon = {};
    notifyListeners();
  }

  void setOption(String value) {
    _option = value;
    notifyListeners();
  }

   void setListDailyLegend(List<DailyLegendModel> value) {
    _dailyLegend = value;
    notifyListeners();
  }


  void setPolygonDaiy(Polygon value) {
    // polygon = value;
    polygon.add(value);
    notifyListeners();
  }

  void setPolygonDaiyClear() {
    // polygon = value;
    polygon.clear();
    notifyListeners();
  }

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