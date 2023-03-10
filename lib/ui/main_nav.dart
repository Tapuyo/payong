// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parallax_rain/parallax_rain.dart';
import 'package:payong/models/agri_model.dart';
import 'package:payong/models/daily_model.dart';
import 'package:payong/provider/agri_provider.dart';
import 'package:payong/provider/daily_provider.dart';
import 'package:payong/routes/routes.dart';
import 'package:payong/services/agri_service.dart';
import 'package:payong/services/daily_services.dart';
import 'package:payong/ui/menu_fab/expandable_fab.dart';
import 'package:payong/ui/presentation/10days/10days.dart';
import 'package:payong/ui/presentation/agi10days/agridays.dart';
import 'package:payong/ui/presentation/daily/daily.dart';
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
  MapType mapType = MapType.hybrid;
  String title = 'Philippines';
  double rainDropSpeed = 5;
  bool rainDropShow = false;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.051436, 122.880019),
    zoom: 6,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(11.051436, 122.880019),
      tilt: 59.440717697143555,
      zoom: 6);

  int selectIndex = 0;
  late MapController controller = MapController(
    initPosition: GeoPoint(latitude: 11.051436, longitude: 122.880019),
    initMapWithUserPosition: false,
  );

//11.051436, 122.880019
  @override
  void initState() {
    selectIndex = widget.index!;
    controller = MapController(
      initPosition: GeoPoint(latitude: 11.051436, longitude: 122.880019),
      initMapWithUserPosition: false,
    );
    getDataPerModule();
    getPast10Days();
    super.initState();
  }

  void getDataPerModule() {
    if (selectIndex == 0) {
      getDailyList('daily');
    } else if (selectIndex == 1) {
      getAgriList();
    } else if (selectIndex == 2) {
      getDailyList('10days');
    } else if (selectIndex == 3) {
    } else if (selectIndex == 4) {
      getDailyList('month');
    } else {
      getDailyList('daily');
    }
  }

  Future<void> getAgriList() async {
    setState(() {
      isRefresh = true;
    });
    String dt = DateFormat('yyyy-MM-dd').format(selectedDate);
    await AgriServices.getAgriList(context, dt);
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setDateSelect(selectedDate);
    setState(() {
      polygons.clear();
      title = 'Philippines';
      agriList = dailyProvider.dailyList;

      for (var name in agriList) {
        List<dynamic> coordinates = name.locationCoordinate;
        List<LatLng> polygonCoords = [];
        for (var coor in coordinates) {
          var latLng = coor['coordinate'].toString().split(",");
          double latitude = double.parse(latLng[0]);
          double longitude = double.parse(latLng[1]);
          polygonCoords.add(LatLng(latitude, longitude));
        }
        polygons.add(Polygon(
            onTap: () {
              setState(() {
                title = name.locationDescription;
                if (double.parse(name.rainFallFrom) >= 50) {
                  rainDropShow = true;
                  if (double.parse(name.rainFallFrom) > 50) {
                    rainDropSpeed = 2;
                  } else if (double.parse(name.rainFallFrom) > 70) {
                    rainDropSpeed = 5;
                  } else if (double.parse(name.rainFallFrom) > 90) {
                    rainDropSpeed = 10;
                  } else {
                    rainDropSpeed = 15;
                  }
                } else {
                  rainDropShow = false;
                }
              });

              dailyProvider.setDailyId(name.forecastAgriID);
            },
            consumeTapEvents: true,
            polygonId: PolygonId(name.forecastAgriID),
            points: polygonCoords,
            strokeWidth: 4,
            fillColor: Color.fromARGB(117, 76, 175, 79),
            strokeColor: Color.fromARGB(190, 76, 175, 79)));
      }
    });
    setState(() {
      isRefresh = false;
    });
  }

  Future<void> getDailyList(String mod) async {
    setState(() {
      isRefresh = true;
    });
    String dt = DateFormat('yyyy-MM-dd').format(selectedDate);
    await DailyServices.getDailyList(context, mod, dt);
    final dailyProvider = context.read<DailyProvider>();
    dailyProvider.setDateSelect(selectedDate);
    setState(() {
      polygons.clear();
      title = 'Philippines';
      dailyList = dailyProvider.dailyList;

      for (var name in dailyList) {
        List<dynamic> coordinates = name.locationCoordinate;
        List<LatLng> polygonCoords = [];
        for (var coor in coordinates) {
          var latLng = coor['coordinate'].toString().split(",");
          double latitude = double.parse(latLng[0]);
          double longitude = double.parse(latLng[1]);
          polygonCoords.add(LatLng(latitude, longitude));
        }
        polygons.add(Polygon(
            onTap: () {
              print(name.dailyDetailsID);
              setState(() {
                title = name.locationDescription;
                if (double.parse(name.rainFallPercentage) >= 50) {
                  rainDropShow = true;
                  if (double.parse(name.rainFallPercentage) > 50) {
                    rainDropSpeed = 2;
                  } else if (double.parse(name.rainFallPercentage) > 70) {
                    rainDropSpeed = 5;
                  } else if (double.parse(name.rainFallPercentage) > 90) {
                    rainDropSpeed = 10;
                  } else {
                    rainDropSpeed = 15;
                  }
                } else {
                  rainDropShow = false;
                }
              });

              dailyProvider.setDailyId(name.dailyDetailsID);
            },
            consumeTapEvents: true,
            polygonId: PolygonId(name.dailyDetailsID),
            points: polygonCoords,
            strokeWidth: 4,
            fillColor: Color.fromARGB(117, 76, 175, 79),
            strokeColor: Color.fromARGB(190, 76, 175, 79)));
      }
    });
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

  SlidingUpPanel mainTab(
    BuildContext context,
  ) {
    final now = DateTime.now();
    String formatter = DateFormat('yMd').format(now);
    if (selectIndex == 0) {
      return SlidingUpPanel(
          minHeight: 120,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
          maxHeight: MediaQuery.of(context).size.height - 200,
          panel: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [DailyWidget()],
          ),
          body: mapWid());
    } else if (selectIndex == 1) {
      return SlidingUpPanel(
        minHeight: 120,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          maxHeight: MediaQuery.of(context).size.height - 200,
          panel: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [AgriWidget()],
          ),
          body: mapWid());
    } else if (selectIndex == 2) {
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
          body: mapWid());
    } else if (selectIndex == 3) {
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
                  "Agri 10 Days",
                  style: kTextStyleSubtitle2b,
                ),
              ),
            ],
          ),
          body: mapWid());
    } else if (selectIndex == 4) {
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
                  "Monthly Monitoring",
                  style: kTextStyleSubtitle2b,
                ),
              ),
            ],
          ),
          body: mapWid());
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

  Widget mapWid() {
    return Stack(
      children: [
        GoogleMap(
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
              onTap: (){
                Navigator.of(context).pushReplacementNamed(Routes.mobMain);
              },
              child: Container(
                child: Center(
                  child: Icon(
                    Icons.help
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.white, spreadRadius: 3),
                  ],
                ),
                height: 40,
                width: 40,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
            child: GestureDetector(
              onTap: (){
                Navigator.of(context).pushReplacementNamed(Routes.mobMain);
              },
              child: Container(
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.white, spreadRadius: 3),
                  ],
                ),
                height: 40,
                width: 40,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 230),
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
                          ? Colors.blue.withOpacity(.8)
                          : Colors.blue.withOpacity(.4),
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
                          ? Colors.blue.withOpacity(.8)
                          : Colors.blue.withOpacity(.4),
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
                          ? Colors.blue.withOpacity(.8)
                          : Colors.blue.withOpacity(.4),
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
        if (selectIndex == 0 ||
            selectIndex == 1 ||
            selectIndex == 2 ||
            selectIndex == 3)
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
                      ? Colors.blue.withOpacity(.8)
                      : Colors.blue.withOpacity(.4),
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
