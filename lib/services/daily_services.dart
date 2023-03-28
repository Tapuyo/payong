import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:payong/models/daily_model.dart';
import 'package:payong/provider/daily_provider.dart';

abstract class DailyServices {
  static Future<void> getDailyList(
      BuildContext context, String date) async {
          print('mnxmvnmxcnvxcv $date');
        // date = '2023-02-09';
    final response = await http.get(Uri.parse(
        'http://203.177.82.125:8081/payong_app/API/DailyMon.php?fdate=$date'));
    var jsondata = json.decode(response.body);

    List<DailyModel> newDailyList = [];
    print(jsondata.toString());
    for (var u in jsondata) {
      print('mnxmvnmxcnvxcv');
      DailyModel daily = DailyModel(
          u['LocationID'],
          u['LocationDescription'] ?? '',
          u['coordinates'] ?? [],
          u['ActualRainFall'] ?? '',
          u['ActualRainFallColor'] ?? '',
          u['NormalRainFall'] ?? '',
          u['NormalRainFallColor'] ?? '',
          u['MinTemp'].toString() ,
          u['MinTempColor'] ?? '',
          u['MaxTemp'].toString(),
          u['MaxTempColor'] ?? '',);
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
    // date = '2023-03-03';
    // dailyDetailsID = '1';
    final response = await http.get(Uri.parse(
        'http://203.177.82.125:8081/payong_app/API/DailyMon.php?fdate=$date&location=$dailyDetailsID'));

    //http://203.177.82.125:8081/payong_app/API/DailyMon.php?fdate=2023-03-28&location=32
    // if (response.statusCode == 201 || response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      print(jsondata);

      List<DailyModel> newDailyList = [];

      for (var u in jsondata) {
        DailyModel daily = DailyModel(
            u['LocationID'] ?? '',
            u['LocationDescription'] ?? '',
            u['coordinates'] ?? [],
            double.parse(u['ActualRainFall']).toStringAsFixed(2) ?? '',
            u['ActualRainFallColor'] ?? '',
            double.parse(u['NormalRainFall'] ).toStringAsFixed(2) ?? '',
            u['NormalRainFallColor'] ?? '',
            u['MinTemp'] != null ? double.parse(u['MinTemp']).toStringAsFixed(2) : '',
            u['MinTempColor'] ?? '',
            u['MaxTemp'] != null ? double.parse(u['MaxTemp']).toStringAsFixed(2) : '',
            u['MaxTempColor'] ?? '');
        newDailyList.add(daily);
      }
      // ignore: use_build_context_synchronously
      // print(newDailyList);
      dailyProvider.setRefresh(false);
      dailyProvider.setDailyDetails(newDailyList[0]);
    // }else{
    //   return ;
    // }
    await getDailyDetails1(context, dailyDetailsID, date);
    await getDailyDetails2(context, dailyDetailsID, date);
    await getDailyDetails3(context, dailyDetailsID, date);
    if(newDailyList.isNotEmpty){
      return newDailyList.first;
    }else{
      return null;
    }

    
  }

  static Future<DailyModel?> getDailyDetails1(
      BuildContext context, String dailyDetailsID, String date) async {
    final dailyProvider = context.read<DailyProvider>();
    dailyProvider.setRefresh(true);
        String dt = DateFormat('yyyy-MM-dd').format(dailyProvider.selectedDate.subtract(Duration(days: 1)));
    final response = await http.get(Uri.parse(
        'http://203.177.82.125:8081/payong_app/API/DailyMon.php?fdate=$date&location=$dt'));

    //http://203.177.82.125:8081/payong_app/API/DailyMon.php?fdate=2023-03-28&location=32
    // if (response.statusCode == 201 || response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      print(jsondata);

      List<DailyModel> newDailyList = [];

      for (var u in jsondata) {
        DailyModel daily = DailyModel(
            u['LocationID'] ?? '',
            u['LocationDescription'] ?? '',
            u['coordinates'] ?? [],
            double.parse(u['ActualRainFall']).toStringAsFixed(2) ?? '',
            u['ActualRainFallColor'] ?? '',
            double.parse(u['NormalRainFall'] ).toStringAsFixed(2) ?? '',
            u['NormalRainFallColor'] ?? '',
            u['MinTemp'] != null ? double.parse(u['MinTemp']).toStringAsFixed(2) : '',
            u['MinTempColor'] ?? '',
            u['MaxTemp'] != null ? double.parse(u['MaxTemp']).toStringAsFixed(2) : '',
            u['MaxTempColor'] ?? '');
        newDailyList.add(daily);
      }
      // ignore: use_build_context_synchronously
      // print(newDailyList);
      dailyProvider.setRefresh(false);
      dailyProvider.setDailyDetails1(newDailyList[0]);
    // }else{
    //   return ;
    // }
    if(newDailyList.isNotEmpty){
      return newDailyList.first;
    }else{
      return null;
    }
  }

  static Future<DailyModel?> getDailyDetails2(
      BuildContext context, String dailyDetailsID, String date) async {
    final dailyProvider = context.read<DailyProvider>();
    dailyProvider.setRefresh(true);
      String dt = DateFormat('yyyy-MM-dd').format(dailyProvider.selectedDate.subtract(Duration(days: 2)));
    final response = await http.get(Uri.parse(
        'http://203.177.82.125:8081/payong_app/API/DailyMon.php?fdate=$date&location=$dailyDetailsID'));

    //http://203.177.82.125:8081/payong_app/API/DailyMon.php?fdate=2023-03-28&location=32
    // if (response.statusCode == 201 || response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      print(jsondata);

      List<DailyModel> newDailyList = [];

      for (var u in jsondata) {
        DailyModel daily = DailyModel(
            u['LocationID'] ?? '',
            u['LocationDescription'] ?? '',
            u['coordinates'] ?? [],
            double.parse(u['ActualRainFall']).toStringAsFixed(2) ?? '',
            u['ActualRainFallColor'] ?? '',
            double.parse(u['NormalRainFall'] ).toStringAsFixed(2) ?? '',
            u['NormalRainFallColor'] ?? '',
            u['MinTemp'] != null ? double.parse(u['MinTemp']).toStringAsFixed(2) : '',
            u['MinTempColor'] ?? '',
            u['MaxTemp'] != null ? double.parse(u['MaxTemp']).toStringAsFixed(2) : '',
            u['MaxTempColor'] ?? '');
        newDailyList.add(daily);
      }
      // ignore: use_build_context_synchronously
      // print(newDailyList);
      dailyProvider.setRefresh(false);
      dailyProvider.setDailyDetails2(newDailyList[0]);
    // }else{
    //   return ;
    // }
    if(newDailyList.isNotEmpty){
      return newDailyList.first;
    }else{
      return null;
    }
  }

  static Future<DailyModel?> getDailyDetails3(
      BuildContext context, String dailyDetailsID, String date) async {
    final dailyProvider = context.read<DailyProvider>();
    dailyProvider.setRefresh(true);
      String dt = DateFormat('yyyy-MM-dd').format(dailyProvider.selectedDate.subtract(Duration(days: 3)));
    final response = await http.get(Uri.parse(
        'http://203.177.82.125:8081/payong_app/API/DailyMon.php?fdate=$date&location=$dailyDetailsID'));

    //http://203.177.82.125:8081/payong_app/API/DailyMon.php?fdate=2023-03-28&location=32
    // if (response.statusCode == 201 || response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      print(jsondata);

      List<DailyModel> newDailyList = [];

      for (var u in jsondata) {
        DailyModel daily = DailyModel(
            u['LocationID'] ?? '',
            u['LocationDescription'] ?? '',
            u['coordinates'] ?? [],
            double.parse(u['ActualRainFall']).toStringAsFixed(2) ?? '',
            u['ActualRainFallColor'] ?? '',
            double.parse(u['NormalRainFall'] ).toStringAsFixed(2) ?? '',
            u['NormalRainFallColor'] ?? '',
            u['MinTemp'] != null ? double.parse(u['MinTemp']).toStringAsFixed(2) : '',
            u['MinTempColor'] ?? '',
            u['MaxTemp'] != null ? double.parse(u['MaxTemp']).toStringAsFixed(2) : '',
            u['MaxTempColor'] ?? '');
        newDailyList.add(daily);
      }
      // ignore: use_build_context_synchronously
      // print(newDailyList);
      dailyProvider.setRefresh(false);
      dailyProvider.setDailyDetails3(newDailyList[0]);
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
