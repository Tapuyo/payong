// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payong/models/agri_forecast_model.dart';
import 'package:payong/models/daily_model.dart';
import 'package:payong/provider/agri_provider.dart';
import 'package:payong/provider/daily_provider.dart';
import 'package:payong/provider/init_provider.dart';
import 'package:payong/services/agri_service.dart';
import 'package:payong/services/daily_services.dart';
import 'package:payong/ui/presentation/agri/forecast/agri_forecast_humidity.dart';
import 'package:payong/ui/presentation/agri/forecast/agri_forecast_leaf_wetness.dart';
import 'package:payong/ui/presentation/agri/forecast/agri_forecast_temp.dart';
import 'package:payong/ui/presentation/agri/forecast/agri_forecast_weather.dart';
import 'package:payong/ui/presentation/agri/forecast/agri_forecast_wind.dart';
import 'package:payong/utils/hex_to_color.dart';
import 'package:payong/utils/themes.dart';
import 'package:provider/provider.dart';

bool dayNow = true;

class AgriForecastWidget extends HookWidget {
  const AgriForecastWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final agriTab = useState(0);
    if (DateTime.now().hour > 6 && DateTime.now().hour < 18) {
      //evening
      dayNow = false;
    } else {
      //day
      dayNow = false;
    }

   

    return 
        SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                          children: <Widget>[
                            SizedBox(
                              height: 40.0,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        agriTab.value = 0;
                                      },
                                      child: Container(
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: agriTab.value == 0
                                              ? dayNow
                                                  ? kColorSecondary
                                                  : kColorBlue
                                              : Colors.white,
                                        ),
                                        height: 35,
                                        child: Center(
                                          child: Text(
                                            'Humidity',
                                            style: kTextStyleSubtitle4b,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        agriTab.value = 1;
                                      },
                                      child: Container(
                                        width: 120,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: agriTab.value == 1
                                              ? dayNow
                                                  ? kColorSecondary
                                                  : kColorBlue
                                              : Colors.white,
                                        ),
                                        height: 35,
                                        child: Center(
                                          child: Text(
                                            'Leaf Wetness',
                                            style: kTextStyleSubtitle4b,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        agriTab.value = 2;
                                      },
                                      child: Container(
                                        width: 110,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: agriTab.value == 2
                                              ? dayNow
                                                  ? kColorSecondary
                                                  : kColorBlue
                                              : Colors.white,
                                        ),
                                        height: 35,
                                        child: Center(
                                          child: Text(
                                            'Temperature',
                                            style: kTextStyleSubtitle4b,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        agriTab.value = 3;
                                      },
                                      child: Container(
                                        width: 60,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: agriTab.value == 3
                                              ? dayNow
                                                  ? kColorSecondary
                                                  : kColorBlue
                                              : Colors.white,
                                        ),
                                        height: 35,
                                        child: Center(
                                          child: Text(
                                            'Wind',
                                            style: kTextStyleSubtitle4b,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        agriTab.value = 4;
                                      },
                                      child: Container(
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: agriTab.value == 4
                                              ? dayNow
                                                  ? kColorSecondary
                                                  : kColorBlue
                                              : Colors.white,
                                        ),
                                        height: 35,
                                        child: Center(
                                          child: Text(
                                            'Weather',
                                            style: kTextStyleSubtitle4b,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                      if(agriTab.value == 0)...[
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: AgriForecastHumidityWidget())
                      ]else  if(agriTab.value == 1)...[
                         SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: AgriForecastLeafWidget())
                        // AgriForecastLeafWidget()
                      ]else  if(agriTab.value == 2)...[
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: AgriForecastTempWidget())
                      ]else  if(agriTab.value == 3)...[
                         SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: AgriForecastWindWidget())
                      ]else  if(agriTab.value == 4)...[
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: AgriForecastWeatherWidget())
                        // AgriForecastWeatherWidget()
                      ]
                    ]),
              ),
            ),
          );
  }
}