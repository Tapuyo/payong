// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parallax_rain/parallax_rain.dart';
import 'package:payong/models/agri_model.dart';
import 'package:payong/models/daily_model.dart';
import 'package:payong/provider/agri_provider.dart';
import 'package:payong/provider/daily10_provider.dart';
import 'package:payong/provider/daily_provider.dart';
import 'package:payong/routes/routes.dart';
import 'package:payong/services/agri_service.dart';
import 'package:payong/services/daily10_service.dart';
import 'package:payong/services/daily_services.dart';
import 'package:payong/ui/menu_fab/expandable_fab.dart';
import 'package:payong/ui/presentation/10days/10days.dart';
import 'package:payong/ui/presentation/10days/search_list.dart';
import 'package:payong/ui/presentation/agri/agri_advisory.dart';
import 'package:payong/ui/presentation/agri/agri_forecast.dart';
import 'package:payong/ui/presentation/agri/agri_prognosis.dart';
import 'package:payong/ui/presentation/agri/agri_synopsis.dart';
import 'package:payong/ui/presentation/agri10days/agri_advisory10.dart';
import 'package:payong/ui/presentation/agri10days/agri_forecast10.dart';
import 'package:payong/ui/presentation/agri10days/agri_prognosis10.dart';
import 'package:payong/ui/presentation/agri10days/agri_synopsis10.dart';
import 'package:payong/ui/presentation/daily/daily.dart';
import 'package:payong/ui/presentation/mcao/mcao.dart';
import 'package:payong/utils/hex_to_color.dart';
import 'package:payong/utils/themes.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/intl.dart';

class MainNav extends StatefulWidget {
  final int? index;
  const MainNav({required this.index, Key? key}) : super(key: key);

  @override
  State<MainNav> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainNav> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final Key parallax = GlobalKey();
  List<DailyModel> dailyList = [];
  List<AgriModel> agriList = [];
  Set<Polygon> polygons = {};
  List<DateTime> lastDay = [];
  DateTime selectedDate = DateTime.now();
  bool isRefresh = false;
  MapType mapType = MapType.normal;
  String title = 'Philippines';
  double rainDropSpeed = 5;
  bool rainDropShow = false;
  int agriTab = 0;
  bool dayNow = true;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.051436, 122.880019),
    zoom: 5.5,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(11.051436, 122.880019),
      tilt: 59.440717697143555,
      zoom: 5.5);

  int selectIndex = 0;

//11.051436, 122.880019
  @override
  void initState() {
    selectIndex = widget.index!;
    getDataPerModule();
    getPast10Days();
    super.initState();
    if (DateTime.now().hour > 6 && DateTime.now().hour < 18) {
      //evening
      dayNow = false;
    } else {
      //day
      dayNow = false;
    }
  }

  void getDataPerModule() {
    if (selectIndex == 0) {
      getDailyList('daily');
    } else if (selectIndex == 1) {
      getAgriList();
    } else if (selectIndex == 2) {
    } else if (selectIndex == 3) {
      // getAgriList();
    } else if (selectIndex == 4) {
      // getDailyList('month');
    } else {
      // getDailyList('daily');
    }
  }

  Future<void> getAgriList() async {
    await AgriServices.getAgriSypnosis(context);
  }

  Future<void> getDailyList(String mod) async {
    setState(() {
      isRefresh = true;
    });
    final dailyProvider = context.read<DailyProvider>();
    String dt = DateFormat('yyyy-MM-dd').format(selectedDate);
    String optionFilter = 'ActualRainfall';
    if (dailyProvider.option == 'MinTemp') {
      optionFilter = 'MinTemp';
    } else if (dailyProvider.option == 'NormalRainfall') {
      optionFilter = 'NormalRainfall';
    } else if (dailyProvider.option == 'MaxTemp') {
      optionFilter = 'MaxTemp';
    } else if (dailyProvider.option == 'ActualRainfall') {
      optionFilter = 'ActualRainfall';
    } else if (dailyProvider.option == 'RainfallPercent') {
      optionFilter = 'RainfallPercent';
    } else {
      optionFilter = 'ActualRainfall';
    }
    await DailyServices.getDailyList(context, dt, '1', optionFilter);

    dailyProvider.setDateSelect(selectedDate);
    try {
      setState(() {
        polygons.clear();
        title = 'Philippines';
        dailyList = dailyProvider.dailyList;

        for (var name in dailyList) {

          List<dynamic> coordinates = name.locationCoordinate;
          List<LatLng> polygonCoords = [];
          if (coordinates.isNotEmpty) {
            for (var coor in coordinates) {
              var latLng = coor['coordinate'].toString().split(",");
              double latitude = double.parse(latLng[0]);
              double longitude = double.parse(latLng[1]);
              
              polygonCoords.add(LatLng(longitude, latitude));
            }
            Color lxColor = name.rainFallNormalColorCode.toColor();

            if (dailyProvider.option == 'MinTemp') {
              lxColor = name.lowTempColorCode.toColor();
            } else if (dailyProvider.option == 'NormalRainfall') {
              lxColor = name.rainFallNormalColorCode.toColor();
            } else if (dailyProvider.option == 'MaxTemp') {
              lxColor = name.highTempColorCode.toColor();
            } else if (dailyProvider.option == 'ActualRainfall') {
              lxColor = name.rainFallActualColorCode.toColor();
            } else if (dailyProvider.option == 'RainfallPercent') {
              lxColor = name.percentrainFallColorCode.toColor();
            } else {
              lxColor = name.rainFallActualColorCode.toColor();
            }
            print('color: $lxColor');
            polygons.add(Polygon(
                onTap: () {
                  

                  dailyProvider.setDailyId(name.dailyDetailsID);
                },
                consumeTapEvents: true,
                polygonId: PolygonId(name.dailyDetailsID),
                points: polygonCoords,
                strokeWidth: 4,
                fillColor: lxColor.withOpacity(.3),
                strokeColor: lxColor));
          }
          dailyProvider.setPolygonDaiy(polygons);
        }
      });
    } catch (e) {
      print('error $e');
    }
    setState(() {
      isRefresh = false;
    });
  }

  getPast10Days() {
    lastDay.clear();
    if (selectIndex == 0 || selectIndex == 1) {
      for (var i = 2; i > 0; i--) {
        DateTime ndt = DateTime.now().subtract(Duration(days: i));
        lastDay.add(ndt);
      }
    } else {
      for (var i = 1; i < 10; i++) {
        DateTime ndt = DateTime.now().add(Duration(days: i));
        lastDay.add(ndt);
      }
    }

    lastDay.add(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      // title: Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     Text(
      //       title,
      //       style: kTextStyleSubtitle2b,
      //     ),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Text(
      //           '${getMonthString(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year}',
      //           style: TextStyle(fontSize: 12, color: Colors.black38),
      //         ),
      //       ],
      //     )
      //   ],
      // ),
      // leading: IconButton(
      //   icon: const Icon(
      //     Icons.arrow_back_ios,
      //     size: 30,
      //   ),
      //   onPressed: () {
      //     Navigator.of(context).pushReplacementNamed(Routes.mobMain);
      //   },
      // ),
      // actions: [
      //   IconButton(
      //     icon: const Icon(
      //       Icons.help,
      //       size: 30,
      //     ),
      //     onPressed: () {},
      //   )
      // ]),
      body: mainTab(context),
      floatingActionButton: ExpandableFabClass(
        distanceBetween: 150.0,
        subChildren: [
          IconButton(
            iconSize: 70,
            color: kColorBlue,
            onPressed: () => {
              setState(() {
                selectedDate = DateTime.now();
                final dailyProvider = context.read<DailyProvider>();
                dailyProvider.setDateSelect(selectedDate);
                polygons.clear();
                title = 'Philippines';
                selectIndex = 0;
              })
            },
            icon: const Icon(
              Icons.cloud_circle,
              size: 35,
            ),
          ),
          IconButton(
            iconSize: 70,
            color: kColorBlue,
            onPressed: () => {
              setState(() {
                selectedDate = DateTime.now();
                final dailyProvider = context.read<DailyProvider>();
                dailyProvider.setDateSelect(selectedDate);
                polygons.clear();
                title = 'Philippines';
                selectIndex = 1;
              })
            },
            icon: const Icon(Icons.cloud_done, size: 35),
          ),
          IconButton(
            iconSize: 70,
            color: kColorBlue,
            onPressed: () => {
              setState(() {
                selectedDate = DateTime.now();
                final dailyProvider = context.read<DailyProvider>();
                dailyProvider.setDateSelect(selectedDate);
                polygons.clear();
                title = 'Philippines';
                selectIndex = 2;
              })
            },
            icon: const Icon(Icons.cloud_queue, size: 35),
          ),
          IconButton(
            iconSize: 70,
            color: kColorBlue,
            onPressed: () => {
              setState(() {
                selectedDate = DateTime.now();
                final dailyProvider = context.read<DailyProvider>();
                dailyProvider.setDateSelect(selectedDate);
                polygons.clear();
                title = 'Philippines';
                selectIndex = 3;
              })
            },
            icon: const Icon(FontAwesomeIcons.cloudRain, size: 35),
          ),
          IconButton(
            iconSize: 70,
            color: kColorBlue,
            onPressed: () => {
              setState(() {
                selectedDate = DateTime.now();
                final dailyProvider = context.read<DailyProvider>();
                dailyProvider.setDateSelect(selectedDate);
                polygons.clear();
                title = 'Philippines';
                selectIndex = 4;
              })
            },
            icon: const Icon(FontAwesomeIcons.cloudSun, size: 35),
          ),
        ],
      ),
    );
  }

  Widget mainTab(
    BuildContext context,
  ) {
    final now = DateTime.now();
    String formatter = DateFormat('yMd').format(now);
    if (selectIndex == 0) {
      //DAILY WIDGET
      return SlidingUpPanel(
          minHeight: 120,
          maxHeight: MediaQuery.of(context).size.height - 150,
          panel: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [DailyWidget()],
          ),
          body: mapWid());
    } else if (selectIndex == 1) {
      //AGRI WIDGET DAILY
      return SlidingUpPanel(
          minHeight: 0,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          maxHeight: MediaQuery.of(context).size.height - 200,
          panel: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              AgriSynopsisWidget()
              // if(agriTab == 0 || agriTab == 1)...[
              //   //sypnosis
              //   AgriSynopsisWidget()
              // ]else...[
              //  AgriPrognosisWidget(),
              // ]
            ],
          ),
          body: mapWidAgri());
    } else if (selectIndex == 2) {
      //10 DAYS WIDGET
      return SlidingUpPanel(
          minHeight: 120,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          maxHeight: MediaQuery.of(context).size.height - 200,
          panel: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [Daily10Widget()],
          ),
          body: map10Wid()
          );
    } else if (selectIndex == 3) {
      return SlidingUpPanel(
          minHeight: agriTab == 2 ? 120 : 0,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          maxHeight: MediaQuery.of(context).size.height - 200,
          panel: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              if (agriTab == 0 || agriTab == 1) ...[
                //sypnosis
                AgriSynopsis10Widget()
              ] else ...[
                AgriPrognosis10Widget(),
              ]
              // AgriSynopsis10Widget()
            ],
          ),
          body: mapWidAgri10Days());
    } else if (selectIndex == 4) {
      return SlidingUpPanel(
          minHeight: 0,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          maxHeight: MediaQuery.of(context).size.height - 200,
          panel: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
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
                child: Text(
                  "Monthly Monitoring",
                  style: kTextStyleSubtitle2b,
                ),
              ),
            ],
          ),
          body: mCaoWidget());
    } else {
      return SlidingUpPanel(
          minHeight: 120,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          maxHeight: MediaQuery.of(context).size.height - 200,
          panel: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
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
                child: Text(
                  "Daily Monitoring",
                  style: kTextStyleSubtitle2b,
                ),
              ),
            ],
          ),
          body: mapWid());
    }
  }

  Widget mapWidAgri() {
    return Stack(
      children: [
        //tab
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    agriTab = 0;
                  });
                },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: agriTab == 0
                        ? dayNow
                            ? kColorSecondary
                            : kColorBlue
                        : Colors.white,
                  ),
                  height: 35,
                  child: Center(
                    child: Text(
                      'Synopsis',
                      style: kTextStyleSubtitle4b,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    agriTab = 1;
                  });
                },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: agriTab == 1
                        ? dayNow
                            ? kColorSecondary
                            : kColorBlue
                        : Colors.white,
                  ),
                  height: 35,
                  child: Center(
                    child: Text(
                      'Daily Farm',
                      style: kTextStyleSubtitle4b,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    agriTab = 2;
                  });
                },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: agriTab == 2
                        ? dayNow
                            ? kColorSecondary
                            : kColorBlue
                        : Colors.white,
                  ),
                  height: 35,
                  child: Center(
                    child: Text(
                      'Advisory',
                      style: kTextStyleSubtitle4b,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
            child: Column(children: [
              if (agriTab == 0) ...[
                AgriSynopsisWidget()
                //   Container(
                //   height: MediaQuery.of(context).size.height - 200,
                //   width: MediaQuery.of(context).size.width,
                //    child: GoogleMap(
                //                myLocationEnabled: true,
                //                myLocationButtonEnabled: true,
                //                mapType: mapType,
                //                polygons: polygons,
                //                initialCameraPosition: _kGooglePlex,
                //                zoomGesturesEnabled: true,
                //                tiltGesturesEnabled: false,
                //                onMapCreated: (GoogleMapController controller) {
                //     _controller.complete(controller);
                //                },
                //          ),
                //  )
              ] else if (agriTab == 1) ...[
                AgriForecastWidget()
              ] else ...[
                AgriAdvisoryWidget()
              ]
            ]),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(Routes.mobMain);
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
        ),
      ],
    );
  }

  Widget mapWidAgri10Days() {
    return Stack(
      children: [
        //tab
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    agriTab = 0;
                  });
                },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: agriTab == 0
                        ? dayNow
                            ? kColorSecondary
                            : kColorBlue
                        : Colors.white,
                  ),
                  height: 35,
                  child: Center(
                    child: Text(
                      'Forecast',
                      style: kTextStyleSubtitle4b,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    agriTab = 1;
                  });
                },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: agriTab == 1
                        ? dayNow
                            ? kColorSecondary
                            : kColorBlue
                        : Colors.white,
                  ),
                  height: 35,
                  child: Center(
                    child: Text(
                      'Advisory',
                      style: kTextStyleSubtitle4b,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    agriTab = 2;
                  });
                },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: agriTab == 2
                        ? dayNow
                            ? kColorSecondary
                            : kColorBlue
                        : Colors.white,
                  ),
                  height: 35,
                  child: Center(
                    child: Text(
                      'Croponology',
                      style: kTextStyleSubtitle4b,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
            child: Column(children: [
              if (agriTab == 2) ...[
                // AgriPrognosis10Widget()
                Container(
                  height: MediaQuery.of(context).size.height - 200,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    mapType: mapType,
                    polygons: polygons,
                    initialCameraPosition: _kGooglePlex,
                    zoomGesturesEnabled: true,
                    tiltGesturesEnabled: false,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                )
              ] else if (agriTab == 1) ...[
                AgriAdvisory10Widget()
              ] else ...[
                AgriForecast10Widget()
              ]
            ]),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(Routes.mobMain);
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
        ),
      ],
    );
  }

  Widget mCaoWidget() {
    return Stack(
      children: [
        mCaOPage(),
        Visibility(
          visible: rainDropShow,
          child: IgnorePointer(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ParallaxRain(
                // ignore: prefer_const_literals_to_create_immutables
                dropColors: [Colors.white],
                trail: true,
                dropFallSpeed: rainDropSpeed,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 20, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(Routes.mobMain);
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
                  child: Icon(Icons.help),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(Routes.mobMain);
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
        ),
      ],
    );
  }

  Widget map10Wid() {
    final dailyProvider = context.read<DailyProvider>().polygons;
    return Stack(
      children: [
        Align(
          child: Column(children: [
            Padding(padding: EdgeInsets.fromLTRB(10, 100, 10, 0),
            child: TextField(
              style: TextStyle(color: Colors.black),
                onChanged: (value)async{
                              final dailyProvider = context.read<Daily10Provider>();
                              dailyProvider.setSearchString(value);
                              await Daily10Services.get10DaysSearch(context, value);
                           },
                    decoration: InputDecoration(
                    hintText: "Search Location",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                     borderRadius:
                    BorderRadius.all(Radius.circular(7.0)),
                              ),
                            ),
                          ),),
              SearchList()
          ]),
        ),
        Visibility(
          visible: rainDropShow,
          child: IgnorePointer(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ParallaxRain(
                // ignore: prefer_const_literals_to_create_immutables
                dropColors: [Colors.white],
                trail: true,
                dropFallSpeed: rainDropSpeed,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 20, 0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 290,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              final dailyProvider =
                                  context.read<DailyProvider>();
                              dailyProvider.setOption('ActualRainfall');
                              getDailyList('daily');
                              Navigator.pop(context);
                            },
                            child: ColoredBox(
                              color: kColorBlue,
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 10,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    'Actual Rainfall',
                                    style: buttonStyleWhiet,
                                  ))),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              final dailyProvider =
                                  context.read<DailyProvider>();
                              dailyProvider.setOption('NormalRainfall');
                              getDailyList('daily');
                              Navigator.pop(context);
                            },
                            child: ColoredBox(
                              color: kColorBlue,
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 10,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    'Normal Rainfall',
                                    style: buttonStyleWhiet,
                                  ))),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              final dailyProvider =
                                  context.read<DailyProvider>();
                              dailyProvider.setOption('RainfallPercent');
                              getDailyList('daily');
                              Navigator.pop(context);
                            },
                            child: ColoredBox(
                              color: kColorBlue,
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 10,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    'Rainfall Percent',
                                    style: buttonStyleWhiet,
                                  ))),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              final dailyProvider =
                                  context.read<DailyProvider>();
                              dailyProvider.setOption('MaxTemp');
                              getDailyList('daily');
                              Navigator.pop(context);
                            },
                            child: ColoredBox(
                              color: kColorBlue,
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 10,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    'Max Temperature',
                                    style: buttonStyleWhiet,
                                  ))),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              final dailyProvider =
                                  context.read<DailyProvider>();
                              dailyProvider.setOption('MinTemp');
                              getDailyList('daily');
                              Navigator.pop(context);
                            },
                            child: ColoredBox(
                              color: kColorBlue,
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 10,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    'Minimum Temperature',
                                    style: buttonStyleWhiet,
                                  ))),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
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
                  child: Icon(Icons.help),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(Routes.mobMain);
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
        ),
        
        if (isRefresh)
          Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
      
      ],
    );
  }

  Widget mapWid() {
    final dailyProvider = context.read<DailyProvider>().polygons;
    return Stack(
      children: [
        GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: mapType,
          polygons: dailyProvider!,
          initialCameraPosition: _kGooglePlex,
          zoomGesturesEnabled: true,
          tiltGesturesEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        Visibility(
          visible: rainDropShow,
          child: IgnorePointer(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ParallaxRain(
                // ignore: prefer_const_literals_to_create_immutables
                dropColors: [Colors.white],
                trail: true,
                dropFallSpeed: rainDropSpeed,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 20, 0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 290,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              final dailyProvider =
                                  context.read<DailyProvider>();
                              dailyProvider.setOption('ActualRainfall');
                              getDailyList('daily');
                              Navigator.pop(context);
                            },
                            child: ColoredBox(
                              color: kColorBlue,
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 10,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    'Actual Rainfall',
                                    style: buttonStyleWhiet,
                                  ))),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              final dailyProvider =
                                  context.read<DailyProvider>();
                              dailyProvider.setOption('NormalRainfall');
                              getDailyList('daily');
                              Navigator.pop(context);
                            },
                            child: ColoredBox(
                              color: kColorBlue,
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 10,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    'Normal Rainfall',
                                    style: buttonStyleWhiet,
                                  ))),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              final dailyProvider =
                                  context.read<DailyProvider>();
                              dailyProvider.setOption('RainfallPercent');
                              getDailyList('daily');
                              Navigator.pop(context);
                            },
                            child: ColoredBox(
                              color: kColorBlue,
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 10,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    'Rainfall Percent',
                                    style: buttonStyleWhiet,
                                  ))),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              final dailyProvider =
                                  context.read<DailyProvider>();
                              dailyProvider.setOption('MaxTemp');
                              getDailyList('daily');
                              Navigator.pop(context);
                            },
                            child: ColoredBox(
                              color: kColorBlue,
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 10,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    'Max Temperature',
                                    style: buttonStyleWhiet,
                                  ))),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              final dailyProvider =
                                  context.read<DailyProvider>();
                              dailyProvider.setOption('MinTemp');
                              getDailyList('daily');
                              Navigator.pop(context);
                            },
                            child: ColoredBox(
                              color: kColorBlue,
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 10,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    'Minimum Temperature',
                                    style: buttonStyleWhiet,
                                  ))),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
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
                  child: Icon(Icons.help),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(Routes.mobMain);
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
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: selectIndex != 0
                ? EdgeInsets.fromLTRB(20, 0, 0, 230)
                : EdgeInsets.fromLTRB(20, 0, 0, 140),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      mapType = MapType.normal;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: mapType == MapType.normal
                          ? Colors.white.withOpacity(.8)
                          : Colors.white.withOpacity(.4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'Normal',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
              SizedBox(
                width: 12,
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      mapType = MapType.hybrid;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: mapType == MapType.hybrid
                          ? Colors.white.withOpacity(.8)
                          : Colors.white.withOpacity(.4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'Hybrid',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
              SizedBox(
                width: 12,
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      mapType = MapType.satellite;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: mapType == MapType.satellite
                          ? Colors.white.withOpacity(.8)
                          : Colors.white.withOpacity(.4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'Satellite',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
            ]),
          ),
        ),
        if (isRefresh)
          Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        if (selectIndex == 1 || selectIndex == 2 || selectIndex == 3)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 140),
              child: display10DaysWidget(),
            ),
          )
      ],
    );
  }

  Widget display10DaysWidget() {
    return SizedBox(
      height: 80.0,
      child: ListView(scrollDirection: Axis.horizontal, children: <Widget>[
        for (var item in lastDay.reversed.toList())
          GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = item;
                getDailyList('10days');
              });
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Container(
                width: 120,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17.0),
                  color: selectedDate == item
                      ? Colors.white.withOpacity(.8)
                      : Colors.white.withOpacity(.4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text(
                          '${getMonthString(item.month)} ${item.year}',
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          getFormatedDay(item, 'name'),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(getFormatedDay(item, 'Day')),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
      ]),
    );
  }

  static String getFormatedDay(DateTime? date, String nameOnly) {
    if (nameOnly == 'Day') {
      return date != null ? DateFormat('EEEE').format(date) : '';
    } else if (nameOnly == 'MonthYear') {
      return date != null ? DateFormat('MM, yyyy').format(date) : '';
    } else {
      return date != null ? DateFormat('d').format(date) : '';
    }
  }

  String getMonthString(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug.';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return 'Err';
    }
  }
}
