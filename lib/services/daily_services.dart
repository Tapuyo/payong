import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:payong/models/daily_model.dart';
import 'package:payong/provider/daily_provider.dart';

abstract class DailyServices {
  static Future<void> getDailyList(
      BuildContext context, String selectMod, String date) async {
        // date = '2023-02-09';
    final response = await http.get(Uri.parse(
        'http://203.177.82.125:8081/payong_app/API/daily_details.php?fdate=$date'));
    var jsondata = json.decode(response.body);

    List<DailyModel> newDailyList = [];

    for (var u in jsondata) {
      DailyModel daily = DailyModel(
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
          u['HighTempColorCode']);
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<DailyProvider>();
    dailyProvider.setDailyList(newDailyList);
  }

  static Future<DailyModel?> getDailyDetails(
      BuildContext context, String dailyDetailsID, String date) async {
    final dailyProvider = context.read<DailyProvider>();
    dailyProvider.setRefresh(true);
    date = '2023-03-03';
    dailyDetailsID = '1';
    final response = await http.get(Uri.parse(
        'http://203.177.82.125:8081/payong_app/API/daily_details.php?fdate=$date&DailyDetailsID=$dailyDetailsID'));

    // if (response.statusCode == 201 || response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      print(jsondata);

      List<DailyModel> newDailyList = [];

      for (var u in jsondata) {
        DailyModel daily = DailyModel(
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
            u['HighTempColorCode'] ?? '');
        newDailyList.add(daily);
      }
      // ignore: use_build_context_synchronously
      print(newDailyList);
      dailyProvider.setRefresh(false);
      dailyProvider.setDailyDetails(newDailyList[0]);
    // }else{
    //   return ;
    // }
    if(newDailyList.isNotEmpty){
      return newDailyList.first;
    }else{
      return null;
    }
  }
}
