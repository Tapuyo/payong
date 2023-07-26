import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:payong/models/daily_10_map.dart';
import 'package:http/http.dart' as http;
import 'package:payong/models/daily_legend_model.dart';
import 'package:payong/models/mcao_assessment_model.dart';
import 'package:payong/models/mcao_detals_model.dart';
import 'package:payong/provider/daily_provider.dart';
import 'package:payong/provider/mcao_provider.dart';
import 'package:provider/provider.dart';

abstract class McaoService {
  static Future<List<McaoAssessment>> getAssessment(
      BuildContext context, String page) async {
    final response = await http
        .get(Uri.parse('http://18.139.91.35/payong/API/provinces.php'));
    var jsondata = json.decode(response.body);

    List<McaoAssessment> newDailyList = [];

    for (var u in jsondata) {
      McaoAssessment daily = McaoAssessment(
        u['ProvinceID'] ?? '',
        u['ProvinceDescription'] ?? '',
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

  static getDetails(BuildContext contextx, String id, String option, int mCaoTab,DateTime selectedDate) async {
               String mo = 'January';
       if(selectedDate.month == 1){
        mo = 'January';
       }else if(selectedDate.month == 2){
      mo = 'February';
       }else if(selectedDate.month == 3){
      mo = 'March';
       }else if(selectedDate.month == 4){
      mo = 'April';
       }else if(selectedDate.month == 5){
      mo = 'May';
       }else if(selectedDate.month == 6){
      mo = 'June';
       }else if(selectedDate.month == 7){
      mo = 'July';
       }else if(selectedDate.month == 8){
      mo = 'August';
       }else if(selectedDate.month == 9){
      mo = 'September';
       }else if(selectedDate.month == 10){
      mo = 'October';
       }else if(selectedDate.month == 11){
      mo = 'November';
       }else if(selectedDate.month == 12){
      mo = 'December';
       }
      final response;
    if (mCaoTab == 0) {
      print(
          'http://18.139.91.35/payong/API/MonthlyMon.php?fdate=$mo%20${DateTime.now().year}&assessment=1&option=$option&province_id=$id');
       response = await http.get(Uri.parse(
          'http://18.139.91.35/payong/API/MonthlyMon.php?fdate=$mo%20${DateTime.now().year}&assessment=1&option=$option&province_id=$id'));
  
    } else {
      print(
          'http://18.139.91.35/payong/API/MonthlyMon.php?fdate=$mo%20${DateTime.now().year}&outlook=1&option=$option&province_id=$id');
       response = await http.get(Uri.parse(
          'http://18.139.91.35/payong/API/MonthlyMon.php?fdate=$mo%20${DateTime.now().year}&outlook=1&option=$option&province_id=$id'));
      
    }
    var jsondata = json.decode(response.body);

    List<McaoDetailsModel> mcaoDetails = [];
  print(option);
    for (var u in jsondata) {
      McaoDetailsModel daily = McaoDetailsModel(u['ProvinceID'] ?? '',
          u['LocationDescription'] ?? '', option, double.parse(u[option]).toStringAsFixed(2));

      mcaoDetails.add(daily);
    }
    contextx.read<McaoProvider>().setMcaoDetails(mcaoDetails);
  }
}
