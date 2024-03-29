// ignore_for_file: prefer_const_constructors
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:convert';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parallax_rain/parallax_rain.dart';
import 'package:payong/models/agri_model.dart';
import 'package:payong/models/daily_legend_model.dart';
import 'package:payong/models/daily_model.dart';
import 'package:payong/models/region_search_model.dart';
import 'package:payong/provider/agri_provider.dart';
import 'package:payong/provider/daily10_provider.dart';
import 'package:payong/provider/daily_provider.dart';
import 'package:payong/provider/init_provider.dart';
import 'package:payong/provider/mcao_provider.dart';
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
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/intl.dart';

import 'presentation/agri10days/components/regionListSearch.dart';

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

  bool isRefresh = false;
  MapType mapType = MapType.normal;
  String title = 'Philippines';
  double rainDropSpeed = 5;
  bool rainDropShow = false;
  int agriTab = 0;
  bool dayNow = true;
  bool showLegends = false;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  LatLng _center = LatLng(11.051436, 122.880019);
  LatLng mapMarker = LatLng(11.051436, 122.880019);
  String prognosisColorMap = '';
  String? mapStyle;
  HawkFabMenuController hawkFabMenuController = HawkFabMenuController();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.051436, 122.880019),
    zoom: 5.3,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(11.051436, 122.880019),
      tilt: 59.440717697143555,
      zoom: 5.3);

  int selectIndex = 0;

//11.051436, 122.880019
  @override
  void initState() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      mapStyle = string;
    });
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
      // get10DaysList();
      getAgriList();
    } else if (selectIndex == 2) {
      get10DaysList();
    } else if (selectIndex == 3) {
      getPrognosissMapList();
    } else if (selectIndex == 4) {
    } else {
      // getDailyList('daily');
    }
  }

  Future<void> getAgriList() async {
    await AgriServices.getAgriSypnosis(context);
  }

  Future<void> getPrognosissMapList() async {
    await Future.delayed(const Duration(seconds: 10));
    setState(() {
      isRefresh = true;
    });
    final dailyProvider = context.read<Daily10Provider>();
    context.read<InitProvider>().setIsLoading(true);
    final prod = context.read<AgriProvider>();
    dailyProvider.setPolygonDaiyClear();
    dailyProvider.setRegionList([]);
    Set<Polygon> polygons = {};
    List<RegionSearchModel> regList = [];
    // for (var i = 1; i < 17; i++) {
    final result = await AgriServices.getRegionMap(context);

    // try {
    setState(() {
      polygons.clear();
    
      for (var name in result) {
        RegionSearchModel rc = RegionSearchModel(name.dailyDetailsID, name.locationDescription);
        regList.add(rc);
        // print(name.locationCoordinate);
        List<dynamic> coordinates = name.locationCoordinate;
        List<LatLng> polygonCoords = [];
        if (coordinates.isNotEmpty) {
          for (var coor in coordinates) {
            try {
              // print(coor['coordinate']);
              var latLng = coor['coordinate'].toString().split(",");
              double latitude = double.parse(latLng[0]);
              double longitude = double.parse(latLng[1]);

              polygonCoords.add(LatLng(longitude, latitude));
            } catch (e) {}
          }

          dailyProvider.setPolygonDaiy(Polygon(
              onTap: () async {
                print('jahskdjhaskjdhas');
                prod.setProgID(name.dailyDetailsID);

                dailyProvider.removePolygonDaiy(PolygonId(prognosisColorMap));
                setState(() {
                  prognosisColorMap = name.dailyDetailsID;
                });
                dailyProvider.setPolygonDaiy(Polygon(
                    onTap: () async {
                      prod.setProgID(name.dailyDetailsID);
                    },
                    consumeTapEvents: true,
                    polygonId: PolygonId(name.dailyDetailsID),
                    points: polygonCoords,
                    strokeWidth: 4,
                    fillColor: Colors.blueAccent,
                    strokeColor: Colors.transparent));
                await AgriServices.getProgDetails(context, name.dailyDetailsID);
              },
              consumeTapEvents: true,
              polygonId: PolygonId(name.dailyDetailsID),
              points: polygonCoords,
              strokeWidth: 4,
              fillColor: Colors.transparent,
              strokeColor: Colors.transparent));
        }
      }
    });

    dailyProvider.setRegionList(regList);
    // } catch (e) {
    //   print('error $e');
    // }
    // }
    context.read<InitProvider>().setIsLoading(false);
    setState(() {
      isRefresh = false;
    });
  }

  Future<void> get10DaysList() async {
    setState(() {
      isRefresh = true;
    });
    final dailyProvider = context.read<Daily10Provider>();
    dailyProvider.setPolygonDaiyClear();
    Set<Polygon> polygons = {};
    for (var i = 1; i < 116; i++) {
      final result = await Daily10Services.get10DaysMap(context, i.toString());

      try {
        setState(() {
          polygons.clear();

          for (var name in result) {
            List<dynamic> coordinates = name.locationCoordinate;
            List<LatLng> polygonCoords = [];
            if (coordinates.isNotEmpty) {
              for (var coor in coordinates) {
                var latLng = coor['coordinate'].toString().split(",");
                double latitude = double.parse(latLng[0]);
                double longitude = double.parse(latLng[1]);

                polygonCoords.add(LatLng(longitude, latitude));
                final dailyProvider = context.read<Daily10Provider>();
                  dailyProvider.setMuniName(name.locationDescription);
              }

              dailyProvider.setPolygonDaiy(Polygon(
                  onTap: () async {
                    final dailyProvider = context.read<Daily10Provider>();
                    dailyProvider.setDailyId(name.dailyDetailsID);
                    dailyProvider.setShowList(false);
                  },
                  consumeTapEvents: true,
                  polygonId: PolygonId(name.dailyDetailsID),
                  points: polygonCoords,
                  strokeWidth: 4,
                  fillColor: Colors.white,
                  strokeColor: Colors.transparent));
            }
          }
        });
      } catch (e) {
      }
    }
    setState(() {
      isRefresh = false;
    });
  }
    Future<void> getDailyListFromSet(String mod) async {
    await DailyServices.getDailyLegend(context);
    setState(() {
      isRefresh = true;
    });

    final dailyProvider = context.read<DailyProvider>();
    // dailyProvider.setPolygonDaiyClear();
    
    String optionFilter = 'ActualRainfall';
    String url = '';
    if (dailyProvider.option == 'MinTemp') {
      optionFilter = 'MinTemp';
      url = 'http://18.139.91.35/payong/api/datecheck_dailymon.php?dtype=4';
    } else if (dailyProvider.option == 'NormalRainfall') {
      optionFilter = 'NormalRainfall';
      url = 'http://18.139.91.35/payong/api/datecheck_dailymon.php?dtype=1';
    } else if (dailyProvider.option == 'MaxTemp') {
      optionFilter = 'MaxTemp';
      url = 'http://18.139.91.35/payong/api/datecheck_dailymon.php?dtype=5';
    } else if (dailyProvider.option == 'ActualRainfall') {
      optionFilter = 'ActualRainfall';
      url = 'http://18.139.91.35/payong/api/datecheck_dailymon.php?dtype=2';
    } else if (dailyProvider.option == 'RainfallPercent') {
      optionFilter = 'RainfallPercent';
      url = 'http://18.139.91.35/payong/api/datecheck_dailymon.php?dtype=3';
    }
    
    // for (var i = 1; i < 200; i++) {
    // print('john paul $i');
    String dt = DateFormat('yyyy-MM-dd').format(DateTime.now());
   final response = await http.get(Uri.parse(url));
     var jsondata = json.decode(response.body);
    String dateSelect = '';
      if (jsondata.isNotEmpty) {
        dateSelect = jsondata[0]['CurrentDate'];
        print(dateSelect);
      } else {
        dateSelect = dt;
      }
    print('lakjshdjlkaslkdjlakjd ${dailyProvider.option}');
    dailyProvider.setDateBE(dateSelect);
   dailyProvider.setOption(dailyProvider.option, true,'');
    // }
    setState(() {
      isRefresh = false;
    });
  }

  Future<void> getDailyList(String mod) async {
    await DailyServices.getDailyLegend(context);
    setState(() {
      isRefresh = true;
    });

    final dailyProvider = context.read<DailyProvider>();
    dailyProvider.setPolygonDaiyClear();
    
    String optionFilter = 'ActualRainfall';
    String url = '';
    if (dailyProvider.option == 'MinTemp') {
      optionFilter = 'MinTemp';
      url = 'http://18.139.91.35/payong/api/datecheck_dailymon.php?dtype=4';
    } else if (dailyProvider.option == 'NormalRainfall') {
      optionFilter = 'NormalRainfall';
      url = 'http://18.139.91.35/payong/api/datecheck_dailymon.php?dtype=1';
    } else if (dailyProvider.option == 'MaxTemp') {
      optionFilter = 'MaxTemp';
      url = 'http://18.139.91.35/payong/api/datecheck_dailymon.php?dtype=5';
    } else if (dailyProvider.option == 'ActualRainfall') {
      optionFilter = 'ActualRainfall';
      url = 'http://18.139.91.35/payong/api/datecheck_dailymon.php?dtype=2';
    } else if (dailyProvider.option == 'RainfallPercent') {
      optionFilter = 'RainfallPercent';
      url = 'http://18.139.91.35/payong/api/datecheck_dailymon.php?dtype=3';
    } else {
      optionFilter = 'ActualRainfall';
      url = 'http://18.139.91.35/payong/api/datecheck_dailymon.php?dtype=2';
    }
    dailyProvider.setOption(optionFilter, true,'');
    // for (var i = 1; i < 200; i++) {
    // print('john paul $i');
    String dt = DateFormat('yyyy-MM-dd').format(DateTime.now());
   final response = await http.get(Uri.parse(url));
     var jsondata = json.decode(response.body);
    String dateSelect = '';
      if (jsondata.isNotEmpty) {
        dateSelect = jsondata[0]['CurrentDate'];
        print(dateSelect);
      } else {
        dateSelect = dt;
      }
    
    dailyProvider.setDateBE(dateSelect);
   


    final dailymap =
        await DailyServices.getDailyList(context, dateSelect, '1', optionFilter);

    dailyProvider.setDateSelect(dailyProvider.selectedDate);
    colorMap(dailymap);
    // }
    setState(() {
      isRefresh = false;
    });
  }

  void colorMap(List<DailyModel> dailymap) {
    final dailyProvider = context.read<DailyProvider>();
    setState(() {
      // polygons.clear();

      for (var name in dailymap) {
        List<dynamic> coordinates = name.locationCoordinate;
        List<LatLng> polygonCoords = [];
        if (coordinates.isNotEmpty) {
          for (var coor in coordinates) {
            var latLng = coor['coordinate'].toString().split(",");
            double latitude = double.parse(latLng[0]);
            double longitude = double.parse(latLng[1]);

            polygonCoords.add(LatLng(longitude, latitude));
          }
          Color lxColor = Color.fromARGB(0, 249, 247, 247);

          // if (dailyProvider.option == 'MinTemp') {
          //   lxColor = name.lowTempColorCode.toColor();
          // } else if (dailyProvider.option == 'NormalRainfall') {
          //   lxColor = name.rainFallNormalColorCode.toColor();
          // } else if (dailyProvider.option == 'MaxTemp') {
          //   lxColor = name.highTempColorCode.toColor();
          // } else if (dailyProvider.option == 'ActualRainfall') {
          //   lxColor = name.rainFallActualColorCode.toColor();
          // } else if (dailyProvider.option == 'RainfallPercent') {
          //   lxColor = name.percentrainFallColorCode.toColor();
          // } else {
          //   lxColor = name.rainFallActualColorCode.toColor();
          // }

          dailyProvider.setPolygonDaiy(Polygon(
              onTap: () async {
                dailyProvider.setDailyId(name.dailyDetailsID);

                setState(() {
                  showLegends = true;
                });
                Future.delayed(Duration(seconds: 8), () {
                  setState(() {
                    showLegends = false;
                  });
                });
              },
              consumeTapEvents: true,
              polygonId: PolygonId(name.dailyDetailsID),
              points: polygonCoords,
              strokeWidth: 4,
              fillColor: lxColor.withOpacity(.9),
              strokeColor: lxColor));
          // polygons.add();
        }
      }
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

  List<TabItem> itemsAgri10 = [
    TabItem(
      icon: FontAwesomeIcons.cloud,
      title: 'Forecast',
    ),
    TabItem(
      icon: FontAwesomeIcons.leaf,
      title: 'Crop Phenology',
    ),
    TabItem(
      icon: FontAwesomeIcons.book,
      title: 'Advisory',
    ),
  ];

  List<TabItem> itemsAgri = [
    TabItem(
      icon: Icons.add_chart_rounded,
      title: 'Synopsis',
    ),
    TabItem(
      icon: FontAwesomeIcons.leaf,
      title: 'Daily Farm',
    ),
    TabItem(
      icon: FontAwesomeIcons.book,
      title: 'Advisory',
    ),
  ];

  List<TabItem> itemsMcao = [
    TabItem(
      icon: Icons.home_repair_service_outlined,
      title: 'Assessment',
    ),
    TabItem(
      icon: FontAwesomeIcons.telegram,
      title: 'Outlook',
    ),
  ];

  int visit = 0;

  @override
  Widget build(BuildContext context) {
    AgriProvider _agri10provider = context.read<AgriProvider>();
    McaoProvider _mcaoprovider = context.read<McaoProvider>();
    final int agri10Tab = context.select((AgriProvider p) => p.agri10Tabs);
    List<TabItem> myTabs = [];
    if (selectIndex == 1) {
      myTabs = itemsAgri;
    } else if (selectIndex == 3) {
      myTabs = itemsAgri10;
    } else if (selectIndex == 4) {
      myTabs = itemsMcao;
    }
    return Scaffold(
      body: HawkFabMenu(
        icon: AnimatedIcons.home_menu,
        fabColor: Colors.black,
        iconColor: Colors.white,
        hawkFabMenuController: hawkFabMenuController,
        items: [
          HawkFabMenuItem(
            label: 'Daily Monitoring',
            ontap: () {
              setState(() {
               
                final dailyProvider = context.read<DailyProvider>();

                dailyProvider.setDateSelect(dailyProvider.selectedDate);
                polygons.clear();
                title = 'Philippines';
                selectIndex = 0;
              });
            },
            icon: const Icon(Icons.cloud_circle, size: 35),
            color: Colors.blue,
            labelColor: Colors.blue,
          ),
          HawkFabMenuItem(
            label: '10 Days Weather Outlook',
            ontap: () {
              setState(() {
                final dailyProvider = context.read<DailyProvider>();
                dailyProvider.setDateSelect(DateTime.now());
                polygons.clear();
                title = 'Philippines';
                selectIndex = 2;
              });
            },
            icon: const Icon(Icons.cloud_done),
            color: Colors.blue,
            labelColor: Colors.blue,
          ),
          HawkFabMenuItem(
            label: 'Daily Farm Weather Forecasts and Advisories',
            ontap: () {
              setState(() {
                final dailyProvider = context.read<DailyProvider>();
                dailyProvider.setDateSelect(DateTime.now());
                polygons.clear();
                title = 'Philippines';
                selectIndex = 1;
              });
            },
            icon: const Icon(Icons.cloud_queue, size: 35),
            color: Colors.blue,
            labelColor: Colors.blue,
          ),
          HawkFabMenuItem(
            label: '10 Days Regional Agri-weather Information',
            ontap: () {
              setState(() {
                final dailyProvider = context.read<DailyProvider>();
                dailyProvider.setDateSelect(DateTime.now());
                polygons.clear();
                title = 'Philippines';
                selectIndex = 3;
              });
            },
            icon: const Icon(FontAwesomeIcons.cloudRain, size: 35),
            color: Colors.blue,
            labelColor: Colors.blue,
          ),
          HawkFabMenuItem(
            label: 'Monthly Climate Assessment and Outlook',
            ontap: () {
              setState(() {
                final dailyProvider = context.read<DailyProvider>();
                dailyProvider.setDateSelect(DateTime.now());
                polygons.clear();
                title = 'Philippines';
                selectIndex = 4;
              });
            },
            icon: const Icon(FontAwesomeIcons.cloudSun, size: 35),
            color: Colors.blue,
            labelColor: Colors.blue,
          ),
        ],
        body: Stack(
          children: [
            Align(
                alignment: Alignment.center,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: mainTab(context))),
            Align(
              alignment: Alignment.bottomCenter,
              child: Visibility(
                visible:
                    selectIndex == 1 || selectIndex == 3 || selectIndex == 4,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: BottomBarInspiredOutside(
                    items: myTabs,
                    // heightItem: 38,
                    iconSize: 20,
                    titleStyle: TextStyle(fontSize: 14),
                    backgroundColor: kColorBlue,
                    color: Colors.white,
                    colorSelected: Colors.white,
                    indexSelected: visit,
                    top: -34,
                    itemStyle: ItemStyle.circle,
                    chipStyle: const ChipStyle(
                        background: kColorBlue,
                        size: 100,
                        notchSmoothness: NotchSmoothness.defaultEdge),
                    onTap: (int index) => setState(() {
                      visit = index;
                      agriTab = index;
                      if (selectIndex == 4) {
                        _mcaoprovider.setMcaoTab(index);
                      } else {
                        _agri10provider.setAgri10Tab(index);
                      }
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
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
          body: map10Wid());
    } else if (selectIndex == 3) {
      return SlidingUpPanel(
          minHeight: agriTab == 1 ? 180 : 0,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          maxHeight: MediaQuery.of(context).size.height - 200,
          panel: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              if (agriTab == 0 || agriTab == 2) ...[
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

        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(children: [
              if (agriTab == 0) ...[
                AgriSynopsisWidget()
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
    //Prognosis map
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: agriTab == 1
                ? prognosisMap()
                : Column(children: [
                    if (agriTab == 2) ...[
                      AgriAdvisory10Widget()
                    ] else if (agriTab == 0) ...[
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
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 0, 0),
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

  void _onCameraMove(CameraPosition position) {
    mapMarker = position.target;
    final marker = Marker(
      markerId: MarkerId('area'),
      position: mapMarker,
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: 'title',
        snippet: 'address',
      ),
    );

    setState(() {
      markers[MarkerId('area')] = marker;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(mapStyle);
    final marker = Marker(
      markerId: MarkerId('area'),
      position: LatLng(11.051436, 122.880019),
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: 'title',
        snippet: 'address',
      ),
    );

    setState(() {
      markers[MarkerId('place_name')] = marker;
    });
  }

  Widget map10Wid() {
    final dailyProviderPolygon = context.read<Daily10Provider>().polygons;
    return Stack(
      children: [
        GoogleMap(
          // onCameraMove: _onCameraMove,
          // markers: markers.values.toSet(),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: mapType,
          polygons: dailyProviderPolygon!,
          initialCameraPosition: _kGooglePlex,
          zoomGesturesEnabled: true,
          tiltGesturesEnabled: false,
          onMapCreated: _onMapCreated,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 140),
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
                        style: TextStyle(color: Colors.black),
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
                        style: TextStyle(color: Colors.black),
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
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )),
            ]),
          ),
        ),
        // Align(
        //   child: Column(children: [
        //     Padding(
        //       padding: EdgeInsets.fromLTRB(10, 100, 10, 0),
        //       child: TextField(
        //         style: TextStyle(color: Colors.black),
        //         onChanged: (value) async {
        //           final dailyProvider = context.read<Daily10Provider>();
        //           print(value);
        //           if (value.isNotEmpty) {
        //             print('ansldkjalksdjlaksjd');
        //             dailyProvider.setShowList(true);
        //           } else {
        //             print('mnv,mzn,mcnv,m');
        //             dailyProvider.setShowList(false);
        //           }

        //           dailyProvider.setSearchString(value);
        //           await Daily10Services.get10DaysSearch(context, value);
        //         },
        //         decoration: InputDecoration(
        //           hintText: "Search Location",
        //           prefixIcon: Icon(Icons.search),
        //           border: OutlineInputBorder(
        //             borderRadius: BorderRadius.all(Radius.circular(7.0)),
        //           ),
        //         ),
        //       ),
        //     ),
        //     SearchList(
        //       navClose: false,
        //     )
        //   ]),
        // ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 20, 0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return Container(
                      height: MediaQuery.of(context).size.height - 100,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              onChanged: (value) async {
                                final dailyProvider =
                                    context.read<Daily10Provider>();
                                if (value.isNotEmpty) {
                                  dailyProvider.setShowList(true);
                                } else {
                                  dailyProvider.setShowList(false);
                                }

                                dailyProvider.setSearchString(value);
                                await Daily10Services.get10DaysSearch(
                                    context, value);
                              },
                              decoration: InputDecoration(
                                hintText: "Search Location",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7.0)),
                                ),
                              ),
                            ),
                          ),
                          SearchList(navClose: true)
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
                  child: Icon(Icons.search),
                ),
              ),
            ),
          ),
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
        // if (isRefresh)
        //   Align(
        //     alignment: Alignment.center,
        //     child: CircularProgressIndicator(),
        //   ),
      ],
    );
  }

  Widget mapWid() {
    final prov = context.read<DailyProvider>();
    final dailyProvider = context.read<DailyProvider>().polygons;
    final dailyProviderImage = context.read<DailyProvider>().mapImage;
    final List<DailyLegendModel> dailyLegends =
        context.select((DailyProvider p) => p.dailyLegend);
    final String option = context.select((DailyProvider p) => p.option);
    String optionTitle = '';
    String subTitle = '';
     String mo = 'January';
       if(prov.selectedDate.month == 1){
        mo = 'January';
       }else if(prov.selectedDate.month == 2){
      mo = 'February';
       }else if(prov.selectedDate.month == 3){
      mo = 'March';
       }else if(prov.selectedDate.month == 4){
      mo = 'April';
       }else if(prov.selectedDate.month == 5){
      mo = 'May';
       }else if(prov.selectedDate.month == 6){
      mo = 'June';
       }else if(prov.selectedDate.month == 7){
      mo = 'July';
       }else if(prov.selectedDate.month == 8){
      mo = 'August';
       }else if(prov.selectedDate.month == 9){
      mo = 'September';
       }else if(prov.selectedDate.month == 10){
      mo = 'October';
       }else if(prov.selectedDate.month == 11){
      mo = 'November';
       }else if(prov.selectedDate.month == 12){
      mo = 'December';
       }
    if (option == 'ActualRainfall') {
      optionTitle = 'Actual Rainfall';
      subTitle = '$mo 1 - ${prov.selectedDate.day} ${prov.selectedDate.year}';
    } else if (option == 'NormalRainfall') {
      optionTitle = 'Normal Rainfall';
        subTitle = '$mo ${prov.selectedDate.year}';
    } else if (option == 'RainfallPercent') {
      optionTitle = 'Percent Rainfall';
        subTitle = '$mo 1 - ${prov.selectedDate.day} ${prov.selectedDate.year}';
    } else if (option == 'MaxTemp') {
      optionTitle = 'Max Temp';
       subTitle = '$mo ${prov.selectedDate.day} ${prov.selectedDate.year}';
    } else if (option == 'MinTemp') {
      optionTitle = 'Min Temp';
      subTitle = '$mo ${prov.selectedDate.day} ${prov.selectedDate.year}';
    } else {
      optionTitle = 'Actual Rainfall';
    }
    return Stack(
      children: [
        GoogleMap(
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          mapType: mapType,
          polygons: dailyProvider!,
          initialCameraPosition: _kGooglePlex,
          zoomGesturesEnabled: false,
          tiltGesturesEnabled: false,
          zoomControlsEnabled: false,
          scrollGesturesEnabled: false,
          
          onMapCreated: (GoogleMapController controller) {
            // controller.setMapStyle(mapStyle);
            _controller.complete(controller);
          },
        ),

        if (dailyProviderImage != '')
          IgnorePointer(
            child: ColoredBox(
              color: Colors.white,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.network(
                  dailyProviderImage,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.fitWidth,
                  // opacity: const AlwaysStoppedAnimation(.02),
                ),
              ),
            ),
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
        // Align(
        //   child: Column(children: [
        //     Padding(
        //       padding: EdgeInsets.fromLTRB(10, 100, 10, 0),
        //       child: TextField(
        //         style: TextStyle(color: Colors.black),
        //         onChanged: (value) async {
        //           final dailyProvider1 = context.read<Daily10Provider>();
        //           print(value);
        //           if (value.isNotEmpty) {
        //             print('ansldkjalksdjlaksjd');
        //             dailyProvider1.setShowList(true);
        //           } else {
        //             print('mnv,mzn,mcnv,m');
        //             dailyProvider1.setShowList(false);
        //           }

        //           dailyProvider1.setSearchString(value);
        //           await Daily10Services.get10DaysSearch(context, value);
        //         },
        //         decoration: InputDecoration(
        //           hintText: "Search Location",
        //           prefixIcon: Icon(Icons.search),
        //           border: OutlineInputBorder(
        //             borderRadius: BorderRadius.all(Radius.circular(7.0)),
        //           ),
        //         ),
        //       ),
        //     ),
        //     SearchList()
        //   ]),
        // ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 120, 20, 0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return Container(
                       height: MediaQuery.of(context).size.height - 100,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              onChanged: (value) async {
                                final dailyProvider1 =
                                    context.read<Daily10Provider>();
                                if (value.isNotEmpty) {
                                  dailyProvider1.setShowList(true);
                                } else {
                                  dailyProvider1.setShowList(false);
                                }

                                dailyProvider1.setSearchString(value);
                                await Daily10Services.get10DaysSearch(
                                    context, value);
                              },
                              decoration: InputDecoration(
                                hintText: "Search Location",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7.0)),
                                ),
                              ),
                            ),
                          ),
                          SearchList(navClose: true)
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
                  child: Icon(Icons.search),
                ),
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
                            onTap: ()async {
                              final dailyProvider =
                                  context.read<DailyProvider>();
                              dailyProvider.setOption('ActualRainfall', true,'');
                              // getDailyListFromSet('daily');
                                await DailyServices.getDailyLegend(context);
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: option == 'ActualRainfall'
                                    ? kColorBlue
                                    : Colors.grey.shade300,
                              ),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 10,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    'Actual Rainfall',
                                    style: TextStyle(
                                        color: option == 'ActualRainfall'
                                            ? Colors.white
                                            : kColorBlue),
                                  ))),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: ()async {
                              final dailyProvider =
                                  context.read<DailyProvider>();
                              dailyProvider.setOption('NormalRainfall', true,'');
                              // getDailyListFromSet('daily');
                                await DailyServices.getDailyLegend(context);
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: option == 'NormalRainfall'
                                    ? kColorBlue
                                    : Colors.grey.shade300,
                              ),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 10,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    'Normal Rainfall',
                                    style: TextStyle(
                                        color: option == 'NormalRainfall'
                                            ? Colors.white
                                            : kColorBlue),
                                  ))),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () async{
                              final dailyProvider =
                                  context.read<DailyProvider>();
                              dailyProvider.setOption('RainfallPercent', true,'');
                              // getDailyListFromSet('daily');
                                await DailyServices.getDailyLegend(context);
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: option == 'RainfallPercent'
                                    ? kColorBlue
                                    : Colors.grey.shade300,
                              ),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 10,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    'Rainfall Percent',
                                    style: TextStyle(
                                        color: option == 'RainfallPercent'
                                            ? Colors.white
                                            : kColorBlue),
                                  ))),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () async{
                              final dailyProvider =
                                  context.read<DailyProvider>();
                              dailyProvider.setOption('MaxTemp', true,'');
                              // getDailyListFromSet('daily');
                                await DailyServices.getDailyLegend(context);
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: option == 'MaxTemp'
                                    ? kColorBlue
                                    : Colors.grey.shade300,
                              ),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 10,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    'Max Temperature',
                                    style: TextStyle(
                                        color: option == 'MaxTemp'
                                            ? Colors.white
                                            : kColorBlue),
                                  ))),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: ()async {
                              final dailyProvider =
                                  context.read<DailyProvider>();
                              dailyProvider.setOption('MinTemp', true,'');
                              // getDailyListFromSet('daily');
                                await DailyServices.getDailyLegend(context);
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: option == 'MinTemp'
                                    ? kColorBlue
                                    : Colors.grey.shade300,
                              ),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 10,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    'Minimum Temperature',
                                    style: TextStyle(
                                        color: option == 'MinTemp'
                                            ? Colors.white
                                            : kColorBlue),
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
                    child: Icon(Icons.menu)),
              ),
            ),
          ),
        ),
        if (dailyLegends.isNotEmpty)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 180, 10, 0),
              child: Container(
                width: 100,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // color: Colors.black.withOpacity(.1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Legends'),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          scrollDirection: Axis.vertical,
                          itemCount: dailyLegends.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    dailyLegends[index].title,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  
                                  ColoredBox(
                                    color: dailyLegends[index].color.toColor(),
                                    child: SizedBox(
                                      width: 15,
                                      height: 15,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
            child: Row(
              children: [
                GestureDetector(
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
                // SizedBox(width: 12,),
                // Text(optionTitle, style: TextStyle(color: Colors.black, fontSize: 20))
              ],
            ),
          ),
        ),
        Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
              child: Column(
                children: [
                  Text(
                    optionTitle,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  Text(
                    subTitle,
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ],
              ),
            )),
        Visibility(
          visible: false,
          child: Align(
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
                          style: TextStyle(color: Colors.black),
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
                          style: TextStyle(color: Colors.black),
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
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    )),
              ]),
            ),
          ),
        ),
        // if (isRefresh)
        //   Align(
        //     alignment: Alignment.center,
        //     child: CircularProgressIndicator(),
        //   ),
        // if (selectIndex == 1 || selectIndex == 2 || selectIndex == 3)
        //   Align(
        //     alignment: Alignment.bottomCenter,
        //     child: Padding(
        //       padding: const EdgeInsets.fromLTRB(8, 0, 8, 140),
        //       child: display10DaysWidget(),
        //     ),
        //   )
      ],
    );
  }

  //prognosismap
  Widget prognosisMap() {
    final dailyProvider = context.read<Daily10Provider>().polygons;
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
            controller.setMapStyle(mapStyle);
            _controller.complete(controller);
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 200),
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
                        style: TextStyle(color: Colors.black),
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
                        style: TextStyle(color: Colors.black),
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
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )),
            ]),
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
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height - 100,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Padding(
                            //   padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            //   child: TextField(
                            //     style: TextStyle(color: Colors.black),
                            //     onChanged: (value) async {},
                            //     decoration: InputDecoration(
                            //       hintText: "Search Location",
                            //       prefixIcon: Icon(Icons.search),
                            //       border: OutlineInputBorder(
                            //         borderRadius:
                            //             BorderRadius.all(Radius.circular(7.0)),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            RegionSearchList(navClose: true)
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
                    boxShadow: const [
                      BoxShadow(color: Colors.white, spreadRadius: 3),
                    ],
                  ),
                  height: 40,
                  width: 40,
                  child: const Center(
                    child: Icon(
                      Icons.search,
                      color: kColorBlue,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Widget display10DaysWidget() {
  //   return SizedBox(
  //     height: 80.0,
  //     child: ListView(scrollDirection: Axis.horizontal, children: <Widget>[
  //       for (var item in lastDay.reversed.toList())
  //         GestureDetector(
  //           onTap: () {
  //             setState(() {
  //               selectedDate = item;
  //               getDailyList('10days');
  //             });
  //           },
  //           child: Padding(
  //             padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
  //             child: Container(
  //               width: 120,
  //               height: 100,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(17.0),
  //                 color: selectedDate == item
  //                     ? Colors.white.withOpacity(.8)
  //                     : Colors.white.withOpacity(.4),
  //               ),
  //               child: Padding(
  //                 padding: const EdgeInsets.all(2.0),
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(10.0),
  //                   child: Column(
  //                     children: [
  //                       Text(
  //                         '${getMonthString(item.month)} ${item.year}',
  //                         style: TextStyle(fontSize: 10),
  //                       ),
  //                       Text(
  //                         getFormatedDay(item, 'name'),
  //                         style: TextStyle(
  //                             fontSize: 18, fontWeight: FontWeight.bold),
  //                       ),
  //                       Text(getFormatedDay(item, 'Day')),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         )
  //     ]),
  //   );
  // }

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
