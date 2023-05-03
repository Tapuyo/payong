import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:payong/provider/daily10_provider.dart';
import 'package:payong/provider/mcao_provider.dart';
import 'package:payong/services/agri_service.dart';
import 'package:payong/services/mcao_services.dart';
import 'package:payong/utils/hex_to_color.dart';
import 'package:payong/utils/themes.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class assessmentPage extends HookWidget {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.051436, 122.880019),
    zoom: 4.8,
  );

  @override
  Widget build(BuildContext context) {
    final dailyProviderPolygon =
        useState(context.read<McaoProvider>().polygons);
    final agriTab = useState(0);
    final onLoad = useState(true);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 150,
      child: Stack(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: agriTab.value == 0
              ?  WebView(
                  initialUrl:
                      'http://18.139.91.35/payong/assessment.php?fdate=APRIL%202023',
                  onPageFinished:(url){
                    onLoad.value = false;
                  },
                )
                
              : SizedBox(
                  height: MediaQuery.of(context).size.height - 150,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: GoogleMap(
                      // myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      mapType: MapType.normal,
                      polygons: dailyProviderPolygon.value!,
                      initialCameraPosition: _kGooglePlex,
                      zoomGesturesEnabled: true,
                      tiltGesturesEnabled: false,
                      onMapCreated: (GoogleMapController controller) {
                        // _controller.complete(controller);
                      },
                    ),
                  ),
                ),
        ),
        if(onLoad.value) Align(
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
        )
      ]),
    );
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
                onTap: () async {},
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
}
