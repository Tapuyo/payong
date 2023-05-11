import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:payong/models/agri_model.dart';
import 'package:payong/models/system_ads_model.dart';
import 'package:payong/provider/agri_provider.dart';
import 'package:payong/provider/init_provider.dart';
import 'package:payong/utils/strings.dart';
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

     static Future<List<AdsModel>> getAdsSystem(
      BuildContext context) async {
            final dailyProvider = context.read<InitProvider>();
        dailyProvider.setAdsList([]);
    final response = await http
        .get(Uri.parse('http://18.139.91.35/payong/Api/system_advisory.php'));
    var jsondata = json.decode(response.body);

    List<AdsModel> adList = [];

    for (var u in jsondata) {
      AdsModel daily = AdsModel(
        u['AdvisoryId'] ?? '',
        u['SourceType'] ?? '',
        u['Source'] ?? '',
         u['link_destination_type'] ?? '',
          u['LinkDestination'] ?? [],
          
      );
      
      adList.add(daily);
    }

   dailyProvider.setAdsList(adList);
    // ignore: use_build_context_synchronously
    return adList;
  }


       static Future<void> getInitWeatherBack(
      BuildContext context) async {
            final dailyProvider = context.read<InitProvider>();
        dailyProvider.setBackImg('assets/backgroundImg/cloud.png', false);
        final String? locId = context.select((InitProvider p) => p.myLocationId);
    String dt = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final response = await http
        .get(Uri.parse('$days10Details fdate=$dt&location=$locId'));
    var jsondata = json.decode(response.body);

    
    String cloud = '';
    for (var u in jsondata) {
      cloud = u['CloudCover'] ?? '';
    }

    if(cloud == 'SUNNY'){
       dailyProvider.setBackImg('assets/backgroundImg/sunny.png', false);
    }else  if(cloud == 'MOSTLY SUNNY'){
       dailyProvider.setBackImg('assets/backgroundImg/sunny.png', false);
    }else  if(cloud == 'CLOUDY'){
       dailyProvider.setBackImg('assets/backgroundImg/cloud.png', false);
    }else  if(cloud == 'PARTLY CLOUDY'){
       dailyProvider.setBackImg('assets/backgroundImg/cloud.png', false);
    }else  if(cloud == 'MOSTLY CLOUDY'){
       dailyProvider.setBackImg('assets/backgroundImg/thunder.png', false);
    }else  if(cloud == 'RAINY'){
       dailyProvider.setBackImg('assets/backgroundImg/rainy.png', true);
    }else {
       dailyProvider.setBackImg('assets/backgroundImg/cloud.png', false);
    }
 
  }
  
}
