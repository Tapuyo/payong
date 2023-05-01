// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payong/models/agri_10_days_forecast.dart';
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

class AgriForecast10Widget extends HookWidget {
  const AgriForecast10Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final agriTab = useState(0);
    ValueNotifier isScrollControlled = useState<bool>(true);
    ValueNotifier mapAsset = useState('assets/map11.png');
    if (DateTime.now().hour > 6 && DateTime.now().hour < 18) {
      //evening
      dayNow = false;
    } else {
      //day
      dayNow = false;
    }

    final bool isRefresh = context.select((AgriProvider p) => p.isRefresh);
    final String id = context.select((AgriProvider p) => p.dailyIDSelected);
    final List<Agri10DaysForecastvModel>? dailyAgriDetails =
        context.select((AgriProvider p) => p.agri10Forecasts);
    useEffect(() {
      Future.microtask(() async {
        await AgriServices.getAgri10Days(context, id);
      });
      return;
    }, const []);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () async {
                    agriTab.value = 0;
                    mapAsset.value = 'assets/map11.png';
                  },
                  child: Container(
                    // width: 80,
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
                        'Actual Rainfall',
                        style: kTextStyleSubtitle4b,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () async {
                    agriTab.value = 1;
                    mapAsset.value = 'assets/map11.png';
                  },
                  child: Container(
                    // width: 120,
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
                        'Normal Rainfall',
                        style: kTextStyleSubtitle4b,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: GestureDetector(
            onTap: () {
              loadDetails(context, isScrollControlled);
            },
            child: Center(child: Image.asset(mapAsset.value)),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                loadDetails(context, isScrollControlled);
              },
              child: Container(
                // width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kColorBlue,
                ),
                height: 35,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: Center(
                    child: Text(
                      'See details',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  loadDetails(BuildContext context, ValueNotifier isScrollControlled) {
    return showModalBottomSheet<void>(
      isScrollControlled: isScrollControlled.value,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            child: Stack(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height + 200,
                    child: FittedBox(
                      child: Image.asset('assets/manila.jpeg'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
                        child: GestureDetector(
                          onTap: () {
                            isScrollControlled.value = false;
                            Navigator.pop(context);
                            isScrollControlled.value = true;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.white, spreadRadius: 3),
                              ],
                            ),
                            height: 40,
                            width: 40,
                            child: Center(
                              child: Icon(Icons.arrow_back_ios),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                                // ignore: prefer_const_literals_to_create_immutables
                                colors: [
                                  Color(0xFF005EEB),
                                  Color(0xFF489E59),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                tileMode: TileMode.clamp),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Weather systems that will likely affected the whole country',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Image.asset(
                                              'assets/waetherforecast1.png')),
                                      Text(
                                        'NORTHEAST\nMONSOON',
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Image.asset(
                                              'assets/weatherforecast2.png')),
                                      Text(
                                        'SHEARLINE',
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Image.asset(
                                              'assets/weatherforecast3.png')),
                                      Text(
                                        'LOW\nPREASURE\nAREA(LPA)',
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                20, 20, 0, 0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            isScrollControlled
                                                                .value = false;
                                                            Navigator.pop(
                                                                context);
                                                            isScrollControlled
                                                                .value = true;
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          18),
                                                              color:
                                                                  Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .white,
                                                                    spreadRadius:
                                                                        3),
                                                              ],
                                                            ),
                                                            height: 40,
                                                            width: 40,
                                                            child: Center(
                                                              child: Icon(Icons
                                                                  .arrow_downward_rounded),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        20, 10, 20, 10),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white60,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black)),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      165,
                                                                      70,
                                                                      238,
                                                                      1),
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10)),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                'Cloudy Skies with light rains due to NE monsoon',
                                                                style: GoogleFonts
                                                                    .roboto(
                                                                        textStyle:
                                                                            const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      'NunitoSans',
                                                                )),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                    child:
                                                                        Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.fromLTRB(
                                                                              8,
                                                                              0,
                                                                              8,
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        'Cagayan Valley Aurora, Rizal',
                                                                        style:
                                                                            kTextStyleSubtitle4b,
                                                                      ),
                                                                    )
                                                                  ],
                                                                )),
                                                                Expanded(
                                                                  child: SizedBox(
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                      child: Image
                                                                          .asset(
                                                                              'assets/cloudy_rain.png')),
                                                                )
                                                              ]),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        20, 10, 20, 10),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white60,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black)),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      165,
                                                                      70,
                                                                      238,
                                                                      1),
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10)),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                'Cloudy with scattered rain',
                                                                style: GoogleFonts
                                                                    .roboto(
                                                                        textStyle:
                                                                            const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      'NunitoSans',
                                                                )),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                    child:
                                                                        Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.fromLTRB(
                                                                              8,
                                                                              0,
                                                                              8,
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        'Eastern Visayas',
                                                                        style:
                                                                            kTextStyleSubtitle4b,
                                                                      ),
                                                                    )
                                                                  ],
                                                                )),
                                                                Expanded(
                                                                  child: SizedBox(
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                      child: Image
                                                                          .asset(
                                                                              'assets/cloudy.png')),
                                                                )
                                                              ]),
                                                        ],
                                                      ),
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
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 8, 20, 8),
                                        child: Center(
                                          child: Text(
                                            'Read more',
                                            style: TextStyle(
                                                color: kColorBlue,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                                // ignore: prefer_const_literals_to_create_immutables
                                colors: [
                                  Color(0xFF005EEB),
                                  Color(0xFF489E59),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                tileMode: TileMode.clamp),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: Image.asset(
                                                'assets/windicon.png')),
                                        Text(
                                          'WIND',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Generally northeast to east over \nthe rest of the country during \nthe forecast period',
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            loadReadmore(context, 'Generally northeast to east over the rest of the country during the forecast period');
                                          },
                                          child: Container(
                                            // width: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            height: 35,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 8, 20, 8),
                                              child: Center(
                                                child: Text(
                                                  'Read more',
                                                  style: TextStyle(
                                                      color: kColorBlue,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                                // ignore: prefer_const_literals_to_create_immutables
                                colors: [
                                  Color(0xFF005EEB),
                                  Color(0xFF489E59),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                tileMode: TileMode.clamp),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: Image.asset(
                                                'assets/galeicon.png')),
                                        Text(
                                          'GALE',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'moderate \nto \nrough',
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'slight \nto \nrough',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Western and northern \nseaboard  of northern\n luzon and the\n eastern seaboard\n of the country',
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'The rest of the country',
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            loadReadmore(context, 'Western and northern seaboard  of northern luzon and the eastern seaboard of the country');
                                          },
                                          child: Container(
                                            // width: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            height: 35,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 8, 20, 8),
                                              child: Center(
                                                child: Text(
                                                  'Read more',
                                                  style: TextStyle(
                                                      color: kColorBlue,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                                // ignore: prefer_const_literals_to_create_immutables
                                colors: [
                                  Color(0xFF005EEB),
                                  Color(0xFF489E59),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                tileMode: TileMode.clamp),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: Image.asset(
                                                'assets/windicon.png')),
                                        Text(
                                          'ENSO Alert System Status',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            loadReadmore(context, 'La Niña still continues to weaken and transition to ENSO-neutral conditions during February-March-April (FMA) 2023 season is expected. La Nina increases the likelihood of having above normal rainfall conditions that could lead to potential adverse impacts (such as heavy rainfall,floods, flashfloods and landslides) over highly vulnerable areas.');
                                          },
                                          child: Container(
                                            // width: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            height: 35,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 8, 20, 8),
                                              child: Center(
                                                child: Text(
                                                  'Read more',
                                                  style: TextStyle(
                                                      color: kColorBlue,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // WidgetBody(context, dailyAgriDetails!)
                    ],
                  ),
                ]),
          ),
        );
      },
    );
  }

  WidgetBody(
      BuildContext context, List<Agri10DaysForecastvModel> dailyAgriDetails) {
    return dailyAgriDetails != null
        ? SizedBox(
            height: MediaQuery.of(context).size.height - 180,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height + 100,
                        child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 500),
                          scrollDirection: Axis.vertical,
                          itemCount: dailyAgriDetails.length,
                          itemBuilder: (context, index) {
                            return foreCastWidget(
                                context, dailyAgriDetails[index]);
                          },
                        ),
                      ),
                    ]),
              ),
            ),
          )
        : SizedBox();
  }

  loadReadmore(BuildContext context, String content) {
    return showModalBottomSheet<void>(
      isScrollControlled: false,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Stack(children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: FittedBox(
                child: Image.asset('assets/manila.jpeg'),
                fit: BoxFit.fitHeight,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ColoredBox(color: Colors.white54),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ColoredBox(
                  color: Colors.white54,
                  child: Text(content, style: TextStyle(color: Colors.black),),
                ),
              ),
            ),
          ]),
        );
      },
    );
  }

  Widget foreCastWidget(
      BuildContext context, Agri10DaysForecastvModel? agriForecastModel) {
    DateTime pubDate =
        DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
    final String publishDate = DateFormat.yMMMMd('en_US').format(pubDate);
    return agriForecastModel != null
        ? Column(children: [
            // Divider(
            //   thickness: 3,
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Publish date ${publishDate.toString()}',
                style: kTextStyleSubtitle4b,
              ),
            ),
            Divider(
              thickness: 3,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        agriForecastModel.title,
                        style: kTextStyleSubtitle4b,
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 50,
                        // height: MediaQuery.of(context).size.height - 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Html(
                            shrinkWrap: false,
                            data: agriForecastModel.content,
                          ),
                        ),
                      )
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
