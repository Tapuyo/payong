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

    final bool isRefresh = context.select((AgriProvider p) => p.isRefresh);
    final String id = context.select((AgriProvider p) => p.dailyIDSelected);
    final List<AgriForecastModel>? dailyAgriDetails =
        context.select((AgriProvider p) => p.agriForecastModel);
    useEffect(() {
      Future.microtask(() async {
        await AgriServices.getAgriForecast(context, id);
      });
      return;
    }, [id]);

    return dailyAgriDetails != null
        ? SizedBox(
            height: MediaQuery.of(context).size.height - 250,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              agriTab.value = 0;
                            },
                            child: Container(
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
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
                                borderRadius: BorderRadius.circular(10),
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
                                borderRadius: BorderRadius.circular(10),
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
                                borderRadius: BorderRadius.circular(10),
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
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height + 100,
                        child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 500),
                          scrollDirection: Axis.vertical,
                          itemCount: dailyAgriDetails.length,
                          itemBuilder: (context, index) {
                            return foreCastWidget(dailyAgriDetails[index]);
                          },
                        ),
                      ),
                    ]),
              ),
            ),
          )
        : SizedBox();
  }

  Widget foreCastWidget(AgriForecastModel? agriForecastModel) {
    return agriForecastModel != null
        ? Column(children: [
            Divider(
              thickness: 3,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Divider(),
                      Text(
                        'Humidity Areas: ',
                        style: kTextStyleSubtitle4bl,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      location(agriForecastModel.humidityLocation),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        'Minimum Humidity ${agriForecastModel.minHumidity}',
                        style: kTextStyleSubtitle2b,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Maximum Humidity ${agriForecastModel.maxHumidity}',
                        style: kTextStyleSubtitle2b,
                      ),
                      Divider(),
                    ],
                  ),
                  Icon(
                    FontAwesomeIcons.cloud,
                    size: 100,
                    color: dayNow ? kColorSecondary : kColorBlue,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    FontAwesomeIcons.leaf,
                    size: 100,
                    color: dayNow ? kColorSecondary : kColorBlue,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Divider(),
                      Text(
                        'Leaf Wetness Areas: ',
                        style: kTextStyleSubtitle4bl,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      location(agriForecastModel.leafWetnessLocation),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        'Minimum Leaf Wetness ${agriForecastModel.minLeafWetness}',
                        style: kTextStyleSubtitle2b,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Maximum Leaf Wetness ${agriForecastModel.maxLeafWetness}',
                        style: kTextStyleSubtitle2b,
                      ),
                      Divider(),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Divider(),
                      Text(
                        'Temperature Areas: ',
                        style: kTextStyleSubtitle4bl,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      location(agriForecastModel.tempLocation),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        'Low Land Minimum Temperature  ${agriForecastModel.highLandMinTemp}',
                        style: kTextStyleSubtitle2b,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Low Land Maximum Temperature  ${agriForecastModel.lowLandcMaxTemp}',
                        style: kTextStyleSubtitle2b,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        'High Land Minimum Temperature  ${agriForecastModel.highLandMinTemp}',
                        style: kTextStyleSubtitle2b,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        'High Land Maximum Temperature  ${agriForecastModel.highLandMaxTemp}',
                        style: kTextStyleSubtitle2b,
                      ),
                      Divider(),
                    ],
                  ),
                  Icon(
                    FontAwesomeIcons.temperatureHalf,
                    size: 100,
                    color: dayNow ? kColorSecondary : kColorBlue,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    FontAwesomeIcons.wind,
                    size: 100,
                    color: dayNow ? kColorSecondary : kColorBlue,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Divider(),
                      Text(
                        'Wind Condition Areas: ',
                        style: kTextStyleSubtitle4bl,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      location(agriForecastModel.windContidionLocation),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        agriForecastModel.windCondition,
                        style: kTextStyleSubtitle2b,
                      ),
                      Divider(),
                    ],
                  ),
                ],
              ),
            ),
          ])
        : SizedBox();
  }

  Widget location(List<String> areaList) {
    var textList = areaList
        .map<Text>((s) => Text(
              '$s, ',
              style: kTextStyleSubtitle4b,
            ))
        .toList();

    return Column(children: textList);
  }
}
