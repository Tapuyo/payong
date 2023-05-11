import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payong/models/daily_10_map.dart';
import 'package:http/http.dart' as http;
import 'package:payong/models/daily_legend_model.dart';
import 'package:payong/models/mcao_assessment_model.dart';
import 'package:payong/provider/daily_provider.dart';
import 'package:provider/provider.dart';

abstract class McaoService{
  static Future<List<McaoAssessment>> getAssessment(
      BuildContext context) async {
    final response = await http
        .get(Uri.parse('http://18.139.91.35/payong/API/MonthlyMon.php?fdate=APRIL%202023&outlook=1&option=ActualRainfall'));
    var jsondata = json.decode(response.body);

    List<McaoAssessment> newDailyList = [];

    for (var u in jsondata) {
      McaoAssessment daily = McaoAssessment(
        u['ProvinceID'] ?? '',
        u['LocationDescription'] ?? '',
        u['ActualRaifall'] ?? '',
         u['Color'] ?? '',
          u['coordinates'] ?? [],
          
      );
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    return newDailyList;
  }

    static Future<void> getDailyLegend(
    BuildContext context,
  ) async {
    final dailyProvider = context.read<DailyProvider>();
    dailyProvider.setListDailyLegend([]);
    String legendUrl =
        'http://18.139.91.35/payong/API/actual_rainfall_legends.php';
    // if (dailyProvider.option == 'MinTemp') {
    //   legendUrl = 'http://18.139.91.35/payong/API/temp_legends.php';
    // } else if (dailyProvider.option == 'NormalRainfall') {
    //   legendUrl = 'http://18.139.91.35/payong/API/normal_rainfall_legends.php';
    // } else if (dailyProvider.option == 'MaxTemp') {
    //   legendUrl = 'http://18.139.91.35/payong/API/temp_legends.php';
    // } else if (dailyProvider.option == 'ActualRainfall') {
    //   legendUrl = 'http://18.139.91.35/payong/API/actual_rainfall_legends.php';
    // } else if (dailyProvider.option == 'RainfallPercent') {
    //   legendUrl = 'http://18.139.91.35/payong/API/rainpercent_legends.php';
    // } else {
    //   legendUrl = 'http://18.139.91.35/payong/API/normal_rainfall_legends.php';
    // }

    final response = await http.get(Uri.parse(legendUrl));
    var jsondata = json.decode(response.body);

    List<DailyLegendModel> dailyLegend = [];

    for (var u in jsondata) {
      String color = '';
      String title = '';
      if (dailyProvider.option == 'MinTemp') {
        color = u['color'];
        title = u['temp_from'] + '-' + u['temp_to'];
      } else if (dailyProvider.option == 'NormalRainfall') {
        color = u['color'];
        title = u['rainfall_from'] + '-' + u['rainfall_to'];
      } else if (dailyProvider.option == 'MaxTemp') {
        color = u['color'];
        title = u['temp_from'] + '-' + u['temp_to'];
      } else if (dailyProvider.option == 'ActualRainfall') {
        color = u['color'];
        title = u['arainfall_from'] + '-' + u['arainfall_to'];
      } else if (dailyProvider.option == 'RainfallPercent') {
        title = u['description'];
      } else {
        title = u['rainfall_from'] + '-' + u['rainfall_to'];
      }
      DailyLegendModel legend = DailyLegendModel(
        title,
        color,
      );
      dailyLegend.add(legend);
    }
    dailyProvider.setListDailyLegend(dailyLegend);
  }
}