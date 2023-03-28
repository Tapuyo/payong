// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:payong/provider/agri_provider.dart';
import 'package:payong/provider/init_provider.dart';
import 'package:payong/services/daily_services.dart';
import 'package:payong/services/getLocationId.dart';
import 'package:payong/ui/drawer/drawer.dart';
import 'package:payong/ui/main_nav.dart';
import 'package:payong/utils/themes.dart';
import 'package:payong/routes/routes.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool notifnum = false;
  bool isDrawerOpen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentLocation();

    print('firebase request permission');
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      sound: true,
    );

    print('firebase get token');
    FirebaseMessaging.instance.getToken().then((value) {
      print("This is the token: " + value!);
    });

    print('firebase listen message');
    FirebaseMessaging.onMessage.listen((event) {
      print("message recieved");
      print(event.notification!.body);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Notification"),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });

    print('firebase onclick message');
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });

    print('firebase set foreground notif');
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  getCurrentLocation() async {
    Position result = await _determinePosition();
    final dailyProvider = context.read<InitProvider>();
    if (result != null) {
      print(result.latitude);
      print(result.longitude);
      dailyProvider.setPosition(result);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(result.latitude, result.longitude);
      // print(placemarks.toList().toString());
      String locationFilter =
          '${placemarks.first.locality.toString()},${placemarks.first.administrativeArea.toString()}';
      final locID = await SystemService.getLocationId(context, locationFilter);
      final intProv = context.read<InitProvider>();
      print(locID);
      intProv.setLocationId(locID);
    }
// DateTime selectedDate = DateTime.now();
//      String dt = DateFormat('yyyy-MM-dd').format(selectedDate);
//     await DailyServices.getDailyList(context, mod, dt);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        DrawerPage(
          onTap: () {
            setState(
              () {
                xOffset = 0;
                yOffset = 0;
                scaleFactor = 1;
                isDrawerOpen = false;
              },
            );
          },
          key: const Key('value'),
        ),
        AnimatedContainer(
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(scaleFactor)
            ..rotateY(isDrawerOpen ? -0.5 : 0),
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0),
            child: Scaffold(
                // appBar: AppBar(
                //   elevation: 0,
                //   leading: isDrawerOpen
                //       ? IconButton(
                //           icon: const Icon(
                //             Icons.arrow_back_ios,
                //             size: 35,
                //           ),
                //           onPressed: () {
                //             setState(
                //               () {
                //                 xOffset = 0;
                //                 yOffset = 0;
                //                 scaleFactor = 1;
                //                 isDrawerOpen = false;
                //               },
                //             );
                //           },
                //         )
                //       : IconButton(
                //           icon: const Icon(
                //             Icons.menu,
                //             size: 35,
                //           ),
                //           onPressed: () {
                //             setState(() {
                //               xOffset = size.width - size.width / 3;
                //               yOffset = size.height * 0.1;
                //               scaleFactor = 0.8;
                //               isDrawerOpen = true;
                //             });
                //           },
                //         ),
                //   title: const Text('Payong'),
                //   actions: <Widget>[
                //     Stack(
                //       children: <Widget>[
                //         IconButton(
                //           onPressed: () {},
                //           icon: Icon(
                //             Icons.notifications_none,
                //             color:
                //                 notifnum == true ? kColorDarkBlue : Colors.grey,
                //             size: 35,
                //           ),
                //         ),
                //         Visibility(
                //           visible: notifnum,
                //           child: const Positioned(
                //             top: 20,
                //             right: 10,
                //             child: SizedBox(
                //               width: 20,
                //               child: CircleAvatar(
                //                   backgroundColor: kColorBlue,
                //                   child: Text(
                //                     'Avatar',
                //                     style: TextStyle(
                //                         color: Colors.white, fontSize: 8),
                //                   )),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                body: bodyWidget()),
          ),
        ),
      ],
    );
  }

  Widget bodyWidget() {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                // ignore: prefer_const_literals_to_create_immutables
                colors: [
                  Color(0xFF005EEB),
                  Color(0xFF489E59),
                  Color(0xFFF2E90B),
                  Color(0xFF762917),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.clamp),
          ),
          child: Column(
            children: [
              Container(
                height: 280.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(
                          MediaQuery.of(context).size.width / 1.2, 150.0)),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: isDrawerOpen
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.arrow_back_ios,
                                          size: 35,
                                        ),
                                        onPressed: () {
                                          setState(
                                            () {
                                              xOffset = 0;
                                              yOffset = 0;
                                              scaleFactor = 1;
                                              isDrawerOpen = false;
                                            },
                                          );
                                        },
                                      )
                                    : IconButton(
                                        icon: const Icon(
                                          Icons.menu,
                                          size: 35,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            xOffset =
                                                size.width - size.width / 3;
                                            yOffset = size.height * 0.1;
                                            scaleFactor = 0.8;
                                            isDrawerOpen = true;
                                          });
                                        },
                                      ),
                              ),
                              // Spacer(),
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      child: Image.asset(
                                        'assets/payonglogo.png',
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.notifications_none,
                                      color: notifnum == true
                                          ? kColorDarkBlue
                                          : Colors.grey,
                                      size: 35,
                                    ),
                                  ),
                                  Visibility(
                                    visible: notifnum,
                                    child: const Positioned(
                                      top: 20,
                                      right: 10,
                                      child: SizedBox(
                                        width: 20,
                                        child: CircleAvatar(
                                            backgroundColor: kColorBlue,
                                            child: Text(
                                              'Avatar',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 8),
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        'PAYONG \nPAGASA',
                        style: kTextStyletitlew,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ]),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MainNav(index: 0)),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(17.0),
                                  color: const Color(0xffffffff),
                                ),
                                child: Center(
                                  //     child: Icon(
                                  //   Icons.cloud_done,
                                  //   color: kColorBlue,
                                  //   size: 40,
                                  // )
                                  child: Image.asset(
                                    'assets/daily.png',
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Daily \nMonitoring',
                                style: kTextStyleSubtitle12,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MainNav(index: 2)),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(17.0),
                                  color: const Color(0xffffffff),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/daily10days.png',
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                '10 Days',
                                style: kTextStyleSubtitle12,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MainNav(index: 4)),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(17.0),
                                  color: const Color(0xffffffff),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/monthly.png',
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Monthly \nCAaO',
                                style: kTextStyleSubtitle12,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainNav(index: 1)),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(17.0),
                                color: const Color(0xffffffff),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/agri.png',
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              'Daily Farm \nWeather Forecasts \nand Advisories',
                              style: kTextStyleSubtitle12,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 60,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainNav(index: 3)),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(17.0),
                                color: const Color(0xffffffff),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/agri10days.png',
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              '10-Day Regional \nAgri-weather \nInformation',
                              style: kTextStyleSubtitle12,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(height: 140.0, viewportFraction: .9, autoPlay: true,enlargeFactor:.4),
                      items: [1, 2, 3, 4, 5].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width - 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width:
                                      1, //                   <--- border width here
                                ),
                                borderRadius: BorderRadius.circular(17.0),
                                color: Color.fromARGB(255, 219, 186, 18),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      Text(
                                        'Lorem ipsum dolor sit amet, consectetur \nadipiscing elit,sed do eiusmod tempor \nincididunt ut labore et dolore \nmagna aliqua. Cursus risus at ultrices mi ',
                                        style: kTextStyleSubtitle3b,
                                      ),
                                      const Icon(
                                        Icons.tips_and_updates,
                                        color: kColorSecondary,
                                        size: 70,
                                      )
                                    ]),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
