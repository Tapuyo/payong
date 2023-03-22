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
class AgriSynopsis10Widget extends HookWidget {
  const AgriSynopsis10Widget({Key? key}) : super(key: key);
  

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
    useEffect(() {
      Future.microtask(() async {
        final dailyProvider = context.read<DailyProvider>();
        String dt = DateFormat('yyyy-MM-dd').format(dailyProvider.selectedDate);
        // if (id.isEmpty) {
        //   print(locId);
        //   await DailyServices.getDailyDetails(context, locId!, dt);
        // } else {
        //   await DailyServices.getDailyDetails(context, id, dt);
        // }
      });
      return;
    }, [id]);

    return Container(
      height: MediaQuery.of(context).size.height - 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            // ignore: prefer_const_literals_to_create_immutables
            colors: [
              if (dayNow) ...[
                Color(0xFFF2E90B),
                Color(0xFF762917),
              ] else ...[
                Color(0xFF005EEB),
                Color.fromARGB(255, 74, 133, 222),
              ]
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.clamp),
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(children: [
      
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Agri Sypnosis",
            style: kTextStyleSubtitle2b,
          ),
        ),
         SizedBox(height: 20,),
         Text(
           DateFormat.MMMEd().format(DateTime.now().subtract(Duration(days: 1))).toString(),
           style: kTextStyleWeather2,
         ),
         SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is though",
            style: kTextStyleSubtitle2b,
          ),
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
