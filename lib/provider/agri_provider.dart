import 'package:flutter/foundation.dart';
import 'package:payong/models/agri_10_days_forecast.dart';
import 'package:payong/models/agri_10_prognosis.dart';
import 'package:payong/models/agri_advisory_model.dart';
import 'package:payong/models/agri_forecast_humidity_model.dart';
import 'package:payong/models/agri_forecast_leafwetness_model.dart';
import 'package:payong/models/agri_forecast_model.dart';
import 'package:payong/models/agri_forecast_temperature_model.dart';
import 'package:payong/models/agri_forecast_weather_model.dart';
import 'package:payong/models/agri_forecast_wind_model.dart';
import 'package:payong/models/agri_model.dart';
import 'package:payong/models/agri_soil_condition.dart';

class AgriProvider with ChangeNotifier {
  AgriModel? daily;
  String dailyID = '';
  bool refresh = false;
  DateTime selectedDate = DateTime.now();
  List<AgriForecastModel> agriForecastModel = [];

  int _agri10Tabs = 0;

  int get agri10Tabs => _agri10Tabs;


  List<AgriAdvModel> agriAdvModel = [];

  List<Agri10DaysForecastvModel> agri10Forecast = [];

  List<Agri10Prognosis> get progList => _progList;

  List<AgriForecastTempModel> _agriForecastTemp = [];
  List<AgriForecastWindModel> _agriForecastWind = [];
  List<AgriForecastWeatherModel> _agriForecastWeather = [];
  List<AgriForecastHumidityModel> _agriForecastHumidity = [];
  List<AgriForecastLeafWetnessModel> _agriForecastLeafWetness = [];
  List<AgriForecastSoilConditionModel> _agriForecastSoilCondition = [];
  List<Agri10Prognosis> _progList = [];
    String _progID = '1';
  String  get progID => _progID; 

  List<AgriForecastTempModel> get agriForecastTemp => _agriForecastTemp;
  List<AgriForecastWindModel> get agriForecastWind => _agriForecastWind;
  List<AgriForecastWeatherModel> get agriForecastWeather =>
      _agriForecastWeather;
  List<AgriForecastHumidityModel> get agriForecastHumidity =>
      _agriForecastHumidity;
  List<AgriForecastLeafWetnessModel> get agriForecastLeafWetness =>
      _agriForecastLeafWetness;
  List<AgriForecastSoilConditionModel> get agriForecastSoilCondition =>
      _agriForecastSoilCondition;

   void setAgri10Tab(int value) {
    _agri10Tabs = value;
    notifyListeners();
  }
  
  void setProgID(String value) {
    print(value);
    _progID = value;
    notifyListeners();
  }
  
  void setProg(List<Agri10Prognosis> value) {
    _progList = value;
    notifyListeners();
  }

  void setAgriForecastTemp(List<AgriForecastTempModel> value) {
    _agriForecastTemp = value;
    notifyListeners();
  }

  void setAgriForecastSoilCondition(
      List<AgriForecastSoilConditionModel> value) {
    _agriForecastSoilCondition = value;
    notifyListeners();
  }

  void setAgriForecastWind(List<AgriForecastWindModel> value) {
    _agriForecastWind = value;
    notifyListeners();
  }

  void setAgriForecastWeather(List<AgriForecastWeatherModel> value) {
    _agriForecastWeather = value;
    notifyListeners();
  }

  void setAgriForecastHumidity(List<AgriForecastHumidityModel> value) {
    _agriForecastHumidity = value;
    notifyListeners();
  }

  void setAgriForecastLeafwetness(List<AgriForecastLeafWetnessModel> value) {
    _agriForecastLeafWetness = value;
    notifyListeners();
  }

  DateTime get dateSelect => selectedDate;

  bool get isRefresh => refresh;

  String get dailyIDSelected => dailyID;

  AgriModel? get dailyDetails => daily;

  List<AgriForecastModel>? get agriForecastModels => agriForecastModel;

  List<AgriAdvModel>? get agriAdvModels => agriAdvModel;

  List<Agri10DaysForecastvModel>? get agri10Forecasts => agri10Forecast;

  void setAgri10Forecast(List<Agri10DaysForecastvModel> value) {
    agri10Forecast = value;
    notifyListeners();
  }

  void setAdvisory(List<AgriAdvModel> value) {
    agriAdvModel = value;
    notifyListeners();
  }

  void clearAdvisory() {
    agriAdvModel = [];
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
