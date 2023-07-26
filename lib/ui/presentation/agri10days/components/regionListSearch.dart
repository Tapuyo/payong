// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payong/models/agri_10_days_forecast.dart';
import 'package:payong/models/agri_forecast_model.dart';
import 'package:payong/models/daily_10_search_model.dart';
import 'package:payong/models/daily_model.dart';
import 'package:payong/models/mcao_search_prov_model.dart';
import 'package:payong/models/region_search_model.dart';
import 'package:payong/provider/agri_provider.dart';
import 'package:payong/provider/daily10_provider.dart';
import 'package:payong/provider/daily_provider.dart';
import 'package:payong/provider/init_provider.dart';
import 'package:payong/provider/mcao_provider.dart';
import 'package:payong/services/agri_service.dart';
import 'package:payong/services/daily10_service.dart';
import 'package:payong/services/daily_services.dart';
import 'package:payong/utils/hex_to_color.dart';
import 'package:payong/utils/themes.dart';
import 'package:provider/provider.dart';


class RegionSearchList extends HookWidget {
  RegionSearchList({required this.navClose});
  final bool navClose;
  @override
  Widget build(BuildContext context) {
    
    ValueNotifier searchString =  useState(context.read<Daily10Provider>().regList);
    final List<RegionSearchModel>? dailyDetails =
        context.select((Daily10Provider p) => p.regList);
    

    useEffect(() {
      Future.microtask(() async {
        // await Daily10Services.get10DaysSearch(context, searchString.value);
        // print('asdasdasd');
        // print(dailyDetails!.length);
      });
      return;
    }, [searchString.value]);
    if (dailyDetails != null) {
      return SizedBox(
            height:  MediaQuery.of(context).size.height - 100 ,
            child: SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: ColoredBox(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          Visibility(
                            visible: true,
                            child: SizedBox(
                                 height:  MediaQuery.of(context).size.height - 200,
                              child: ListView.builder(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 500),
                                scrollDirection: Axis.vertical,
                                itemCount: dailyDetails.length,
                                itemBuilder: (context, index) {
                                  return searchList(context,dailyDetails[index]);
                                },
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          );
    } else {
      return SizedBox();
    }
  }

  Widget searchList(BuildContext context, RegionSearchModel? dailyMods) {
    final prod = context.read<AgriProvider>();
    return dailyMods != null
        ? Column(children: [
            Divider(
              thickness: 2,
            ),
            GestureDetector(
              onTap: ()async{
               
                  prod.setProgID(dailyMods.id);
                   await AgriServices.getProgDetails(context, dailyMods.id);
                  Navigator.pop(context);

              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          dailyMods.locationDescription,
                          style: TextStyle(color: Colors.black),
                        ),
                        
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ])
        : SizedBox();
  }

 
}
