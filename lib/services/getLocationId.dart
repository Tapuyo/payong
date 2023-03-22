import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:payong/models/agri_model.dart';
import 'package:payong/provider/agri_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

abstract class SystemService {
  static Future<String> getLocationId(
      BuildContext context, String location) async {
    // location = 'Aliaga,Nueva%20Ecija';
    final response = await http.get(Uri.parse(
        'http://203.177.82.125:8081/payong_app/API/locations.php?location=$location'));
    var jsondata = json.decode(response.body);

    String id = '';

    for (var u in jsondata) {
      id = u['LocationID'] ?? '';

    }
    return id;
  }

  
}
