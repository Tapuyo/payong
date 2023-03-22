import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:payong/models/agri_advisory_model.dart';
import 'package:payong/models/agri_forecast_model.dart';
import 'package:payong/models/agri_model.dart';
import 'package:payong/provider/agri_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

abstract class AgriServices {
  static Future<void> getAgriSypnosis(
      BuildContext context) async {
    final response = await http.get(Uri.parse(
        'http://203.177.82.125:8081/payong_app/API/agri_daily.php'));
    var jsondata = json.decode(response.body);

    List<AgriModel> newDailyList = [];

    for (var u in jsondata) {
      AgriModel daily = AgriModel(
          u['AgriDailyID'] ?? '',
          u['DateIssue'] ?? '',
          u['ValidityDate'] ?? '',
          u['Title'] ?? '',
          u['Content'] ?? '');
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setDailyDetails(newDailyList.first);
    dailyProvider.setDailyId(newDailyList.first.agriDailyID);
  }


  static Future<void> getAgriForecast(
      BuildContext context, String id) async {
    final response = await http.get(Uri.parse(
        'http://203.177.82.125:8081/payong_app/API/agri_daily_details.php?AgriDailyID=$id'));
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
          windContidionLocation
          
          );
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setForecast(newDailyList);
  }


  static Future<void> getAgriAdvisory(
      BuildContext context, String id) async {
    final response = await http.get(Uri.parse(
        'http://203.177.82.125:8081/payong_app/API/agri_daily_advisory.php'));
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

 
}
