import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:payong/models/agri_10_prognosis.dart';
import 'package:payong/models/daily_10_model.dart';
import 'package:payong/models/daily_10_search_model.dart';
import 'package:payong/models/region_search_model.dart';

class Daily10Provider with ChangeNotifier{
  List<DailyModel10> dailyList = [];
  DailyModel10? daily;
  String dailyID = '';
  bool refresh = false;
  DateTime selectedDate = DateTime.now();
  String _searchString = '';
  bool _showList = false;
  List<RegionSearchModel> _regList = [];

   List<RegionSearchModel>  get regList => _regList; 
  

  List<Daily10SearchModel> _daily10Search = [];

  List<Daily10SearchModel> get daily10Search => _daily10Search;


  DateTime  get dateSelect => selectedDate; 

  bool  get isRefresh => refresh; 

  bool  get showList => _showList; 

  String  get dailyIDSelected => dailyID; 

  String  get searchString => _searchString; 

  String _municity = '';
  
  String  get municity => _municity; 

  void setMuniName(String value){
    _municity = value;
    notifyListeners();
  }

  

  DailyModel10?  get dailyDetails => daily; 

  List<DailyModel10> get myDailyList => dailyList;

  Set<Polygon> polygon = {};

  Set<Polygon>?  get polygons => polygon; 


 

  void setRegionList(List<RegionSearchModel> value) {
    _regList = value;
    notifyListeners();
  }

  void setPolygonDaiy(Polygon value) {
    // polygon = value;
    polygon.add(value);
    notifyListeners();
  }

  void removePolygonDaiy(PolygonId value) {
    // polygon = value;
    polygon.removeWhere((element) => element.fillColor == Colors.blueAccent);
    notifyListeners();
  }

   void setPolygonDaiyClear() {
    // polygon = value;
    polygon.clear();
    notifyListeners();
  }

  void setShowList(bool value) {
    _showList = value;
    notifyListeners();
  }

  void setSearchString(String value) {
    _searchString = value;
    notifyListeners();
  }

  void setDaily10Search(List<Daily10SearchModel> value) {
    _daily10Search = value;
    notifyListeners();
  }

  void setDailyList(List<DailyModel10> dailyListValue) {
    dailyList = dailyListValue;
    notifyListeners();
  }

  void setDailyId(String value) {
    dailyID = value;
    notifyListeners();
  }

  void setDailyDetails(DailyModel10? value) {
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