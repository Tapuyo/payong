import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payong/models/daily_10_map.dart';
import 'package:http/http.dart' as http;
import 'package:payong/models/mcao_assessment_model.dart';

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
}