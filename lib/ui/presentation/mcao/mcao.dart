import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:payong/utils/themes.dart';
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
      dayNow = true;
    } else {
      //day
      dayNow = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        myBody(),
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
          child: const WebView(initialUrl: 'https://www.google.com/search?q=new+weather&sxsrf=APwXEdd6YwFewmlAnS8-3y2Zki_TVmQzKQ:1679942521829&source=lnms&tbm=isch&sa=X&ved=2ahUKEwiKy4bK4fz9AhWdp1YBHVoKDrgQ_AUoAnoECAMQBA&biw=1440&bih=789&dpr=1')),
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
