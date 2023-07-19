import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
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
  String _mapImage = '';

  String  get mapImage => _mapImage; 

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

  void setOption(String value, bool daily, String mcao)async {
    String dt = DateFormat('yyyy-MM-dd').format(selectedDate.subtract(Duration(days: 1)));
    // dt = '2023-07-17';
   
      String urlValue = 'http://18.139.91.35/payong/API/DailyMonMap.php?fdate=$dt&option=$value';
    if(daily){
      urlValue = 'http://18.139.91.35/payong/API/DailyMonMap.php?fdate=$dt&option=$value';
    }else{
      String mo = 'January';
       if(selectedDate.month == 1){
        mo = 'January';
       }else if(DateTime.now().month == 2){
      mo = 'February';
       }else if(DateTime.now().month == 3){
      mo = 'March';
       }else if(DateTime.now().month == 4){
      mo = 'April';
       }else if(DateTime.now().month == 5){
      mo = 'May';
       }else if(DateTime.now().month == 6){
      mo = 'Jun';
       }else if(DateTime.now().month == 7){
      mo = 'July';
       }else if(DateTime.now().month == 8){
      mo = 'August';
       }else if(DateTime.now().month == 9){
      mo = 'September';
       }else if(DateTime.now().month == 10){
      mo = 'October';
       }else if(DateTime.now().month == 11){
      mo = 'November';
       }else if(DateTime.now().month == 12){
      mo = 'December';
       }
      urlValue = 'http://18.139.91.35/payong/API/MonthlyMonMap.php?fdate=$mo%20${DateTime.now().year}&option=$value&$mcao=1';
    }
  
    // print(urlValue); 
    final response = await http.get(Uri.parse(urlValue));
    var jsondata = json.decode(response.body);
    // print(jsondata);
    if(jsondata.isNotEmpty){
       _mapImage = jsondata[0]['Map'];
    }else{
      _mapImage = '';
    }
    print(_mapImage);
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