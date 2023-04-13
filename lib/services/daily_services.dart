import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:payong/utils/strings.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:payong/models/daily_model.dart';
import 'package:payong/provider/daily_provider.dart';

abstract class DailyServices {
  static Future<void> getDailyList(
      BuildContext context, String date, String page, String option) async {
       
        print('$dailyMap page=$page&fdate=$date&option=$option');
    final response = await http.get(Uri.parse('$dailyMap page=$page&fdate=$date&option=$option'));
    var jsondata = json.decode(response.body);

    List<DailyModel> newDailyList = [];
    print(jsondata.toString());
    for (var u in jsondata) {
      print('mnxmvnmxcnvxcv');
      DailyModel daily = DailyModel(
          u['LocationID'] ?? '',
          u['LocationDescription'] ?? '',
          u['coordinates'] ?? [],
          u['ActualRainFall'] ?? '',
          u['ActualRainFallColor'] ?? '',
          u['NormalRainFall'] ?? '',
          u['NormalRainfallColor'] ?? '',
          u['MinTemp'] ?? '' ,
          u['MinTempColor'] ?? '',
          u['MaxTemp'] ?? '',
          u['MaxTempColor'] ?? '', 
          u['RainfallPercentColor'] ?? '',);
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
    // date = '2023-04-07';
    // dailyDetailsID = '1';
    final response = await http.get(Uri.parse(
        '$dailyDetails fdate=$date&location_id=$dailyDetailsID'));

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
            double.parse(u['ActualRainFall'] ?? '0.00').toStringAsFixed(2),
            u['ActualRainFallColor'] ?? '#006633',
            double.parse(u['NormalRainFall'] ?? '0.00' ).toStringAsFixed(2),
            u['NormalRainFallColor'] ?? '#006633',
            u['MinTemp'] != null ? double.parse(u['MinTemp'] ?? '0.00').toStringAsFixed(2) : '',
            u['MinTempColor'] ?? '#006633',
            u['MaxTemp'] != null ? double.parse(u['MaxTemp'] ?? '0.00').toStringAsFixed(2) : '',
            u['MaxTempColor'] ?? '#006633', u['MaxTempColor'] ?? '#006633');
        newDailyList.add(daily);
      }
      // ignore: use_build_context_synchronously
      // print(newDailyList);
      dailyProvider.setRefresh(false);
      dailyProvider.setDailyDetails(newDailyList[0]);
    // }else{
    //   return ;
    // }
    // await getDailyDetails1(context, dailyDetailsID, date);
    // await getDailyDetails2(context, dailyDetailsID, date);
    // await getDailyDetails3(context, dailyDetailsID, date);
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
    // dt = '2023-04-06';
    final response = await http.get(Uri.parse(
        '$dailyDetails fdate=$dt&location_id=$dailyDetailsID'));

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
            double.parse(u['ActualRainFall'] ?? '0.00').toStringAsFixed(2),
            u['ActualRainFallColor'] ?? '#006633',
            double.parse(u['NormalRainFall'] ?? '0.00').toStringAsFixed(2),
            u['NormalRainFallColor'] ?? '#006633',
            u['MinTemp'] != null ? double.parse(u['MinTemp'] ?? '0.00').toStringAsFixed(2) : '',
            u['MinTempColor'] ?? '#006633',
            u['MaxTemp'] != null ? double.parse(u['MaxTemp'] ?? '0.00').toStringAsFixed(2) : '',
            u['MaxTempColor'] ?? '#006633',
             u['MaxTempColor'] ?? '#006633');
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
      // dt = '2023-04-05';
    final response = await http.get(Uri.parse(
        '$dailyDetails fdate=$dt&location_id=$dailyDetailsID'));

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
            double.parse(u['ActualRainFall']  ?? '0.00').toStringAsFixed(2) ,
            u['ActualRainFallColor'] ?? '#006633',
            double.parse(u['NormalRainFall']  ?? '0.00').toStringAsFixed(2) ,
            u['NormalRainFallColor'] ?? '#006633',
            u['MinTemp'] != null ? double.parse(u['MinTemp'] ?? '0.00').toStringAsFixed(2) : '',
            u['MinTempColor'] ?? '#006633',
            u['MaxTemp'] != null ? double.parse(u['MaxTemp'] ?? '0.00').toStringAsFixed(2) : '',
            u['MaxTempColor'] ?? '#006633',
             u['MaxTempColor'] ?? '#006633');
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
      // dt = '2023-04-04';
    final response = await http.get(Uri.parse(
        '$dailyDetails fdate=$dt&location_id=$dailyDetailsID'));

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
            double.parse(u['ActualRainFall'] ?? '0.00').toStringAsFixed(2),
            u['ActualRainFallColor'] ?? '#006633',
            double.parse(u['NormalRainFall'] ?? '0.00').toStringAsFixed(2),
            u['NormalRainFallColor'] ?? '#006633',
            u['MinTemp'] != null ? double.parse(u['MinTemp'] ?? '0.00').toStringAsFixed(2) : '',
            u['MinTempColor'] ?? '#006633',
            u['MaxTemp'] != null ? double.parse(u['MaxTemp'] ?? '0.00').toStringAsFixed(2) : '',
            u['MaxTempColor'] ?? '#006633', u['MaxTempColor'] ?? '#006633');
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
