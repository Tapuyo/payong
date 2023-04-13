import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:payong/models/agri_10_days_forecast.dart';
import 'package:payong/models/agri_advisory_model.dart';
import 'package:payong/models/agri_forecast_humidity_model.dart';
import 'package:payong/models/agri_forecast_leafwetness_model.dart';
import 'package:payong/models/agri_forecast_model.dart';
import 'package:payong/models/agri_forecast_temperature_model.dart';
import 'package:payong/models/agri_forecast_weather_model.dart';
import 'package:payong/models/agri_forecast_wind_model.dart';
import 'package:payong/models/agri_model.dart';
import 'package:payong/provider/agri_provider.dart';
import 'package:payong/utils/strings.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

abstract class AgriServices {
  static Future<void> getAgriSypnosis(BuildContext context) async {
    final response = await http.get(Uri.parse(parentAgri));
    var jsondata = json.decode(response.body);

    List<AgriModel> newDailyList = [];

    for (var u in jsondata) {
      AgriModel daily = AgriModel(u['AgriDailyID'] ?? '', u['DateIssue'] ?? '',
          u['ValidityDate'] ?? '', u['Title'] ?? '', u['Content'] ?? '');
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setDailyDetails(newDailyList.first);
    dailyProvider.setDailyId(newDailyList.first.agriDailyID);
  }

  static Future<void> getAgriForecast(BuildContext context, String id) async {
    final responseParent = await http.get(Uri.parse(
        'http://18.139.91.35/payong/API/agri_daily.php'));
    var jsondataParent = json.decode(responseParent.body);
    String agriID = '';
    for (var u in jsondataParent) {
      agriID = u['AgriInfoID'];
    }

    final response = await http.get(Uri.parse(
        'http://203.177.82.125:8081/payong_app/API/agri_daily_details.php?AgriDailyID=$agriID'));
    var jsondata = json.decode(response.body);

    List<AgriForecastModel> newDailyList = [];

    for (var u in jsondata) {
      List<String> humidityLocation = [];
      for (var humid in u['HumidityLocation']) {
        humidityLocation.add(humid['Provinces']);
      }

      List<String> leafWetnessLocation = [];
      for (var leaf in u['LeafWetnessLocation']) {
        leafWetnessLocation.add(leaf['Provinces']);
      }

      List<String> tempLocation = [];
      for (var temp in u['TempLocation']) {
        tempLocation.add(temp['Provinces']);
      }

      List<String> windContidionLocation = [];
      for (var wind in u['WindContidionLocation']) {
        windContidionLocation.add(wind['Regions']);
      }
      AgriForecastModel daily = AgriForecastModel(
          u['AgriDailyID'] ?? '',
          u['MinHumidity'] ?? '',
          u['MaxHumidity'] ?? '',
          humidityLocation,
          u['MinLeafWetness'] ?? '',
          u['MaxLeafWetness'] ?? '',
          leafWetnessLocation,
          u['LowLandcMinTemp'] ?? '',
          u['LowLandcMaxTemp'] ?? '',
          u['HighLandMinTemp'] ?? '',
          u['HighLandMaxTemp'] ?? '',
          tempLocation,
          u['WindCondition'] ?? '',
          windContidionLocation);
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setForecast(newDailyList);
  }

  static Future<void> getAgriAdvisory(
      BuildContext context, String id, bool daily) async {
     final responseParent = await http.get(Uri.parse(
        'http://18.139.91.35/payong/API/agri_info.php'));
    var jsondataParent = json.decode(responseParent.body);
  
    String agriID = jsondataParent[0]['AgriInfoID'];
    var response;
    if (daily) {
      print('Agri  daily');
      response = await http.get(
          Uri.parse('http://18.139.91.35/payong/API/agri_daily_advisory.php'));
    } else {
      print('Agri 10  days');
      print('http://18.139.91.35/payong/API/agri_advisory.php?AgriInfoID=$agriID');
      response = await http.get(Uri.parse(
          'http://18.139.91.35/payong/API/agri_advisory.php?AgriInfoID=$agriID'));
    }

    var jsondata = json.decode(response.body);

    List<AgriAdvModel> newDailyList = [];

    for (var u in jsondata) {
      AgriAdvModel daily = AgriAdvModel(
        u['Title'] ?? '',
        u['Content'] ?? '',
      );
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setAdvisory(newDailyList);
  }

  static Future<void> getAgri10Days(
    BuildContext context,
    String id,
  ) async {
    final responseParent = await http.get(Uri.parse(
        'http://18.139.91.35/payong/API/agri_info.php'));
    var jsondataParent = json.decode(responseParent.body);
  
    String agriID = jsondataParent[0]['AgriInfoID'];
    
    final response = await http.get(Uri.parse(
        'http://18.139.91.35/payong/API/agri_FORECAST.php?AgriInfoID=$agriID'));

    var jsondata = json.decode(response.body);

    List<Agri10DaysForecastvModel> newDailyList = [];

    for (var u in jsondata) {
      Agri10DaysForecastvModel daily = Agri10DaysForecastvModel(
        u['Title'] ?? '',
        u['Content'] ?? '',
      );
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setAgri10Forecast(newDailyList);
  }

  static Future<void> getForecastTemp(
    BuildContext context,
  ) async {
      final responseParent = await http.get(Uri.parse(
        'http://18.139.91.35/payong/API/agri_daily.php'));
    var jsondataParent = json.decode(responseParent.body);
  
    String agriID = jsondataParent[0]['AgriDailyID'];
    print('$agriForecastTempApi$agriID&option=Temperature');
    final response = await http.get(Uri.parse('$agriForecastTempApi$agriID&option=Temperature'));

    var jsondata = json.decode(response.body);

    List<AgriForecastTempModel> newDailyList = [];

    for (var u in jsondata) {
      print('asdasdasdasd');
      AgriForecastTempModel daily = AgriForecastTempModel(
        u['LowLandMinTemp'] ?? '',
        u['LowLandMaxTemp'] ?? '',
        u['HighLandMinTemp'] ?? '',
        u['HighLandMaxTemp'] ?? '',
        u['Locations'] ?? '',
      );
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setAgriForecastTemp(newDailyList);
  }

  static Future<void> getForecastWind(
    BuildContext context,
  ) async {
      final responseParent = await http.get(Uri.parse(
        'http://18.139.91.35/payong/API/agri_daily.php'));
    var jsondataParent = json.decode(responseParent.body);
  
    String agriID = jsondataParent[0]['AgriDailyID'];
    final response = await http.get(Uri.parse('$agriForecastWindApi$agriID&option=WindCondition'));

    var jsondata = json.decode(response.body);

    List<AgriForecastWindModel> newDailyList = [];

    for (var u in jsondata) {
      AgriForecastWindModel daily = AgriForecastWindModel(
        u['WindCondition'] ?? '',
        u['Locations'] ?? '',
      );
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setAgriForecastWind(newDailyList);
  }

  static Future<void> getForecastWeather(
    BuildContext context,
  ) async {
      final responseParent = await http.get(Uri.parse(
        'http://18.139.91.35/payong/API/agri_daily.php'));
    var jsondataParent = json.decode(responseParent.body);
  
    String agriID = jsondataParent[0]['AgriDailyID'];
    final response = await http.get(Uri.parse('$agriForecastWeatherApi$agriID&option=WeatherCondition'));

    var jsondata = json.decode(response.body);

    List<AgriForecastWeatherModel> newDailyList = [];

    for (var u in jsondata) {
      AgriForecastWeatherModel daily = AgriForecastWeatherModel(
        u['WeatherCondition'] ?? '',
        u['Locations'] ?? '',
      );
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setAgriForecastWeather(newDailyList);
  }

  static Future<void> getForecastHumidity(
    BuildContext context,
  ) async {
     final responseParent = await http.get(Uri.parse(
        'http://18.139.91.35/payong/API/agri_daily.php'));
    var jsondataParent = json.decode(responseParent.body);
  
    String agriID = jsondataParent[0]['AgriDailyID'];
    final response = await http.get(Uri.parse('$agriForecastHumidityApi$agriID&option=Humidity'));

    var jsondata = json.decode(response.body);

    List<AgriForecastHumidityModel> newDailyList = [];

    for (var u in jsondata) {
      AgriForecastHumidityModel daily = AgriForecastHumidityModel(
        u['MinHumidity'] ?? '',
        u['MaxHumidity'] ?? '',
        u['Locations'] ?? '',
      );
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setAgriForecastHumidity(newDailyList);
  }

  static Future<void> getForecastLeafwetness(
    BuildContext context,
  ) async {
      final responseParent = await http.get(Uri.parse(
        'http://18.139.91.35/payong/API/agri_daily.php'));
    var jsondataParent = json.decode(responseParent.body);
  
    String agriID = jsondataParent[0]['AgriDailyID'];
    final response = await http.get(Uri.parse('$agriForecastLeafWetnessApi$agriID&option=LeafWetness'));

    var jsondata = json.decode(response.body);

    List<AgriForecastLeafWetnessModel> newDailyList = [];

    for (var u in jsondata) {
      AgriForecastLeafWetnessModel daily = AgriForecastLeafWetnessModel(
        u['MinLeafWetness'] ?? '',
        u['MaxLeafWetness'] ?? '',
        u['Locations'] ?? '',
      );
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setAgriForecastLeafwetness(newDailyList);
  }
}
