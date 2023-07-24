// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
import 'dart:convert';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payong/models/daily_10_model.dart';
import 'package:payong/models/daily_model.dart';
import 'package:payong/provider/daily10_provider.dart';
import 'package:payong/provider/daily_provider.dart';
import 'package:payong/provider/init_provider.dart';
import 'package:payong/services/daily10_service.dart';
import 'package:payong/services/daily_services.dart';
import 'package:payong/ui/presentation/10days/utils/rain_fall_chart.dart';
import 'package:payong/utils/hex_to_color.dart';
import 'package:payong/utils/themes.dart';
import 'package:provider/provider.dart';

bool dayNow = true;

class Daily10Widget extends HookWidget {
  const Daily10Widget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final rainFallColorCode = useState('#3d85c6');
    final rainFallPercentageColorCode = useState('#3d85c6');
    final lowTemp = useState('0');
    final lowTempColorCode = useState('#3d85c6');
    final highTemp = useState('0');
    final highTempColorCode = useState('#3d85c6');
    final selectIndex = useState<int>(0);
    final showExpandable1 = useState<bool>(true);
    final showExpandable2 = useState<bool>(true);
    final showExpandable3 = useState<bool>(true);
    final showExpandable4 = useState<bool>(true);
    final showExpandable5 = useState<bool>(true);
    final showExpandable6 = useState<bool>(true);
    final showExpandable7 = useState<bool>(true);
    final showExpandable8 = useState<bool>(true);
    final showExpandable9 = useState<bool>(true);
    final showExpandable10 = useState<bool>(true);

    if (DateTime.now().hour > 6 && DateTime.now().hour < 18) {
      //evening
      dayNow = true;
    } else {
      //day
      dayNow = true;
    }

    final bool isRefresh = context.select((Daily10Provider p) => p.isRefresh);
    final String id = context.select((Daily10Provider p) => p.dailyIDSelected);
    final String? locId = context.select((InitProvider p) => p.myLocationId);
    final DailyModel10? dailyDetails =
        context.select((Daily10Provider p) => p.dailyDetails);
    final dailyDetails1 = useState<DailyModel10?>(null);
    final dailyDetails2 = useState<DailyModel10?>(null);
    final dailyDetails3 = useState<DailyModel10?>(null);
    final dailyDetails4 = useState<DailyModel10?>(null);
    final dailyDetails5 = useState<DailyModel10?>(null);
    final dailyDetails6 = useState<DailyModel10?>(null);
    final dailyDetails7 = useState<DailyModel10?>(null);
    final dailyDetails8 = useState<DailyModel10?>(null);
    final dailyDetails9 = useState<DailyModel10?>(null);
    final dailyDetails10 = useState<DailyModel10?>(null);
    useEffect(() {
      Future.microtask(() async {
        final dailyProvider = context.read<DailyProvider>();
        String dt = DateFormat('yyyy-MM-dd').format(dailyProvider.selectedDate);
        if (id.isEmpty) {
          await Daily10Services.getDailyDetails(context, locId!, dt);
          dailyDetails1.value = await Daily10Services.getDailyDetails(
              context,
              locId,
              DateFormat('yyyy-MM-dd').format(dailyProvider.selectedDate));
          dailyDetails2.value = await Daily10Services.getDailyDetails(
              context,
              locId,
              DateFormat('yyyy-MM-dd')
                  .format(dailyProvider.selectedDate.add(Duration(days: 1))));
          dailyDetails3.value = await Daily10Services.getDailyDetails(
              context,
              locId,
              DateFormat('yyyy-MM-dd')
                  .format(dailyProvider.selectedDate.add(Duration(days: 2))));
          dailyDetails4.value = await Daily10Services.getDailyDetails(
              context,
              locId,
              DateFormat('yyyy-MM-dd')
                  .format(dailyProvider.selectedDate.add(Duration(days: 3))));
          dailyDetails5.value = await Daily10Services.getDailyDetails(
              context,
              locId,
              DateFormat('yyyy-MM-dd')
                  .format(dailyProvider.selectedDate.add(Duration(days: 4))));
          dailyDetails6.value = await Daily10Services.getDailyDetails(
              context,
              locId,
              DateFormat('yyyy-MM-dd')
                  .format(dailyProvider.selectedDate.add(Duration(days: 5))));
          dailyDetails7.value = await Daily10Services.getDailyDetails(
              context,
              locId,
              DateFormat('yyyy-MM-dd')
                  .format(dailyProvider.selectedDate.add(Duration(days: 6))));
          dailyDetails8.value = await Daily10Services.getDailyDetails(
              context,
              locId,
              DateFormat('yyyy-MM-dd')
                  .format(dailyProvider.selectedDate.add(Duration(days: 7))));
          dailyDetails9.value = await Daily10Services.getDailyDetails(
              context,
              locId,
              DateFormat('yyyy-MM-dd')
                  .format(dailyProvider.selectedDate.add(Duration(days: 8))));
          dailyDetails10.value = await Daily10Services.getDailyDetails(
              context,
              locId,
              DateFormat('yyyy-MM-dd')
                  .format(dailyProvider.selectedDate.add(Duration(days: 9))));
        } else {
          await Daily10Services.getDailyDetails(context, id, dt);
          dailyDetails1.value = await Daily10Services.getDailyDetails(
              context,
              id,
              DateFormat('yyyy-MM-dd')
                  .format(dailyProvider.selectedDate.add(Duration(days: 1))));
          dailyDetails2.value = await Daily10Services.getDailyDetails(
              context,
              id,
              DateFormat('yyyy-MM-dd')
                  .format(dailyProvider.selectedDate.add(Duration(days: 2))));
          dailyDetails3.value = await Daily10Services.getDailyDetails(
              context,
              id,
              DateFormat('yyyy-MM-dd')
                  .format(dailyProvider.selectedDate.add(Duration(days: 3))));
          dailyDetails4.value = await Daily10Services.getDailyDetails(
              context,
              id,
              DateFormat('yyyy-MM-dd')
                  .format(dailyProvider.selectedDate.add(Duration(days: 4))));
          dailyDetails5.value = await Daily10Services.getDailyDetails(
              context,
              id,
              DateFormat('yyyy-MM-dd')
                  .format(dailyProvider.selectedDate.add(Duration(days: 5))));
          dailyDetails6.value = await Daily10Services.getDailyDetails(
              context,
              id,
              DateFormat('yyyy-MM-dd')
                  .format(dailyProvider.selectedDate.add(Duration(days: 6))));
          dailyDetails7.value = await Daily10Services.getDailyDetails(
              context,
              id,
              DateFormat('yyyy-MM-dd')
                  .format(dailyProvider.selectedDate.add(Duration(days: 4))));
          dailyDetails8.value = await Daily10Services.getDailyDetails(
              context,
              id,
              DateFormat('yyyy-MM-dd')
                  .format(dailyProvider.selectedDate.add(Duration(days: 7))));
          dailyDetails9.value = await Daily10Services.getDailyDetails(
              context,
              id,
              DateFormat('yyyy-MM-dd')
                  .format(dailyProvider.selectedDate.add(Duration(days: 8))));
          dailyDetails10.value = await Daily10Services.getDailyDetails(
              context,
              id,
              DateFormat('yyyy-MM-dd')
                  .format(dailyProvider.selectedDate.add(Duration(days: 9))));
        }
      });
      return;
    }, [id]);

    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              // ignore: prefer_const_literals_to_create_immutables
              colors: [
                // if (dayNow) ...[
                //   Color(0xFFF2E90B),
                //   Color(0xFF762917),
                // ] else ...[
                Color(0xFF005EEB),
                Color(0xFF489E59),
                // ]
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.clamp),
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ColoredBox(
                  color: kColorDarkBlue.withOpacity(.5),
                  child: SizedBox(
                    height: 2,
                    width: 80,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "10 Days Weather Forecast",
                    style: kTextStyleSubtitle1,
                  ),
                ],
              ),
            ),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Update as of ${DateFormat.yMMMMd().format(DateTime.now())}',
                    style: kTextStyleSubtitle1,
                  ),
                ],
              ),
            ),
            if(dailyDetails == null)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dailyDetails != null
                        ? dailyDetails.locationDescription != ''
                            ? dailyDetails.locationDescription
                            : ''
                        : '',
                    style: kTextStyleSubtitle4,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(children: [
                if (dailyDetails1.value != null)
                  LineChartSample1(
                    d0: dailyDetails1.value != null ? dailyDetails1.value!.rainFallPercentage.isNotEmpty
                        ? double.parse(
                            dailyDetails1.value!.rainFallPercentage,
                          )
                        : 0.0: 0.0,
                    d1: dailyDetails2.value != null ? dailyDetails2.value!.rainFallPercentage.isNotEmpty
                        ? double.parse(
                            dailyDetails2.value!.rainFallPercentage,
                          )
                        : 0.0 : 0.0,
                    d2: dailyDetails3.value != null ? dailyDetails3.value!.rainFallPercentage.isNotEmpty
                        ? double.parse(
                            dailyDetails3.value!.rainFallPercentage,
                          )
                        : 0.0 : 0.0,
                    d3: dailyDetails4.value != null ? dailyDetails4.value!.rainFallPercentage.isNotEmpty
                        ? double.parse(
                            dailyDetails4.value!.rainFallPercentage,
                          )
                        : 0.0 : 0.0,
                    d4: dailyDetails5.value != null ? dailyDetails5.value!.rainFallPercentage.isNotEmpty
                        ? double.parse(
                            dailyDetails5.value!.rainFallPercentage,
                          )
                        : 0.0 : 0.0,
                    d5: dailyDetails6.value != null ? dailyDetails6.value!.rainFallPercentage.isNotEmpty
                        ? double.parse(
                            dailyDetails6.value!.rainFallPercentage,
                          )
                        : 0.0 : 0.0,
                    d6: dailyDetails7.value != null ? dailyDetails7.value!.rainFallPercentage.isNotEmpty
                        ? double.parse(
                            dailyDetails7.value!.rainFallPercentage,
                          )
                        : 0.0 : 0.0,
                    d7: dailyDetails8.value != null ? dailyDetails8.value!.rainFallPercentage.isNotEmpty
                        ? double.parse(
                            dailyDetails8.value!.rainFallPercentage,
                          )
                        : 0.0 : 0.0,
                    d8: dailyDetails9.value != null ? dailyDetails9.value!.rainFallPercentage.isNotEmpty
                        ? double.parse(
                            dailyDetails9.value!.rainFallPercentage,
                          )
                        : 0.0 : 0.0,
                    d9: dailyDetails10.value != null ? dailyDetails10.value!.rainFallPercentage.isNotEmpty
                        ? double.parse(
                            dailyDetails10.value!.rainFallPercentage,
                          )
                        : 0.0 : 0.0,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Humidity ${dailyDetails != null ? dailyDetails!.humidity : ''}',
                      style: kTextStyleWeather3,
                    ),
                    Text(
                      'Wind Speed ${dailyDetails != null ? dailyDetails.windSpeed : '0'} ${dailyDetails != null ? dailyDetails.windDirection : ''}',
                      style: kTextStyleWeather3,
                    ),
                    Text(
                      dailyDetails != null
                          ? dailyDetails.rainFallDescription
                          : '',
                      style: kTextStyleWeather3,
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      'Low Temp ${dailyDetails != null ? '${dailyDetails.lowTemp}°C' : '0°C'}',
                      style: kTextStyleWeather3,
                    ),
                    Text(
                      'High Temp ${dailyDetails != null ? '${dailyDetails.highTemp}°C' : '0°C'}',
                      style: kTextStyleWeather3,
                    ),
                    Text(
                      'MeanTemp ${dailyDetails != null ? '${dailyDetails.meanTemp}°C' : '0°C'}',
                      style: kTextStyleWeather3,
                    ),
                  ],
                ),
                // cloudIcons(dailyDetails != null ? dailyDetails.cloudCover:'CLOUDY'),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Rainfall',
                          style: kTextStyleWeather2,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dailyDetails != null
                                  ? dailyDetails.rainFallPercentage != ''
                                      ? dailyDetails.rainFallPercentage
                                      : '0'
                                  : '10',
                              style: kTextStyleWeather,
                            ),
                            Text(
                              'mm',
                              style: kTextStyleWeather1,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        Text(
                          'Temperature',
                          style: kTextStyleWeather2,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dailyDetails != null
                                  ? dailyDetails.meanTemp != ''
                                      ? dailyDetails.meanTemp
                                      : '0'
                                  : '0',
                              style: kTextStyleWeather,
                            ),
                            Text(
                              '°',
                              style: TextStyle(fontSize: 30),
                            ),
                            Text(
                              'C',
                              style: kTextStyleWeather,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Date',
                          style: kTextStyleWeather2,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Rainfall',
                          style: kTextStyleWeather2,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Temp',
                          style: kTextStyleWeather2,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Cloud',
                          style: kTextStyleWeather2,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Divider(),
                ),
                if (dailyDetails1.value != null)
                  dateWidget(showExpandable1, 0, dailyDetails1.value),
                if (dailyDetails2.value != null)
                  dateWidget(showExpandable2, 1, dailyDetails2.value),
                if (dailyDetails3.value != null)
                  dateWidget(showExpandable3, 2, dailyDetails3.value),
                if (dailyDetails4.value != null)
                  dateWidget(showExpandable4, 3, dailyDetails4.value),
                if (dailyDetails5.value != null)
                  dateWidget(showExpandable5, 4, dailyDetails5.value),
                if (dailyDetails6.value != null)
                  dateWidget(showExpandable6, 5, dailyDetails6.value),
                if (dailyDetails7.value != null)
                  dateWidget(showExpandable7, 6, dailyDetails7.value),
                if (dailyDetails8.value != null)
                  dateWidget(showExpandable8, 7, dailyDetails8.value),
                if (dailyDetails9.value != null)
                  dateWidget(showExpandable9, 8, dailyDetails9.value),
                if (dailyDetails10.value != null)
                  dateWidget(showExpandable10, 9, dailyDetails10.value),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget dateWidget(
      ValueNotifier<bool> showExpandable1, int addDay, DailyModel10? daily) {
    print(daily!.cloudCover);
    return daily != null
        ? Column(
            children: [
              GestureDetector(
                onTap: () {
                  showExpandable1.value = !showExpandable1.value;
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: [
                      Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              DateFormat.MMMEd()
                                  .format(DateTime.now()
                                      .add(Duration(days: addDay)))
                                  .toString(),
                              style: kTextStyleWeather2,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${daily.rainFallPercentage}mm',
                              style: kTextStyleWeather2,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${daily.meanTemp}°C',
                              style: kTextStyleWeather2,
                            ),
                          ),
                          cloudIcons(daily.cloudCover),
                        ],
                      ),
                      if (showExpandable1.value) Divider(),
                      if (showExpandable1.value)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Text(
                              'Humidity ${daily.humidity}',
                              style: kTextStyleWeather3,
                            ),
                            Text(
                              'WindSpeed ${daily.windSpeed} ${daily.windDirection}',
                              style: kTextStyleWeather3,
                            ),
                            Text(
                              daily.rainFallDescription,
                              style: kTextStyleWeather3,
                            ),
                          ],
                        ),
                      // if (showExpandable1.value) cloudIcons(daily.cloudCover),
                      if (showExpandable1.value)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Text(
                              'Low Temp ${daily.lowTemp}°C',
                              style: kTextStyleWeather3,
                            ),
                            Text(
                              'High Temp ${daily.highTemp}°C',
                              style: kTextStyleWeather3,
                            ),
                            Text(
                              'MeanTemp ${daily.meanTemp}°C',
                              style: kTextStyleWeather3,
                            ),
                          ],
                        ),
                      if (showExpandable1.value)
                        SizedBox(
                          height: 12,
                        ),
                    ],
                  ),
                ),
              ),
              Divider(),
            ],
          )
        : SizedBox();
  }

  Widget cloudIcons(String des) {
    if (des == 'SUNNY') {
      return Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('assets/sunny.png'))),
        ],
      );
    } else if (des == 'MOSTLY SUNNY') {
      return Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('assets/mostly_sunny.png'))),
        ],
      );
    } else if (des == 'CLOUDY') {
      return Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('assets/cloudy.png'))),
        ],
      );
    } else if (des == 'PARTLY CLOUDY') {
      return Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('assets/cloudy.png'))),
        ],
      );
    } else if (des == 'MOSTLY CLOUDY') {
      return Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('assets/cloudy_rain.png'))),
        ],
      );
    } else if (des == 'RAINY') {
      return Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('assets/rain.png'))),
        ],
      );
    } else {
      return Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('assets/sunny.png'))),
        ],
      );
    }
  }
}
