// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payong/models/agri_model.dart';
import 'package:payong/models/daily_model.dart';
import 'package:payong/provider/agri_provider.dart';
import 'package:payong/provider/daily_provider.dart';
import 'package:payong/services/agri_service.dart';
import 'package:payong/services/daily_services.dart';
import 'package:payong/utils/hex_to_color.dart';
import 'package:payong/utils/themes.dart';
import 'package:provider/provider.dart';

class AgriWidget extends HookWidget {
  const AgriWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rainFallColorCode = useState('#3d85c6');
    final rainFallPercentageColorCode = useState('#3d85c6');
    final lowTemp = useState('0');
    final lowTempColorCode = useState('#3d85c6');
    final highTemp = useState('0');
    final highTempColorCode = useState('#3d85c6');
    final selectIndex = useState<int>(0);

    final bool isRefresh = context.select((AgriProvider p) => p.isRefresh);
    final String id = context.select((AgriProvider p) => p.dailyIDSelected);
    final AgriModel? dailyDetails = context.select((AgriProvider p) => p.dailyDetails);
    useEffect(() {
      Future.microtask(() async {
        final dailyProvider = context.read<AgriProvider>();
        String dt = DateFormat('yyyy-MM-dd').format(dailyProvider.selectedDate);
        await AgriServices.getAgriDetails(context, id,dt);
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
            "Agri Monitoring",
            style: kTextStyleSubtitle2b,
          ),
        ),
        AnimatedSwitcher(duration: Duration(milliseconds: 5),
        child: isRefresh ? SizedBox(height: 25, child: SizedBox(
          height: 25,
          width: 25,
          child: CircularProgressIndicator())) : SizedBox.shrink(),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(dailyDetails != null ? dailyDetails.locationDescription:'',
            style: TextStyle(
                color: kColorDarkBlue,
                fontSize: 22,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: SizedBox(
             height: 500.0,
            child: ListView(
                  scrollDirection: Axis.horizontal,
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
                                double.parse(dailyDetails != null ? dailyDetails.rainFallTo:'0') >= 10
                                    ? FontAwesomeIcons.cloudRain
                                    : FontAwesomeIcons.cloudSun,
                                size: 55,
                                color: double.parse(dailyDetails != null ? dailyDetails.rainFallTo:'0') < 10
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
                                    '${dailyDetails != null ? dailyDetails.rainFallFrom:'0'}% to ${dailyDetails != null ? dailyDetails.rainFallTo:'0'}%',
                                    style: TextStyle(fontSize: 14),
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
                                  color: double.parse(dailyDetails != null ? dailyDetails.highTemp:'0') > 10
                                      ? Colors.white
                                      : Colors.amber,
                                )),
                          )),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 50, 15, 0),
                              child: Icon(
                                double.parse(dailyDetails != null ? dailyDetails.highTemp:'0') > 10
                                    ? FontAwesomeIcons.cloudRain
                                    : FontAwesomeIcons.cloudSun,
                                size: 35,
                                color: double.parse(dailyDetails != null ? dailyDetails.highTemp:'0') > 10
                                    ? Colors.white
                                    : Colors.amber,
                              ))),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(55, 50, 20, 0),
                            child: Text('${dailyDetails != null ? dailyDetails.highTemp:'0'} °C',
                                style: TextStyle(
                                  color: double.parse(dailyDetails != null ? dailyDetails.highTemp:'0') > 10
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
                                  color: double.parse(dailyDetails != null ? dailyDetails.lowTemp:'0') < 10
                                      ? Colors.white
                                      : Colors.amber,
                                )),
                          )),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 140, 15, 0),
                              child: Icon(
                                double.parse(dailyDetails != null ? dailyDetails.lowTemp:'0') < 10
                                    ? FontAwesomeIcons.cloudRain
                                    : FontAwesomeIcons.cloudSun,
                                size: 35,
                                color: double.parse(dailyDetails != null ? dailyDetails.lowTemp:'0') < 10
                                    ? Colors.grey
                                    : Colors.amber,
                              ))),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(55, 140, 20, 0),
                            child: Text(
                              '${dailyDetails != null ? dailyDetails.lowTemp:'0'} °C',
                              style: TextStyle(
                                color: double.parse(dailyDetails != null ? dailyDetails.lowTemp:'0') < 10
                                    ? Colors.grey
                                    : Colors.amber,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(width: 5,),
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
                            child: Text('Wind'),
                          )),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 70, 15, 0),
                              child: Icon(
                                double.parse(dailyDetails != null ? dailyDetails.wind:'0') >= 10
                                    ? FontAwesomeIcons.wind
                                    : Icons.wind_power_sharp,
                                size: 55,
                                color: double.parse(dailyDetails != null ? dailyDetails.wind:'0') >= 10
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
                                    '${dailyDetails != null ? dailyDetails.wind:'0'}%',
                                    style: TextStyle(fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(width: 15,),
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
                            child: Text('Humidity'),
                          )),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 70, 15, 0),
                              child: Icon(
                                double.parse(dailyDetails != null ? dailyDetails.humidity:'0') >= 10
                                    ? FontAwesomeIcons.water
                                    : FontAwesomeIcons.water,
                                size: 55,
                                color: double.parse(dailyDetails != null ? dailyDetails.humidity:'0') >= 10
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
                                    '${dailyDetails != null ? dailyDetails.humidity:'0'}%',
                                    style: TextStyle(fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
       
        
      ]),
    );
  }
}
