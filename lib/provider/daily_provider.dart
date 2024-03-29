import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:payong/models/daily_model.dart';

import '../models/daily_legend_model.dart';

class DailyProvider with ChangeNotifier {
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
  String _dateFromBe = '';

  String get dateFromBe => _dateFromBe;

  String get mapImage => _mapImage;

  DateTime get dateSelect => selectedDate;

  bool get isRefresh => refresh;

  String get dailyIDSelected => dailyID;

  List<DailyLegendModel> get dailyLegend => _dailyLegend;
  DailyModel? get dailyDetails => daily;
  DailyModel? get dailyDetails1 => daily1;
  DailyModel? get dailyDetails2 => daily2;
  DailyModel? get dailyDetails3 => daily3;

  Set<Polygon>? get polygons => polygon;

  List<DailyModel> get myDailyList => dailyList;

  String get option => _option;

  void clearPolygon() {
    polygon = {};
    notifyListeners();
  }

    void setDateBE(String value) {
    DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(value);
    _dateFromBe = value;
    selectedDate = tempDate;
    notifyListeners();
  }

  void setOption(String value, bool daily, String mcao) async {


    String dt = DateFormat('yyyy-MM-dd')
        .format(selectedDate.subtract(Duration(days: 1)));
    // dt = '2023-07-17';
    String url = '';
    if (value == 'MinTemp') {
      url = 'http://18.139.91.35/payong/api/datecheck_dailymon.php?dtype=4';
    } else if (value == 'NormalRainfall') {
      url = 'http://18.139.91.35/payong/api/datecheck_dailymon.php?dtype=1';
    } else if (value == 'MaxTemp') {
      url = 'http://18.139.91.35/payong/api/datecheck_dailymon.php?dtype=5';
    } else if (value == 'ActualRainfall') {
      url = 'http://18.139.91.35/payong/api/datecheck_dailymon.php?dtype=2';
    } else if (value == 'RainfallPercent') {
      url = 'http://18.139.91.35/payong/api/datecheck_dailymon.php?dtype=3';
    } else {
      url = 'http://18.139.91.35/payong/api/datecheck_dailymon.php?dtype=2';
    }
    print('landlksldkajslkdj $url');
    String dtx = DateFormat('yyyy-MM-dd').format(DateTime.now());
   final res = await http.get(Uri.parse(url));
     var jsond = json.decode(res.body);
    String dateSelect = '';
      if (jsond.isNotEmpty) {
        dateSelect = jsond[0]['CurrentDate'];
        print(dateSelect);
      } else {
        dateSelect = dt;
      }

    print(dateSelect);
    
    setDateBE(dateSelect);

    String urlValue =
        'http://18.139.91.35/payong/API/DailyMonMap.php?fdate=$dateSelect&option=$value';
    if (daily) {
      urlValue =
          'http://18.139.91.35/payong/API/DailyMonMap.php?fdate=${_dateFromBe}&option=$value';
    } else {
       String mo = 'January';
       int yr = DateTime.now().year;
      if (mcao == 'assessment') {
        if (selectedDate.month == 2) {
          mo = 'January';
        } else if (DateTime.now().month == 3) {
          mo = 'February';
        } else if (DateTime.now().month == 4) {
          mo = 'March';
        } else if (DateTime.now().month == 5) {
          mo = 'April';
        } else if (DateTime.now().month == 6) {
          mo = 'May';
        } else if (DateTime.now().month == 7) {
          mo = 'June';
        } else if (DateTime.now().month == 8) {
          mo = 'July';
        } else if (DateTime.now().month == 9) {
          mo = 'August';
        } else if (DateTime.now().month == 10) {
          mo = 'September';
        } else if (DateTime.now().month == 11) {
          mo = 'October';
        } else if (DateTime.now().month == 12) {
          mo = 'November';
        } else if (DateTime.now().month == 1) {
          mo = 'December';
          yr = DateTime.now().year - 1;
        }
      } else {
       
        if (selectedDate.month == 1) {
          mo = 'January';
        } else if (DateTime.now().month == 2) {
          mo = 'February';
        } else if (DateTime.now().month == 3) {
          mo = 'March';
        } else if (DateTime.now().month == 4) {
          mo = 'April';
        } else if (DateTime.now().month == 5) {
          mo = 'May';
        } else if (DateTime.now().month == 6) {
          mo = 'June';
        } else if (DateTime.now().month == 7) {
          mo = 'July';
        } else if (DateTime.now().month == 8) {
          mo = 'August';
        } else if (DateTime.now().month == 9) {
          mo = 'September';
        } else if (DateTime.now().month == 10) {
          mo = 'October';
        } else if (DateTime.now().month == 11) {
          mo = 'November';
        } else if (DateTime.now().month == 12) {
          mo = 'December';
        }
      }
      urlValue =
          'http://18.139.91.35/payong/API/MonthlyMonMap.php?fdate=$mo%20$yr&option=$value&$mcao=1';
      print(urlValue);
    }

    // print(urlValue);
    final response = await http.get(Uri.parse(urlValue));
    var jsondata = json.decode(response.body);
    // print(jsondata);
    if (jsondata.isNotEmpty) {
      _mapImage = jsondata[0]['Map'];
    } else {
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
