// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parallax_rain/parallax_rain.dart';
import 'package:payong/models/agri_10_days_forecast.dart';
import 'package:payong/models/agri_10_forecast_model.dart';
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
CarouselController buttonCarouselController = CarouselController();
List<String> tb = ['Weather', 'Condition'];

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
    final agri = useState<List<AgriRegionalForecast>>([]);
    final String backImg =
        context.select((InitProvider p) => p.backImgAssetUrl);
    final bool withRain = context.select((InitProvider p) => p.withRain);
    useEffect(() {
      Future.microtask(() async {
        agri.value = await AgriServices.getAgri10DaysRegional(context, id);
        // await AgriServices.getAgri10Days(context, id);
      });
      return;
    }, const []);
    print(agri.value);
    return agri.value.isNotEmpty
        ? loadDetails(
            context, isScrollControlled, agriTab, agri.value, backImg, withRain)
        : SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  loadDetails(
      BuildContext context,
      ValueNotifier isScrollControlled,
      ValueNotifier agriTab,
      List<AgriRegionalForecast> agri,
      String backImg,
      bool withRain) {
    print(agri.last.content);
    return SingleChildScrollView(
      child: Container(
        child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Image.asset(backImg),
                ),
              ),
              if (withRain)
                ParallaxRain(
                  // ignore: prefer_const_literals_to_create_immutables
                  dropColors: [Colors.white],
                  trail: true,
                  dropFallSpeed: 5,
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 150,
                  child: ListView(
                    children: [
                      CarouselSlider(
                        carouselController: buttonCarouselController,
                        options: CarouselOptions(
                            onPageChanged: (value, val) {
                              // carouselInt.value = value;
                            },
                            height: MediaQuery.of(context).size.height - 300,
                            viewportFraction: .9,
                            autoPlay: false,
                            enlargeFactor: .4),
                        items: tb.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                child: Column(
                                  children: [
                                    if (i == 'Weather') ...{
                                      weatherWidget(context, isScrollControlled,
                                          agriTab, agri)
                                    } else ...{
                                      weatherConditionWidget(context, agri),
                                      // windWidget(context, agri),
                                      // galeWidget(context, agri),
                                      // ensoWidget(context, agri),
                                      // weatherWidget(context, isScrollControlled,
                                      //     agriTab, agri)
                                    }
                                  ],
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     GestureDetector(
                      //       onTap: () {
                      //         buttonCarouselController.nextPage(
                      //             duration: Duration(milliseconds: 100),
                      //             curve: Curves.linear);
                      //       },
                      //       child: Container(
                      //         width: 125,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(10),
                      //           color: kColorBlue,
                      //         ),
                      //         height: 35,
                      //         child: Center(
                      //           child: Text(
                      //             'Next',
                      //             style: kTextStyleSubtitle4b,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
    //   },
    // );
  }

  Container weatherWidget(
      BuildContext context,
      ValueNotifier<dynamic> isScrollControlled,
      ValueNotifier<dynamic> agriTab,
      List<AgriRegionalForecast> agri) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 300,
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 30, 10),
                  child: InkResponse(
                    onTap: () {
                      loadMap(context, '', isScrollControlled, agriTab, agri);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        FontAwesomeIcons.mapLocation,
                        color: Colors.black,
                      ),
                    ),
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: kColorBlue.withOpacity(.5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Weather systems that will likely affected the whole country',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                    width: MediaQuery.of(context).size.width,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      scrollDirection: Axis.horizontal,
                      itemCount: agri.last.weatherSystem.length,
                      itemBuilder: (context, i) {
                        return Column(
                          children: [
                            SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.network(
                                    agri.last.weatherSystem[i].icon)),
                            SizedBox(
                              width: 200,
                              child: Text(
                                agri.last.weatherSystem[i].name,
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 20, 0, 0),
                                            child: GestureDetector(
                                              onTap: () {
                                                isScrollControlled.value =
                                                    false;
                                                Navigator.pop(context);
                                                isScrollControlled.value = true;
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
                                                  child: Icon(Icons
                                                      .arrow_downward_rounded),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white60,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.black)),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      165, 70, 238, 1),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10)),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    agri.last.title,
                                                    style: GoogleFonts.roboto(
                                                        textStyle:
                                                            const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: 'NunitoSans',
                                                    )),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    250,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: ListView(children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      agri.last.content,
                                                      style: GoogleFonts.roboto(
                                                          textStyle:
                                                              const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily:
                                                            'NunitoSans',
                                                      )),
                                                    ),
                                                  ),
                                                ]),
                                              ),
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
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                            child: Center(
                              child: Text(
                                'Read more',
                                style:
                                    TextStyle(color: kColorBlue, fontSize: 16),
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
          // windWidget(context),
          // galeWidget(context),
          // ensoWidget(context),
        ],
      ),
    );
  }

  Padding ensoWidget(BuildContext context, List<AgriRegionalForecast> agri) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.white70),
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
                          child: Image.asset('assets/windicon.png')),
                      Text(
                        'ENSO Alert',
                        style: TextStyle(color: Colors.black),
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
                        onTap: () {
                          loadReadmore(
                              context, agri.last.enso.last.description);
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
                                style:
                                    TextStyle(color: kColorBlue, fontSize: 16),
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
    );
  }

  Padding weatherConditionWidget(
      BuildContext context, List<AgriRegionalForecast> agri) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 400,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: kColorBlue.withOpacity(.5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (agri.last.weatherCondition.isNotEmpty) 
                  GestureDetector(
                    onTap: () {
                      if (agri.last.weatherCondition.isNotEmpty) {
                        loadReadmore(context,
                            '${agri.last.weatherCondition.last.location} }');
                      }
                    },
                    child: Column(
                      children: [
                        if (agri.last.weatherCondition.isNotEmpty)
                          SizedBox(
                              width: 80,
                              height: 80,
                              child: Image.network(
                                  agri.last.weatherCondition.last.icon)),
                        Text(
                          'Weather Condition',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  if (agri.last.windCondition.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        if (agri.last.windCondition.isNotEmpty) {
                          loadReadmore(context,
                              agri.last.windCondition.last.description);
                        }
                      },
                      child: Column(
                        children: [
                          if (agri.last.weatherCondition.isNotEmpty)
                            SizedBox(
                                width: 80,
                                height: 80,
                                child: Image.network(
                                    agri.last.windCondition.last.icon)),
                          Text(
                            'Wind',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (agri.last.galeWarning.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        if (agri.last.galeWarning.isNotEmpty) {
                          loadReadmore(context,
                              '${agri.last.galeWarning.last.description} }');
                        }
                      },
                      child: Column(
                        children: [
                          if (agri.last.galeWarning.isNotEmpty)
                            SizedBox(
                                width: 80,
                                height: 80,
                                child: Image.network(
                                    agri.last.galeWarning.last.icon)),
                          Text(
                            'Sea Condition',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  if (agri.last.enso.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        if (agri.last.enso.isNotEmpty) {
                          loadReadmore(
                              context, agri.last.enso.last.description);
                        }
                      },
                      child: Column(
                        children: [
                          if (agri.last.enso.isNotEmpty)
                            SizedBox(
                                width: 80,
                                height: 80,
                                child: agri.last.enso.last.icon.isNotEmpty
                                    ? Image.network(agri.last.enso.last.icon)
                                    : Image.asset('assets/windicon.png')),
                          Text(
                            'ENSO Alert',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                fit: BoxFit.fitHeight,
                child: Image.asset('assets/manila.jpeg'),
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
                  color: Colors.transparent,
                  child: Text(
                    content,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ]),
        );
      },
    );
  }

  loadMap(
      BuildContext context,
      String content,
      ValueNotifier isScrollControlled,
      ValueNotifier agriTab,
      List<AgriRegionalForecast> agri) {
    String normalRainfallImage = '';
    String actualRainfallImage = '';

    print(agri.last.map.last.description);

    for (var i = 0; i < agri.last.map.length; i++) {
      if (agri.last.map[i].description == 'ACTUAL RAINFALL') {
        normalRainfallImage = agri.last.map[i].map;
      } else {
        actualRainfallImage = agri.last.map[i].map;
      }
    }

    return showModalBottomSheet<void>(
      isScrollControlled: isScrollControlled.value,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: SingleChildScrollView(
                child: Stack(children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Image.asset('assets/manila.jpeg'),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: ColoredBox(color: Colors.white54),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
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
                              child: Icon(Icons.arrow_downward_rounded),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: ColoredBox(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      agriTab.value = 0;
                                    });
                                  },
                                  child: Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: agriTab.value == 0
                                          ? dayNow
                                              ? kColorSecondary
                                              : kColorBlue
                                          : Colors.white,
                                    ),
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        'Actual Rainfall',
                                        style: kTextStyleSubtitle4b,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      agriTab.value = 1;
                                    });
                                  },
                                  child: Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: agriTab.value == 1
                                          ? dayNow
                                              ? kColorSecondary
                                              : kColorBlue
                                          : Colors.white,
                                    ),
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        'Forecast Rainfall',
                                        style: kTextStyleSubtitle4b,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            agriTab.value == 1
                                ? Container(
                                    color: Colors.white70,
                                    child: Image.network(actualRainfallImage,
                                        width:
                                            MediaQuery.of(context).size.width),
                                  )
                                : Container(
                                    color: Colors.white70,
                                    child: Image.network(normalRainfallImage,
                                        width:
                                            MediaQuery.of(context).size.width),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            );
          },
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
