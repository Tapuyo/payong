import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:payong/models/daily_10_model.dart';
import 'package:payong/models/daily_10_search_model.dart';
import 'package:payong/models/mcao_detals_model.dart';
import 'package:payong/models/mcao_search_prov_model.dart';

class McaoProvider with ChangeNotifier{
  List<DailyModel10> dailyList = [];
  DailyModel10? daily;
  String dailyID = '';
  bool refresh = false;
  DateTime selectedDate = DateTime.now();
  String _searchString = '';
  bool _showList = false;
  List<McaoDetailsModel> _mcaoDetails = [];
  String _provinceID = '';

   List<McaoSearchModel> _mcaoProvList = [];


  List<McaoSearchModel>  get mcaoProvList => _mcaoProvList;

  String  get provinceID => _provinceID;

   List<McaoDetailsModel> get mcaoDetails => _mcaoDetails;

  void setMcaoSearch(List<McaoSearchModel> value) {
    _mcaoProvList = value;
    notifyListeners();
  }


   void setProvID(String provID){
    _provinceID = provID;
    print(_provinceID);
    notifyListeners();
   }

  void setMcaoDetails(List<McaoDetailsModel> value) {
    _mcaoDetails = value;
    notifyListeners();
  }


  int _mCaoTab = 0;

  int get mCaoTab => _mCaoTab;

    void setMcaoTab(int value) {
    _mCaoTab = value;
    notifyListeners();
  }

  List<Daily10SearchModel> _daily10Search = [];

  List<Daily10SearchModel> get daily10Search => _daily10Search;

  DateTime  get dateSelect => selectedDate; 

  bool  get isRefresh => refresh; 

  bool  get showList => _showList; 

  String  get dailyIDSelected => dailyID; 

  String  get searchString => _searchString; 

  DailyModel10?  get dailyDetails => daily; 

  List<DailyModel10> get myDailyList => dailyList;

  Set<Polygon> polygon = {};

  Set<Polygon>?  get polygons => polygon; 

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