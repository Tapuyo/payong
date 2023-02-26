// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payong/models/daily_model.dart';
import 'package:payong/provider/daily_provider.dart';
import 'package:payong/services/daily_services.dart';
import 'package:payong/utils/hex_to_color.dart';
import 'package:payong/utils/themes.dart';
import 'package:provider/provider.dart';

class DailyWidget extends HookWidget {
  const DailyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rainFallColorCode = useState('#3d85c6');
    final rainFallPercentageColorCode = useState('#3d85c6');
    final lowTemp = useState('0');
    final lowTempColorCode = useState('#3d85c6');
    final highTemp = useState('0');
    final highTempColorCode = useState('#3d85c6');
    final selectIndex = useState<int>(0);

    final bool isRefresh = context.select((DailyProvider p) => p.isRefresh);
    final String id = context.select((DailyProvider p) => p.dailyIDSelected);
    final DailyModel? dailyDetails =
        context.select((DailyProvider p) => p.dailyDetails);
    useEffect(() {
      Future.microtask(() async {
        final dailyProvider = context.read<DailyProvider>();
        String dt = DateFormat('yyyy-MM-dd').format(dailyProvider.selectedDate);
        await DailyServices.getDailyDetails(context, id, dt);
      });
      return;
    }, [id]);

    return Container(
      height: MediaQuery.of(context).size.height - 200,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      width: MediaQuery.of(context).size.width,
      child: Column(children: [
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
          child: Text(
            "Daily Weather",
            style: kTextStyleSubtitle2b,
          ),
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 5),
          child: isRefresh
              ? SizedBox(
                  height: 25,
                  child: SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator()))
              : SizedBox.shrink(),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            dailyDetails != null ? dailyDetails.locationDescription : '',
            style: TextStyle(
                color: kColorDarkBlue,
                fontSize: 22,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              GestureDetector(
                onTap: () {
                  selectIndex.value = 0;
                },
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 200,
                      decoration: BoxDecoration(
                          color: selectIndex.value == 0
                              ? kColorBlue
                              : Colors.black54,
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Text('Rain Fall'),
                        )),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 70, 15, 0),
                            child: Icon(
                              double.parse(dailyDetails != null
                                          ? dailyDetails.rainFall
                                          : '0') <
                                      10
                                  ? FontAwesomeIcons.cloudRain
                                  : FontAwesomeIcons.cloudSun,
                              size: 55,
                              color: double.parse(dailyDetails != null
                                          ? dailyDetails.rainFall
                                          : '0') <
                                      10
                                  ? Colors.grey
                                  : Colors.amber,
                            ))),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
                          child: SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${dailyDetails != null ? dailyDetails.rainFallPercentage : '0'}%',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              GestureDetector(
                onTap: () {
                  selectIndex.value = 0;
                },
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 200,
                      decoration: BoxDecoration(
                          color: selectIndex.value == 1
                              ? kColorBlue
                              : Colors.black54,
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Text('High Land',
                              style: TextStyle(
                                color: double.parse(dailyDetails != null
                                            ? dailyDetails.rainFall
                                            : '0') >
                                        10
                                    ? Colors.white
                                    : Colors.amber,
                              )),
                        )),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 50, 15, 0),
                            child: Icon(
                              double.parse(dailyDetails != null
                                          ? dailyDetails.rainFall
                                          : '0') >
                                      10
                                  ? FontAwesomeIcons.cloudRain
                                  : FontAwesomeIcons.cloudSun,
                              size: 35,
                              color: double.parse(dailyDetails != null
                                          ? dailyDetails.rainFall
                                          : '0') >
                                      10
                                  ? Colors.white
                                  : Colors.amber,
                            ))),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(55, 50, 20, 0),
                          child: Text(
                              '${dailyDetails != null ? dailyDetails.highTemp : '0'} °C',
                              style: TextStyle(
                                color: double.parse(dailyDetails != null
                                            ? dailyDetails.rainFall
                                            : '0') >
                                        10
                                    ? Colors.white
                                    : Colors.amber,
                              )),
                        )),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 110, 20, 0),
                          child: Text('Low Land',
                              style: TextStyle(
                                color: double.parse(dailyDetails != null
                                            ? dailyDetails.rainFall
                                            : '0') <
                                        10
                                    ? Colors.white
                                    : Colors.amber,
                              )),
                        )),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 140, 15, 0),
                            child: Icon(
                              double.parse(dailyDetails != null
                                          ? dailyDetails.rainFall
                                          : '0') <
                                      10
                                  ? FontAwesomeIcons.cloudRain
                                  : FontAwesomeIcons.cloudSun,
                              size: 35,
                              color: double.parse(dailyDetails != null
                                          ? dailyDetails.rainFall
                                          : '0') <
                                      10
                                  ? Colors.grey
                                  : Colors.amber,
                            ))),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(55, 140, 20, 0),
                          child: Text(
                            '${dailyDetails != null ? dailyDetails.lowTemp : '0'} °C',
                            style: TextStyle(
                              color: double.parse(dailyDetails != null
                                          ? dailyDetails.rainFall
                                          : '0') <
                                      10
                                  ? Colors.grey
                                  : Colors.amber,
                            ),
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  width: 140,
                  height: 30,
                  decoration: BoxDecoration(
                      color: kColorBlue,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Center(child: Text('8:00 - 9:00 AM')),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 140,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Center(child: Text('9:01 - 10:00 AM')),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 140,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Center(child: Text('10:01 - 11:00 AM')),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 140,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Center(child: Text('11:01 - 12:00 PM')),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 140,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Center(child: Text('01:01 - 02:00 PM')),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 140,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Center(child: Text('02:01 - 03:00 PM')),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
                  height: 20,
                ),
        Text('Synopsis',style: kTextStyleSubtitle2b,),

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'SYNOPSIS: At 3:00 AM today, the Low Pressure Area (LPA) was estimated based on all available data at 765 km East Southeast of Hinatuan, Surigao del Sur (6.5°N, 133.0°E). Northeast Monsoon affecting Luzon and Visayas.',
            style: kTextStyleSubtitle3b,
          ),
        ),
      ]),
    );
  }
}
