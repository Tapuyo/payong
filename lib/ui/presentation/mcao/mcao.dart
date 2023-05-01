import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:payong/provider/mcao_provider.dart';
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
  }

  getMapAll(BuildContext context)async{
       await getMap(context);
  }

  Future<void> getMap(BuildContext context) async {
  
    final dailyProvider = context.read<McaoProvider>();
    dailyProvider.setPolygonDaiyClear();
    Set<Polygon> polygons = {};
    for (var i = 1; i < 2; i++) {
      final result = await McaoService.getAssessment(context);

      try {
          polygons.clear();

          for (var name in result) {
            print(name.provinceID);
            List<dynamic> coordinates = name.coordinates;
            List<LatLng> polygonCoords = [];
            if (coordinates.isNotEmpty) {
              for (var coor in coordinates) {
                var latLng = coor['coordinate'].toString().split(",");
                print(double.parse(latLng[0]).toString());
                double latitude = double.parse(latLng[0]);
                double longitude = double.parse(latLng[1]);

                polygonCoords.add(LatLng(longitude, latitude));
              }
               Color lxColor = name.color.toColor();
              dailyProvider.setPolygonDaiy(Polygon(
                  onTap: () async {
                   
                  },
                  consumeTapEvents: true,
                  polygonId: PolygonId(name.provinceID),
                  points: polygonCoords,
                  strokeWidth: 4,
                  fillColor: lxColor,
                  strokeColor: lxColor));
            }
          }
      } catch (e) {
        print('error $e');
      }
    }
   
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getMapAll(context);
    return Container(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    myTabs = 0;
                  });
                },
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: myTabs == 0
                        ? dayNow
                            ? kColorSecondary
                            : kColorBlue
                        : Colors.white,
                  ),
                  height: 50,
                  child: Center(
                    child: Text(
                      'Assessment',
                      style: kTextStyleSubtitle4b,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    myTabs = 1;
                  });
                },
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: myTabs == 1
                        ? dayNow
                            ? kColorSecondary
                            : kColorBlue
                        : Colors.white,
                  ),
                  height: 50,
                  child: Center(
                    child: Text(
                      'Outlook',
                      style: kTextStyleSubtitle4b,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (myTabs == 0) ...[
          assessmentPage(),
        ] else ...[
          outlookPage(),
        ]
      ]),
    );
  }

  Widget myBody() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Stack(children: [
        SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 200,
            child: const WebView(
                initialUrl:
                    'https://www.google.com/search?q=new+weather&sxsrf=APwXEdd6YwFewmlAnS8-3y2Zki_TVmQzKQ:1679942521829&source=lnms&tbm=isch&sa=X&ved=2ahUKEwiKy4bK4fz9AhWdp1YBHVoKDrgQ_AUoAnoECAMQBA&biw=1440&bih=789&dpr=1')),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  showMap = !showMap;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.2),
                  // ignore: prefer_const_literals_to_create_immutables
                ),
                height: showMap ? MediaQuery.of(context).size.width : 50,
                width: showMap ? MediaQuery.of(context).size.width / 1.5 : 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            showMap = !showMap;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 12, 0, 10),
                          child: Icon(!showMap
                              ? Icons.arrow_back_ios
                              : Icons.arrow_forward_ios),
                        )),
                    if (showMap)
                      SizedBox(
                        height: showMap
                            ? MediaQuery.of(context).size.width - 50
                            : 50,
                        width: showMap
                            ? MediaQuery.of(context).size.width / 1.5
                            : 50,
                        child: GoogleMap(
                          // myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          mapType: MapType.hybrid,
                          // polygons: polygons,
                          initialCameraPosition: _kGooglePlex,
                          zoomGesturesEnabled: true,
                          tiltGesturesEnabled: false,
                          onMapCreated: (GoogleMapController controller) {
                            // _controller.complete(controller);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
