import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:payong/models/daily_legend_model.dart';
import 'package:payong/models/mcao_search_prov_model.dart';
import 'package:payong/provider/daily_provider.dart';
import 'package:payong/provider/mcao_provider.dart';
import 'package:payong/services/daily_services.dart';
import 'package:payong/services/mcao_services.dart';
import 'package:payong/ui/presentation/mcao/components/assessment.dart';
import 'package:payong/ui/presentation/mcao/components/outlook.dart';
import 'package:payong/utils/hex_to_color.dart';
import 'package:payong/utils/themes.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class mCaOPage extends StatefulWidget {
  const mCaOPage({super.key});

  @override
  State<mCaOPage> createState() => _mCaOPageState();
}

class _mCaOPageState extends State<mCaOPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int myTabs = 0;
  bool dayNow = true;
  bool showMap = false;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.051436, 122.880019),
    zoom: 4.8,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    if (DateTime.now().hour > 6 && DateTime.now().hour < 18) {
      //evening
      dayNow = false;
    } else {
      //day
      dayNow = false;
    }
    Future.delayed(Duration.zero, () {
      getMapAll(context);
    });
    // setImageMap();
  }

  setImageMap() {
    final int mCaoTab = context.select((McaoProvider p) => p.mCaoTab);
    if (mCaoTab == 0) {
      final dailyProvider = context.read<DailyProvider>();
      dailyProvider.setOption('NormalRainfall', true, 'assessment');
    } else {
      final dailyProvider = context.read<DailyProvider>();
      dailyProvider.setOption('NormalRainfall', true, 'outlook');
    }
  }

  getMapAll(BuildContext context) async {
    await McaoService.getDailyLegend(context);
    // ignore: use_build_context_synchronously
    await getMap(context);
  }

  Future<void> getMap(BuildContext contexts) async {
    final dailyProvider = contexts.read<McaoProvider>();
    dailyProvider.setPolygonDaiyClear();
    dailyProvider.setMcaoSearch([]);
    Set<Polygon> polygons = {};
    for (var i = 1; i < 116; i++) {
      final result = await McaoService.getAssessment(contexts, i.toString());

      polygons.clear();
       List<McaoSearchModel> mcList = [];
      for (var name in result) {
        McaoSearchModel mc = McaoSearchModel(name.provinceID, name.locationDescription);
        mcList.add(mc);
        List<dynamic> coordinates = name.coordinates;
        List<LatLng> polygonCoords = [];
        if (coordinates.isNotEmpty) {
          
          for (var coor in coordinates) {
            try {
              var latLng = coor['coordinate'].toString().split(",");

              double latitude = double.parse(latLng[0]);
              double longitude = double.parse(latLng[1]);
              // print(longitude.toString() + ',' + latitude.toString());
              polygonCoords.add(LatLng(longitude, latitude));
            } catch (e) {}
          }
          Color lxColor = Colors.blue.shade50;


          try {} catch (e) {}
          Polygon pol = Polygon(
              onTap: () {
                print('jkahsdkjahsdkj');
                dailyProvider.setProvID(name.provinceID);

              },
              consumeTapEvents: true,
              polygonId: PolygonId(name.provinceID),
              points: polygonCoords,
              strokeWidth: 4,
              fillColor: lxColor,
              strokeColor: lxColor);
          dailyProvider.setPolygonDaiy(pol);
        }
      }
        dailyProvider.setMcaoSearch(mcList);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String option = context.select((DailyProvider p) => p.option);
    final int mCaoTab = context.select((McaoProvider p) => p.mCaoTab);

    // getMapAll(context);
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Column(children: [
            if (mCaoTab == 0) ...[
              assessmentPage(),
            ] else ...[
              outlookPage(),
            ]
          ]),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 20, 0),
            child: GestureDetector(
              onTap: () {
                //  final dailyProvider =
                //                   context.read<DailyProvider>();
                //  if (mCaoTab == 0) {
                //   dailyProvider.setDateSelect(DateTime.now().subtract(const Duration(days: 30)));
                //  }else{
                //   dailyProvider.setDateSelect(DateTime.now());
                //  }

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
                              String mcaoOption = 'assessment';
                              if (mCaoTab == 0) {
                                mcaoOption = 'assessment';
                              } else {
                                mcaoOption = 'outlook';
                              }
                              final dailyProvider =
                                  context.read<DailyProvider>();
                              dailyProvider.setOption(
                                  'ActualRainfall', false, mcaoOption);
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
                            onTap: () {
                              String mcaoOption = 'assessment';
                              if (mCaoTab == 0) {
                                mcaoOption = 'assessment';
                              } else {
                                mcaoOption = 'outlook';
                              }
                              final dailyProvider =
                                  context.read<DailyProvider>();
                              dailyProvider.setOption(
                                  'NormalRainfall', false, mcaoOption);
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
                            onTap: () {
                              String mcaoOption = 'assessment';
                              if (mCaoTab == 0) {
                                mcaoOption = 'assessment';
                              } else {
                                mcaoOption = 'outlook';
                              }
                              final dailyProvider =
                                  context.read<DailyProvider>();
                              dailyProvider.setOption(
                                  'RainfallPercent', false, mcaoOption);
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
                            onTap: () {
                              String mcaoOption = 'assessment';
                              if (mCaoTab == 0) {
                                mcaoOption = 'assessment';
                              } else {
                                mcaoOption = 'outlook';
                              }
                              final dailyProvider =
                                  context.read<DailyProvider>();
                              dailyProvider.setOption(
                                  'MaxTemp', false, mcaoOption);
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
                            onTap: () {
                              String mcaoOption = 'assessment';
                              if (mCaoTab == 0) {
                                mcaoOption = 'assessment';
                              } else {
                                mcaoOption = 'outlook';
                              }
                              final dailyProvider =
                                  context.read<DailyProvider>();
                              dailyProvider.setOption(
                                  'MinTemp', false, mcaoOption);
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
                child: Center(child: Icon(Icons.menu)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
