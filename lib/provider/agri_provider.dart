import 'package:flutter/foundation.dart';
import 'package:payong/models/agri_advisory_model.dart';
import 'package:payong/models/agri_forecast_model.dart';
import 'package:payong/models/agri_model.dart';

class AgriProvider with ChangeNotifier{
  AgriModel? daily;
  String dailyID = '';
  bool refresh = false;
  DateTime selectedDate = DateTime.now();
  List<AgriForecastModel> agriForecastModel = [];

  List<AgriAdvModel> agriAdvModel = [];

  DateTime  get dateSelect => selectedDate; 

  bool  get isRefresh => refresh; 

  String  get dailyIDSelected => dailyID; 

  AgriModel?  get dailyDetails => daily; 

  List<AgriForecastModel>?  get agriForecastModels => agriForecastModel; 

  List<AgriAdvModel>?  get agriAdvModels => agriAdvModel; 

  void setAdvisory(List<AgriAdvModel> value) {
    agriAdvModel = value;
    notifyListeners();
  }

  void setForecast(List<AgriForecastModel> value) {
    agriForecastModel = value;
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