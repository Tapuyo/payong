// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payong/models/agri_10_prognosis.dart';
import 'package:payong/models/daily_model.dart';
import 'package:payong/provider/agri_provider.dart';
import 'package:payong/provider/daily10_provider.dart';
import 'package:payong/provider/daily_provider.dart';
import 'package:payong/provider/init_provider.dart';
import 'package:payong/services/agri_service.dart';
import 'package:payong/services/daily_services.dart';
import 'package:payong/utils/hex_to_color.dart';
import 'package:payong/utils/themes.dart';
import 'package:provider/provider.dart';

bool dayNow = true;

class AgriPrognosis10Widget extends HookWidget {
  const AgriPrognosis10Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rainFallColorCode = useState('#3d85c6');
    final rainFallPercentageColorCode = useState('#3d85c6');
    final lowTemp = useState('0');
    final lowTempColorCode = useState('#3d85c6');
    final highTemp = useState('0');
    final highTempColorCode = useState('#3d85c6');
    final selectIndex = useState<int>(0);
    final showExpand = useState<bool>(false);
    // final dailyDetails = useState<List<Agri10Prognosis>>([]);

    final bool isRefresh = context.select((DailyProvider p) => p.isRefresh);
    final id = useState(context.select((AgriProvider p) => p.progID));
    final String? locId = context.select((InitProvider p) => p.myLocationId);
    ValueNotifier soilCondition = useState('');
    final List<Agri10Prognosis> dailyDetails =
        context.select((AgriProvider p) => p.progList);
    useEffect(() {
      Future.microtask(() async {
        await AgriServices.getProgDetails(context, id.value);
      });
      return;
    }, [id.value]);

    return Container(
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
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.arrow_upward, color: Colors.white,),
              SizedBox(width: 12,),
              Column(
                children: [
                  Text(
                    "REGIONAL AGROMETEOROLOGICAL\n SITUATION AND PROGNOSIS",
                    style: kTextStyleSubtitle4,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Divider(),
        ),
        if (dailyDetails.isNotEmpty && dailyDetails != [])
          Expanded(
              child: listPrognosis(
                  context, dailyDetails, showExpand, soilCondition)),
        // Expanded(child: listPrognosis('Region 2', showExpand))
      ]),
    );
  }

  Widget listPrognosis(BuildContext context, List<Agri10Prognosis> dailyDetails,
      ValueNotifier showExpand, ValueNotifier soilCondition) {
         final String backImg =
        context.select((InitProvider p) => p.backImgAssetUrl);
    String tempe = '';
    if (dailyDetails.last.temp.isNotEmpty) {
      for (var u in dailyDetails.last.temp) {
        tempe = tempe + ' ' + u.temperatureDetails;
      }
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
      child: ListView(
        // physics: NeverScrollableScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                child: Text(
                  dailyDetails.last.regionDescription,
                  style: kTextStyleSubtitle4,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  '  No. of Rainy Days: ${dailyDetails.last.rainyDays}',
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
                  ' Relative Humidity (%): ${dailyDetails.last.relativeHumidity}',
                  style: kTextStyleWeather3,
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 8,
            ),
    
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  'Soil Condition',
                  style: kTextStyleWeather3,
                ),
              ],
            ),
    
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  'Wet area: ${dailyDetails.last.wetSoilLocation}',
                  style: kTextStyleWeather3,
                ),
              ],
            ),
            // SizedBox(
            //     width: 70,
            //     height: 70,
            //     child: Image.network(dailyDetails.last.moistIcon)),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  'Moist area: ${dailyDetails.last.moistSoilLocation}',
                  style: kTextStyleWeather3,
                ),
              ],
            ),
            // SizedBox(
            //     width: 70,
            //     height: 70,
            //     child: Image.network(dailyDetails.last.dryIcon)),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  'Dry area: ${dailyDetails.last.drySoilLocation}',
                  style: kTextStyleWeather3,
                ),
              ],
            ),
            // SizedBox(
            //     width: 70,
            //     height: 70,
            //     child: Image.network(dailyDetails.last.wetIcon)),
            // cloudIcons('CLOUDY'),
            SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                   mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Forecast Rainfall',
                      style: kTextStyleWeather3,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${dailyDetails.last.rainFall}mm',
                          style: kTextStyleWeather3,textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Column(
                   mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Temperature',
                      style: kTextStyleWeather3,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$tempe°C',
                          style: kTextStyleWeather3,
                        ),
                        // Text(
                        //   '°',
                        //   style: kTextStyleDeg,
                        // ),
                      ],
                    ),
                  ],
                )
              ],
            ),
    
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Crop Phenology, Situation and Farm Activities',
                    style: kTextStyleWeather3,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return FractionallySizedBox(
                            heightFactor: 0.9,
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height - 150,
                                  child: FittedBox(
                                    child: Image.asset(backImg),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 50, 0, 0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.white,
                                                        spreadRadius: 3),
                                                  ],
                                                ),
                                                height: 40,
                                                width: 40,
                                                child: Center(
                                                  child:
                                                      Icon(Icons.arrow_back_ios),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:  EdgeInsets.all(20.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                    color: kColorBlue.withOpacity(.5),
                                                  boxShadow: [
                                                    const BoxShadow(
                                                        color: kColorBlue,
                                                        spreadRadius: 3),
                                                  ],
                                                ),
                                        
                                          child: Padding(
                                            padding:  EdgeInsets.fromLTRB(
                                                20, 20, 20, 20),
                                            child: Text(
                                              dailyDetails.last.content,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Container(
                    // width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    height: 35,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: Center(
                        child: Text(
                          'Read more',
                          style: TextStyle(color: kColorBlue, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            // if (showExpand.value)
            //   Padding(
            //     padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            //     child: Text(
            //       'Upland and rainfed rice are still in harvesting stage. Some lowland and irrigated farms are still transplanting rice for third cropping while others are in harvesting stage. Other rice are still in vegetative stage. Corn are still in reproductive and harvesting stages while some corn are in vegetative stage. Planting of ampalaya, cowpea, eggplant, kangkong, lettuce, mustard, okra, pechay, string bean, patola, mungbean, and peanut is being done. Growing of tobacco continues. Harvesting of sweet corn, pepper, tomato, carrot, garlic, chili, mushroom, cabbage, onion, carrot, Chinese cabbage, tomato, pechay, squash, string bean, okra, tobacco, peanut, banana, mango, and other seasonal fruits and leafy vegetables is in progress. Fertilizer application and land preparation are still ongoing.',
            //       style: kTextStyleWeather3,
            //     ),
            //   ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Divider(),
            ),
    
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            //   child: Divider(),
            // ),
          ]),
        ],
      ),
    );
  }
}
