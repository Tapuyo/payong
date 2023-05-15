import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:payong/models/daily_legend_model.dart';
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
  }

  getMapAll(BuildContext context) async {
    await McaoService.getDailyLegend(context);
     await getMap(context);
  }

  Future<void> getMap(BuildContext context) async {
    final dailyProvider = context.read<McaoProvider>();
    dailyProvider.setPolygonDaiyClear();
    Set<Polygon> polygons = {};
    for (var i = 1; i < 116; i++) {
      final result = await McaoService.getAssessment(context, i.toString());

      polygons.clear();

      for (var name in result) {
        print(name.locationDescription);
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

          try{
            lxColor = name.color.toColor();
          }catch(e){

          }
          dailyProvider.setPolygonDaiy(Polygon(
              onTap: () async {
                print(name.provinceID);
              },
              consumeTapEvents: true,
              polygonId: PolygonId(name.provinceID),
              points: polygonCoords,
              strokeWidth: 4,
              fillColor: lxColor,
              strokeColor: lxColor));
        }
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
       
      ],
    );
  }

}
