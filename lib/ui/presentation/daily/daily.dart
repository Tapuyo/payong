// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payong/models/daily_model.dart';
import 'package:payong/provider/daily_provider.dart';
import 'package:payong/provider/init_provider.dart';
import 'package:payong/services/daily_services.dart';
import 'package:payong/utils/hex_to_color.dart';
import 'package:payong/utils/themes.dart';
import 'package:provider/provider.dart';
 bool dayNow = true;
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
   
    if (DateTime.now().hour > 6 && DateTime.now().hour < 18) {
      //evening
      dayNow = true;
    } else {
      //day
      dayNow = false;
    }

    final bool isRefresh = context.select((DailyProvider p) => p.isRefresh);
    final String id = context.select((DailyProvider p) => p.dailyIDSelected);
    final String? locId = context.select((InitProvider p) => p.myLocationId);
    final DailyModel? dailyDetails =
        context.select((DailyProvider p) => p.dailyDetails);
    final DailyModel? dailyDetails1 =
        context.select((DailyProvider p) => p.dailyDetails);
    final DailyModel? dailyDetails2 =
        context.select((DailyProvider p) => p.dailyDetails);

    final DailyModel? dailyDetails3 =
        context.select((DailyProvider p) => p.dailyDetails);
    useEffect(() {
      Future.microtask(() async {
        final dailyProvider = context.read<DailyProvider>();
        String dt = DateFormat('yyyy-MM-dd').format(dailyProvider.selectedDate);
        if (id.isEmpty) {
          await DailyServices.getDailyDetails(context, locId!, dt);
          // ignore: use_build_context_synchronously
        } else {
          await DailyServices.getDailyDetails(context, id, dt);
        }
      });
      return;
    }, [id]);

    return Container(
      height: MediaQuery.of(context).size.height - 150,
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
            style: kTextStyleSubtitle1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            dailyDetails != null
                ? dailyDetails.locationDescription != ''
                    ? dailyDetails.locationDescription
                    : 'Bohol'
                : 'Pilar Bohol',
            style: kTextStyleSubtitle4,
          ),
        ),
        cloudIcons('CLOUDY'),
        Text(
           DateFormat.MMMEd().format(DateTime.now()).toString(),
          style: kTextStyleWeather2,
        ),
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
                  'Rain Fall',
                  style: kTextStyleWeather2,
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      dailyDetails != null
                          ? dailyDetails.rainFallActual != ''
                              ? dailyDetails.rainFallActual
                              : '0'
                          : '0',
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
                // SizedBox(
                //   height: 8,
                // ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      dailyDetails != null
                          ? dailyDetails.lowTemp != ''
                              ? dailyDetails.rainFallNormal
                              : '0'
                          : '0',
                      style: kTextStyleWeather,
                    ),
                    Text(
                      '°',
                      style: kTextStyleDeg,
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
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      DateFormat.MMMEd().format(DateTime.now().subtract(Duration(days: 1))).toString(),
                      style: kTextStyleWeather2,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '${dailyDetails1 != null ? dailyDetails1.rainFallActual:''} mm',
                      style: kTextStyleWeather2,
                    ),
                  ),
                    Expanded(
                    flex: 1,
                    child: Text(
                      '${dailyDetails1 != null ? dailyDetails1.lowTemp:''}°',
                      style: kTextStyleWeather2,
                    ),
                  ),
                   Expanded(
                    flex: 1,
                    child: Icon(Icons.cloud,size: 30,color: Colors.white,)
                  ),
                ],
              ),
            ),
             Divider(),
             Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      DateFormat.MMMEd().format(DateTime.now().subtract(Duration(days: 2))).toString(),
                      style: kTextStyleWeather2,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '${dailyDetails2 != null ? dailyDetails2.rainFallActual:''} mm',
                      style: kTextStyleWeather2,
                    ),
                  ),
                    Expanded(
                    flex: 1,
                    child: Text(
                      '${dailyDetails2 != null ? dailyDetails2.lowTemp:''}°',
                      style: kTextStyleWeather2,
                    ),
                  ),
                   Expanded(
                    flex: 1,
                    child: Icon(Icons.cloud,size: 30,color: Colors.white,)
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                       DateFormat.MMMEd().format(DateTime.now().subtract(Duration(days: 3))).toString(),
                      style: kTextStyleWeather2,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '${dailyDetails3 != null ? dailyDetails3.rainFallActual:''} mm',
                      style: kTextStyleWeather2,
                    ),
                  ),
                    Expanded(
                    flex: 1,
                    child: Text(
                      '${dailyDetails3 != null ? dailyDetails3.lowTemp:''}°',
                      style: kTextStyleWeather2,
                    ),
                  ),
                   Expanded(
                    flex: 1,
                    child: Icon(Icons.cloud,size: 30,color: Colors.white,)
                  ),
                ],
              ),
            ),
            
          ],
        ),
        
      ]),
    );
  }

  Widget cloudIcons(String des) {
    if (des == 'CLOUDY') {
      return Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.cloud,
                size: 200,
                color: Colors.white.withOpacity(.5),
              )),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Text(
                'Cloudy',
                style: kTextStyleWeather2,
              ),
            ),
          ),
        ],
      );
    } else if (des == 'SUNNY') {
      return Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: dayNow ? Icon(
                Icons.sunny,
                size: 200,
                color: Colors.yellow.withOpacity(.9),
              ): Icon(
                FontAwesomeIcons.solidMoon,
                size: 200,
                color: Colors.yellow.withOpacity(.9),
              )),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Text(
                'Sunny',
                style: kTextStyleWeather2,
              ),
            ),
          ),
        ],
      );
    } else if (des == 'RAINY') {
      return Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: Icon(
                FontAwesomeIcons.cloudRain,
                size: 200,
                color: Colors.white.withOpacity(.5),
              )),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Text(
                'Rainy',
                style: kTextStyleWeather2,
              ),
            ),
          ),
        ],
      );
    } else if (des == 'THUNDER') {
      return Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: Icon(
                FontAwesomeIcons.cloudBolt,
                size: 200,
                color: Colors.yellowAccent.withOpacity(.9),
              )),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Text(
                'Thunder',
                style: kTextStyleWeather2,
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.sunny,
                size: 200,
                color: Colors.yellowAccent.withOpacity(.5),
              )),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Text(
                'Sunny',
                style: kTextStyleWeather2,
              ),
            ),
          ),
        ],
      );
    }
  }
}
