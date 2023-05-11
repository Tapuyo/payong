import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:payong/models/daily_legend_model.dart';
import 'package:payong/utils/strings.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:payong/models/daily_model.dart';
import 'package:payong/provider/daily_provider.dart';

abstract class DailyServices {
  static Future<void> getDailyList(
      BuildContext context, String date, String page, String option) async {
    //  date = '2023-04-04';
    print('dasasdasd$dailyMap page=$page&fdate=$date&option=$option');
    final response = await http
        .get(Uri.parse('$dailyMap page=$page&fdate=$date&option=$option'));
    var jsondata = json.decode(response.body);

    List<DailyModel> newDailyList = [];
    print(jsondata.toString());
    for (var u in jsondata) {
      String meanTemp = '';
      try{
        meanTemp = (double.parse( u['OverAllMinTemp']) + double.parse( u['OverAllMaxTemp']) / 2).toString();
      }catch(e){
        meanTemp = '0';
      }
      DailyModel daily = DailyModel(
        u['LocationID'] ?? '',
        u['LocationDescription'] ?? '',
        u['coordinates'] ?? [],
        u['ActualRainFall'] ?? '',
        u['ActualRainFallColor'] ?? '',
        u['NormalRainFall'] ?? '',
        u['NormalRainfallColor'] ?? '',
        u['MinTemp'] ?? '',
        u['MinTempColor'] ?? '',
        u['MaxTemp'] ?? '',
        u['MaxTempColor'] ?? '',
        u['RainfallPercentColor'] ?? '#3d85c6',
        u['TotalNormalRainFall'] ?? '',
        
        u['TotalActualRainFall'] ?? '',
        meanTemp,
        u['OverAllMinTemp'] ?? '',
        u['OverAllMaxTemp'] ?? '',
      );
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
    // date = '2023-04-04';
    // dailyDetailsID = '12';
    print('asdasd$dailyDetails fdate=$date&location_id=$dailyDetailsID');
    final response = await http.get(
        Uri.parse('$dailyDetails fdate=$date&location_id=$dailyDetailsID'));

    //http://203.177.82.125:8081/payong_app/API/DailyMon.php?fdate=2023-03-28&location=32
    // if (response.statusCode == 201 || response.statusCode == 200) {
    var jsondata = json.decode(response.body);

    List<DailyModel> newDailyList = [];
    print(jsondata);
    for (var u in jsondata) {
      String meanTemp = '';
      try{
        meanTemp = ((double.parse( u['OverAllMaxTemp']) + double.parse( u['OverAllMinTemp'])) / 2).toString();
      }catch(e){
        meanTemp = '0';
      }
      DailyModel daily = DailyModel(
          u['LocationID'] ?? '',//dailyDetailsID
          u['LocationDescription'] ?? '',//locationDescription
          u['coordinates'] ?? [],//locationCoordinate
          double.parse(u['ActualRainFall'] ?? '0.00').toStringAsFixed(2),//rainFallActual
          u['ActualRainFallColor'] ?? '#006633',//rainFallActualColorCode
          double.parse(u['NormalRainFall'] ?? '0.00').toStringAsFixed(2),//rainFallNormal
          u['NormalRainFallColor'] ?? '#006633',//rainFallNormalColorCode
          u['MinTemp'] != null
              ? double.parse(u['MinTemp'] ?? '0.00').toStringAsFixed(2)
              : '',//lowTemp
          u['MinTempColor'] ?? '#006633',//lowTempColorCode
          u['MaxTemp'] != null
              ? double.parse(u['MaxTemp'] ?? '0.00').toStringAsFixed(2)
              : '',//highTemp
          u['MaxTempColor'] ?? '#006633',//highTempColorCode
          u['MaxTempColor'] ?? '#006633',//percentrainFallColorCode
           u['TotalNormalRainFall'] ?? '',//totalNormalRainFall

        u['TotalActualRainFall'] ?? '',
        meanTemp,
        u['OverAllMinTemp'] ?? '',
        u['OverAllMaxTemp'] ?? '',);
      newDailyList.add(daily); print('meanTemp $meanTemp');
    }
    // ignore: use_build_context_synchronously
    dailyProvider.setRefresh(false);
    dailyProvider.setDailyDetails(newDailyList[0]);
    // }else{
    //   return ;
    // }
    await getDailyDetails1(context, dailyDetailsID, date);
    await getDailyDetails2(context, dailyDetailsID, date);
    await getDailyDetails3(context, dailyDetailsID, date);
    if (newDailyList.isNotEmpty) {
      return newDailyList.first;
    } else {
      return null;
    }
  }

  static Future<DailyModel?> getDailyDetails1(
      BuildContext context, String dailyDetailsID, String date) async {
    final dailyProvider = context.read<DailyProvider>();
    dailyProvider.setRefresh(true);
    String dt = DateFormat('yyyy-MM-dd')
        .format(dailyProvider.selectedDate.subtract(Duration(days: 1)));
    // dt = '2023-04-04';
    // dailyDetailsID = '12';
    print('$dailyDetails fdate=$dt&location_id=$dailyDetailsID');
    final response = await http
        .get(Uri.parse('$dailyDetails fdate=$dt&location_id=$dailyDetailsID'));

    //http://203.177.82.125:8081/payong_app/API/DailyMon.php?fdate=2023-03-28&location=32
    // if (response.statusCode == 201 || response.statusCode == 200) {
    var jsondata = json.decode(response.body);
    print(jsondata);
    List<DailyModel> newDailyList = [];

    for (var u in jsondata) {
      String meanTemp = '';
      try{
        meanTemp = (double.parse( u['OverAllMinTemp']) + double.parse( u['OverAllMaxTemp']) / 2).toString();
      }catch(e){
        meanTemp = '0';
      }
      print( u['MinTemp']);
      DailyModel daily = DailyModel(
          u['LocationID'] ?? '',
          u['LocationDescription'] ?? '',
          u['coordinates'] ?? [],
          double.parse(u['ActualRainFall'] ?? '0.00').toStringAsFixed(2),
          u['ActualRainFallColor'] ?? '#006633',
          double.parse(u['NormalRainFall'] ?? '0.00').toStringAsFixed(2),
          u['NormalRainFallColor'] ?? '#006633',
          u['MinTemp'],
          u['MinTempColor'] ?? '#006633',
          u['MaxTemp'],
          u['MaxTempColor'] ?? '#006633',
          u['MaxTempColor'] ?? '#006633',
           u['TotalNormalRainFall'],
        u['TotalActualRainFall'],
        meanTemp,
        u['OverAllMinTemp'] ?? '',
        u['OverAllMaxTemp'] ?? '',);
       
      newDailyList.add(daily);
       
    }
    // ignore: use_build_context_synchronously
    
    dailyProvider.setRefresh(false);
    dailyProvider.setDailyDetails1(newDailyList[0]);
    // }else{
    //   return ;
    // }
    if (newDailyList.isNotEmpty) {
      return newDailyList.first;
    } else {
      return null;
    }
  }

  static Future<DailyModel?> getDailyDetails2(
      BuildContext context, String dailyDetailsID, String date) async {
    final dailyProvider = context.read<DailyProvider>();
    dailyProvider.setRefresh(true);
    String dt = DateFormat('yyyy-MM-dd')
        .format(dailyProvider.selectedDate.subtract(Duration(days: 2)));
    // dt = '2023-04-03';
    // dailyDetailsID = '12';
    final response = await http
        .get(Uri.parse('$dailyDetails fdate=$dt&location_id=$dailyDetailsID'));

    //http://203.177.82.125:8081/payong_app/API/DailyMon.php?fdate=2023-03-28&location=32
    // if (response.statusCode == 201 || response.statusCode == 200) {
    var jsondata = json.decode(response.body);
    print(jsondata);

    List<DailyModel> newDailyList = [];

    for (var u in jsondata) {
      String meanTemp = '';
      try{
        meanTemp = (double.parse( u['OverAllMinTemp']) + double.parse( u['OverAllMaxTemp']) / 2).toString();
      }catch(e){
        meanTemp = '0';
      }
      DailyModel daily = DailyModel(
          u['LocationID'] ?? '',
          u['LocationDescription'] ?? '',
          u['coordinates'] ?? [],
          double.parse(u['ActualRainFall'] ?? '0.00').toStringAsFixed(2),
          u['ActualRainFallColor'] ?? '#006633',
          double.parse(u['NormalRainFall'] ?? '0.00').toStringAsFixed(2),
          u['NormalRainFallColor'] ?? '#006633',
          u['MinTemp'] != null
              ? double.parse(u['MinTemp'] ?? '0.00').toStringAsFixed(2)
              : '',
          u['MinTempColor'] ?? '#006633',
          u['MaxTemp'] != null
              ? double.parse(u['MaxTemp'] ?? '0.00').toStringAsFixed(2)
              : '',
          u['MaxTempColor'] ?? '#006633',
          u['MaxTempColor'] ?? '#006633',
           u['TotalNormalRainFall'] ?? '',
        u['TotalActualRainFall'] ?? '',
        meanTemp,
        u['OverAllMinTemp'] ?? '',
        u['OverAllMaxTemp'] ?? '',);
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    // print(newDailyList);
    dailyProvider.setRefresh(false);
    dailyProvider.setDailyDetails2(newDailyList[0]);
    // }else{
    //   return ;
    // }
    if (newDailyList.isNotEmpty) {
      return newDailyList.first;
    } else {
      return null;
    }
  }

  static Future<DailyModel?> getDailyDetails3(
      BuildContext context, String dailyDetailsID, String date) async {
    final dailyProvider = context.read<DailyProvider>();
    dailyProvider.setRefresh(true);
    String dt = DateFormat('yyyy-MM-dd')
        .format(dailyProvider.selectedDate.subtract(Duration(days: 3)));
    // dt = '2023-04-02';
    // dailyDetailsID = '12';
    final response = await http
        .get(Uri.parse('$dailyDetails fdate=$dt&location_id=$dailyDetailsID'));

    //http://203.177.82.125:8081/payong_app/API/DailyMon.php?fdate=2023-03-28&location=32
    // if (response.statusCode == 201 || response.statusCode == 200) {
    var jsondata = json.decode(response.body);
    print(jsondata);

    List<DailyModel> newDailyList = [];

    for (var u in jsondata) {
     String meanTemp = '';
      try{
        meanTemp = (double.parse( u['OverAllMinTemp']) + double.parse( u['OverAllMaxTemp']) / 2).toString();
      }catch(e){
        meanTemp = '0';
      }
      DailyModel daily = DailyModel(
          u['LocationID'] ?? '',
          u['LocationDescription'] ?? '',
          u['coordinates'] ?? [],
          double.parse(u['ActualRainFall'] ?? '0.00').toStringAsFixed(2),
          u['ActualRainFallColor'] ?? '#006633',
          double.parse(u['NormalRainFall'] ?? '0.00').toStringAsFixed(2),
          u['NormalRainFallColor'] ?? '#006633',
          u['MinTemp'],
          u['MinTempColor'] ?? '#006633',
          u['MaxTemp'],
          u['MaxTempColor'] ?? '#006633',
          u['MaxTempColor'] ?? '#006633',
           u['TotalNormalRainFall'] ?? '',
        u['TotalActualRainFall'] ?? '',
        meanTemp,
        u['OverAllMinTemp'] ?? '',
        u['OverAllMaxTemp'] ?? '',);
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    // print(newDailyList);
    dailyProvider.setRefresh(false);
    dailyProvider.setDailyDetails3(newDailyList[0]);
    // }else{
    //   return ;
    // }
    if (newDailyList.isNotEmpty) {
      return newDailyList.first;
    } else {
      return null;
    }
  }

  static Future<void> getDailyLegend(
    BuildContext context,
  ) async {
    final dailyProvider = context.read<DailyProvider>();
    dailyProvider.setListDailyLegend([]);
    String legendUrl =
        'http://18.139.91.35/payong/API/normal_rainfall_legends.php';
    if (dailyProvider.option == 'MinTemp') {
      legendUrl = 'http://18.139.91.35/payong/API/temp_legends.php';
    } else if (dailyProvider.option == 'NormalRainfall') {
      legendUrl = 'http://18.139.91.35/payong/API/normal_rainfall_legends.php';
    } else if (dailyProvider.option == 'MaxTemp') {
      legendUrl = 'http://18.139.91.35/payong/API/temp_legends.php';
    } else if (dailyProvider.option == 'ActualRainfall') {
      legendUrl = 'http://18.139.91.35/payong/API/actual_rainfall_legends.php';
    } else if (dailyProvider.option == 'RainfallPercent') {
      legendUrl = 'http://18.139.91.35/payong/API/rainpercent_legends.php';
    } else {
      legendUrl = 'http://18.139.91.35/payong/API/normal_rainfall_legends.php';
    }

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
