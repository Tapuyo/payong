
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class  outlookPage extends HookWidget {

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.051436, 122.880019),
    zoom: 4.8,
  );

  @override
  Widget build(BuildContext context) {
    final showMap = useState(false);
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Stack(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 200,
          child: const WebView(initialUrl: 'http://18.139.91.35/payong/outlook.php')),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: GestureDetector(
               onTap: () {
                        
                            showMap.value = !showMap.value;
                          
                        },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.2),
                  // ignore: prefer_const_literals_to_create_immutables
                
                ),
                height: showMap.value ? MediaQuery.of(context).size.width : 50,
                width: showMap.value ? MediaQuery.of(context).size.width / 1.5 : 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () {
                          
                            showMap.value = !showMap.value;
                          
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 12, 0, 10),
                          child: Icon(!showMap.value
                              ? Icons.arrow_back_ios
                              : Icons.arrow_forward_ios),
                        )),
                    if (showMap.value)
                      SizedBox(
                        height: showMap.value
                            ? MediaQuery.of(context).size.width - 50
                            : 50,
                        width: showMap.value
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