import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:payong/models/daily_10_model.dart';
import 'package:payong/models/daily_10_search_model.dart';
import 'package:payong/provider/daily10_provider.dart';
import 'package:payong/utils/strings.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:payong/models/daily_model.dart';
import 'package:payong/provider/daily_provider.dart';

abstract class Daily10Services {
  static Future<void> getDailyList(
      BuildContext context, String selectMod, String date) async {
    // date = '2023-02-09';
    final response = await http.get(Uri.parse(
        'http://18.139.91.35/payong/API/daily_details.php?fdate=$date'));
    var jsondata = json.decode(response.body);

    List<DailyModel10> newDailyList = [];

    for (var u in jsondata) {
      DailyModel10 daily = DailyModel10(
          u['DailyDetailsID'],
          u['LocationDescription'],
          u['coordinates'] ?? [],
          u['RainFall'],
          u['RainFallColorCode'],
          u['RainFallPercentage'],
          u['RainFallPercentageColorCode'],
          u['LowTemp'].toString(),
          u['LowTempColorCode'],
          u['HighTemp'].toString(),
          u['HighTempColorCode'],
          u['RainFallDescription'],
          u['CloudCover'],
          u['Humidity'],
          u['WindSpeed'],
          u['WindDirection'],
          u['MeanTemp']);
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<Daily10Provider>();
    dailyProvider.setDailyList(newDailyList);
  }

  static Future<DailyModel10?> getDailyDetails(
      BuildContext context, String dailyDetailsID, String date) async {
    print(dailyDetailsID);
    final dailyProvider = context.read<Daily10Provider>();
    dailyProvider.setRefresh(true);
    date = '2023-03-16';
    // dailyDetailsID = '1';
    final response = await http.get(Uri.parse('$days10Details fdate=$date&location=$dailyDetailsID'));
    // http://18.139.91.35/payong/API/daily_details.php?fdate=2023-03-16&location=12

    // if (response.statusCode == 201 || response.statusCode == 200) {
    var jsondata = json.decode(response.body);
    print(jsondata);

    List<DailyModel10> newDailyList = [];

    for (var u in jsondata) {
      DailyModel10 daily = DailyModel10(
          u['DailyDetailsID'] ?? '',
          u['LocationDescription'] ?? '',
          u['coordinates'] ?? [],
          u['RainFall'] ?? '',
          u['RainFallColorCode'] ?? '',
          u['RainFallPercentage'] ?? '',
          u['RainFallPercentageColorCode'] ?? '',
          u['LowTemp'] != null ? u['LowTemp'].toString() : '',
          u['LowTempColorCode'] ?? '',
          u['HighTemp'] != null ? u['HighTemp'].toString() : '',
          u['HighTempColorCode'] ?? '',
          u['RainFallDescription'] ?? '',
          u['CloudCover'] ?? '',
          u['Humidity'] ?? '',
          u['WindSpeed'] ?? '',
          u['WindDirection'] ?? '',
          u['MeanTemp'] ?? '');
      newDailyList.add(daily);
    }

    // ignore: use_build_context_synchronously
    print(newDailyList);
    dailyProvider.setRefresh(false);
    dailyProvider.setDailyDetails(newDailyList[0]);
    // }else{
    //   return ;
    // }
    if (newDailyList.isNotEmpty) {
      return newDailyList.first;
    } else {
      return null;
    }
  }

  static Future<DailyModel10?> get10DaysSearch(
      BuildContext context, String searchString) async {
    final dailyProvider = context.read<Daily10Provider>();
    dailyProvider.setRefresh(true);
    final response = await http.get(Uri.parse('$day10SearchApi $searchString'));

    var jsondata = json.decode(response.body);

    List<Daily10SearchModel> daily10response = [];

    for (var u in jsondata) {
      Daily10SearchModel daily = Daily10SearchModel(
        u['LocationID'] ?? '',
        u['LocationDescription'] ?? '',
      );
      daily10response.add(daily);
    }
    print(daily10response.length);
    dailyProvider.setDaily10Search(daily10response);
  }
}
