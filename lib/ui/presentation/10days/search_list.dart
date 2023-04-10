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
import 'package:payong/provider/agri_provider.dart';
import 'package:payong/provider/daily10_provider.dart';
import 'package:payong/provider/daily_provider.dart';
import 'package:payong/provider/init_provider.dart';
import 'package:payong/services/agri_service.dart';
import 'package:payong/services/daily10_service.dart';
import 'package:payong/services/daily_services.dart';
import 'package:payong/utils/hex_to_color.dart';
import 'package:payong/utils/themes.dart';
import 'package:provider/provider.dart';


class SearchList extends HookWidget {
  const SearchList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    ValueNotifier searchString =  useState(context.read<Daily10Provider>().daily10Search);
    final List<Daily10SearchModel>? dailyDetails =
        context.select((Daily10Provider p) => p.daily10Search);

    useEffect(() {
      Future.microtask(() async {
        await Daily10Services.get10DaysSearch(context, searchString.value);
        print('asdasdasd');
        print(dailyDetails!.length);
      });
      return;
    }, [searchString.value]);

    return dailyDetails != null
        ? SizedBox(
            height: MediaQuery.of(context).size.height - 250,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      SizedBox(
                           height: MediaQuery.of(context).size.height - 200,
                        child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 500),
                          scrollDirection: Axis.vertical,
                          itemCount: dailyDetails.length,
                          itemBuilder: (context, index) {
                            return searchList(context,dailyDetails[index]);
                          },
                        ),
                      ),
                    ]),
              ),
            ),
          )
        : SizedBox();
  }

  Widget searchList(BuildContext context, Daily10SearchModel? dailyMods) {
    return dailyMods != null
        ? Column(children: [
            Divider(
              thickness: 2,
            ),
            GestureDetector(
              onTap: (){
                 final dailyProvider = context.read<Daily10Provider>();
                  dailyProvider.setDailyId(dailyMods.locationId);
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