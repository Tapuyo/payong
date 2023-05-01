
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:payong/provider/mcao_provider.dart';
import 'package:payong/services/mcao_services.dart';
import 'package:payong/utils/hex_to_color.dart';
import 'package:payong/utils/themes.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class  outlookPage extends HookWidget {

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.051436, 122.880019),
    zoom: 4.8,
  );

 @override
  Widget build(BuildContext context) {
    final dailyProviderPolygon = useState(context.read<McaoProvider>().polygons);
    final agriTab = useState(0);


    // useEffect(() {
    //   Future.microtask(() async {
    //     await getMap(context);
    //   });
    //   return;
    // }, []);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 150,
      child: Stack(children: [
        SizedBox(
            width: MediaQuery.of(context).size.width,
            child: agriTab.value == 0 ? const WebView(
                initialUrl:
                    'http://18.139.91.35/payong/outlook.php?fdate=APRIL%202023'):SizedBox(
                        height: 
                           MediaQuery.of(context).size.height - 150 ,
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
                      ),),
        
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

  
}
