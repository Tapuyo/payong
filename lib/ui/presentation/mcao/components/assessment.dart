import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:payong/models/daily_legend_model.dart';
import 'package:payong/provider/daily10_provider.dart';
import 'package:payong/provider/daily_provider.dart';
import 'package:payong/provider/mcao_provider.dart';
import 'package:payong/services/agri_service.dart';
import 'package:payong/services/mcao_services.dart';
import 'package:payong/ui/presentation/10days/search_list.dart';
import 'package:payong/ui/presentation/mcao/components/mcaoSearch.dart';
import 'package:payong/utils/hex_to_color.dart';
import 'package:payong/utils/themes.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class assessmentPage extends HookWidget {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.051436, 122.880019),
    zoom: 4.8,
  );
  String? mapStyle;

  // print('http://18.139.91.35/payong/assessment.php?fdate=${monthReturn(DateTime.now().month)}23${DateTime.now().year}');

  @override
  Widget build(BuildContext context) {
    final dailyProviderImage = context.read<DailyProvider>().mapImage;
    final option = context.select((DailyProvider p) => p.option);
    rootBundle.loadString('assets/map_style.txt').then((string) {
      mapStyle = string;
    });
    final dailyProviderPolygon =
        useState(context.read<McaoProvider>().polygons);
    final agriTab = useState(0);
    final onLoad = useState(true);
    final List<DailyLegendModel> dailyLegends =
        context.select((DailyProvider p) => p.dailyLegend);
    final pr = context.select((McaoProvider p) => p.provinceID);
    final deatilsMap = context.select((McaoProvider p) => p.mcaoDetails);

    useEffect(() {
      Future.microtask(() async {
        print('Prov change');
        McaoService.getDetails(context, pr, option, 0,
            DateTime.now().subtract(Duration(days: 30)));
      });
      return;
    }, [pr]);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 150,
      child: Stack(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: agriTab.value == 0
              ? WebView(
                  initialUrl:
                      'http://18.139.91.35/payong/assessment.php?fdate=${monthReturn(DateTime.now().subtract(Duration(days: 30)).month)}%20${DateTime.now().year}',
                  onPageFinished: (url) {
                    onLoad.value = false;
                  },
                )
              : Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: GoogleMap(
                          // myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          mapType: MapType.normal,
                          polygons: dailyProviderPolygon.value!,
                          initialCameraPosition: _kGooglePlex,
                          zoomGesturesEnabled: true,
                          tiltGesturesEnabled: false,
                          onMapCreated: (GoogleMapController controller) {
                            controller.setMapStyle(mapStyle);
                          },
                        ),
                      ),
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
                              // opacity: const AlwaysStoppedAnimation(.5),
                            ),
                          ),
                        ),
                      ),
                    if (deatilsMap.isNotEmpty)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(children: [
                              Text(
                                deatilsMap.last.locationDescription,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  '${deatilsMap.last.option} : ${deatilsMap.last.value}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18))
                            ]),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
        if (onLoad.value)
          Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () async {
                      agriTab.value = 0;
                    },
                    child: Container(
                      // width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: agriTab.value == 0 ? kColorBlue : Colors.white,
                      ),
                      height: 35,
                      child: Center(
                        child: Text(
                          'Details',
                          style: kTextStyleSubtitle4b,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () async {
                      agriTab.value = 1;
                    },
                    child: Container(
                      // width: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: kColorBlue),
                        borderRadius: BorderRadius.circular(10),
                        color: agriTab.value == 1 ? kColorBlue : Colors.white,
                      ),
                      height: 35,
                      child: Center(
                        child: Text(
                          'Map',
                          style: kTextStyleSubtitle4b,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (agriTab.value != 0)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 100),
              child: Container(
                width: 150,
                height: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // color: Colors.black.withOpacity(.1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Legends'),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 270,
                        child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          scrollDirection: Axis.vertical,
                          itemCount: dailyLegends.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    dailyLegends[index].title,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  SizedBox(
                                    width: 12,
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
        if (agriTab.value != 0)
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
                            McaoSearchList(navClose: true)
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
      ]),
    );
  }

  // Future<void> getMap(BuildContext context) async {
  //   final dailyProvider = context.read<McaoProvider>();
  //   dailyProvider.setPolygonDaiyClear();
  //   Set<Polygon> polygons = {};
  //   for (var i = 1; i < 116; i++) {
  //     final result = await McaoService.getAssessment(context, i.toString());

  //     try {
  //       polygons.clear();

  //       for (var name in result) {
  //         List<dynamic> coordinates = name.coordinates;
  //         List<LatLng> polygonCoords = [];
  //         if (coordinates.isNotEmpty) {
  //           for (var coor in coordinates) {
  //             var latLng = coor['coordinate'].toString().split(",");
  //             double latitude = double.parse(latLng[0]);
  //             double longitude = double.parse(latLng[1]);

  //             polygonCoords.add(LatLng(longitude, latitude));
  //           }
  //           Color lxColor = Colors.transparent;
  //           dailyProvider.setPolygonDaiy(Polygon(
  //               onTap: () async {},
  //               consumeTapEvents: true,
  //               polygonId: PolygonId(name.provinceID),
  //               points: polygonCoords,
  //               strokeWidth: 4,
  //               fillColor: lxColor,
  //               strokeColor: lxColor));
  //         }
  //       }
  //     } catch (e) {
  //       print('error $e');
  //     }
  //   }
  // }

  String monthReturn(int val) {
    if (val == 1) {
      return 'JANUARY';
    } else if (val == 2) {
      return 'FEBRUARY';
    } else if (val == 3) {
      return 'MARCH';
    } else if (val == 4) {
      return 'APRIL';
    } else if (val == 5) {
      return 'MAY';
    } else if (val == 6) {
      return 'JUNE';
    } else if (val == 7) {
      return 'JULY';
    } else if (val == 8) {
      return 'AUGUST';
    } else if (val == 9) {
      return 'SEPTEMBER';
    } else if (val == 10) {
      return 'OCTOBER';
    } else if (val == 11) {
      return 'NOVEMBER';
    } else if (val == 12) {
      return 'DECEMBER';
    } else {
      return 'JANUARY';
    }
  }
}
