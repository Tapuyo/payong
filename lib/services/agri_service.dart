import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:payong/models/agri_model.dart';
import 'package:payong/provider/agri_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

abstract class AgriServices {
  static Future<void> getAgriList(
      BuildContext context, String date) async {
        date = '2023-02-09';
    final response = await http.get(Uri.parse(
        'http://203.177.82.125:8081/payong_app/API/daily_agri.php?fdate=$date'));
    var jsondata = json.decode(response.body);

    List<AgriModel> newDailyList = [];

    for (var u in jsondata) {
      AgriModel daily = AgriModel(
          u['ForecastAgriID'],
          u['LocationDescription'],
          u['coordinates'] ?? [],
          u['AgriDate'],
          u['Weather_Description'].toString(),
          u['Weather_Icon'],
          u['Wind'].toString(),
          u['HumidityLow'].toString(),
          u['LowTemp'].toString(),
          u['HighTemp'].toString(),
          u['RainFallFrom'],
          u['RainFallTo']);
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setDailyList(newDailyList);
  }

  static Future<void> getAgriDetails(
      BuildContext context, String dailyDetailsID,String date) async {
     final dailyProvider = context.read<AgriProvider>();
     dailyProvider.setRefresh(true);
    final response = await http.get(Uri.parse(
        'http://203.177.82.125:8081/payong_app/API/daily_agri.php?DailyAgriID=$dailyDetailsID'));
    var jsondata = json.decode(response.body);

    List<AgriModel> newDailyList = [];

    for (var u in jsondata) {
      AgriModel daily = AgriModel(
          u['ForecastAgriID'],
          u['LocationDescription'],
          u['coordinates'] ?? [],
          u['AgriDate'],
          u['Weather_Description'].toString(),
          u['Weather_Icon'],
          u['Wind'].toString(),
          u['HumidityLow'].toString(),
          u['LowTemp'].toString(),
          u['HighTemp'].toString(),
          u['RainFallFrom'],
          u['RainFallTo']);
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
   dailyProvider.setRefresh(false);
  dailyProvider.setDailyDetails(newDailyList[0]);
  }
}
