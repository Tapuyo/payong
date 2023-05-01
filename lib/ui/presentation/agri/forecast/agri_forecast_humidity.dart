// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payong/models/agri_forecast_humidity_model.dart';
import 'package:payong/models/agri_forecast_model.dart';
import 'package:payong/models/agri_forecast_temperature_model.dart';
import 'package:payong/models/daily_model.dart';
import 'package:payong/provider/agri_provider.dart';
import 'package:payong/provider/daily_provider.dart';
import 'package:payong/provider/init_provider.dart';
import 'package:payong/services/agri_service.dart';
import 'package:payong/services/daily_services.dart';
import 'package:payong/utils/hex_to_color.dart';
import 'package:payong/utils/themes.dart';
import 'package:provider/provider.dart';

bool dayNow = true;

class AgriForecastHumidityWidget extends HookWidget {
  const AgriForecastHumidityWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<AgriForecastHumidityModel>? dailyAgriDetails =
        context.select((AgriProvider p) => p.agriForecastHumidity);
    useEffect(() {
      Future.microtask(() async {
        await AgriServices.getForecastHumidity(context);
      });
      return;
    }, []);

    return dailyAgriDetails != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height + 100,
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 500),
                scrollDirection: Axis.vertical,
                itemCount: dailyAgriDetails.length,
                itemBuilder: (context, index) {
                  // return Card(
                  //     child: Padding(
                  //   padding: const EdgeInsets.all(12.0),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //           flex: 3,
                  //           child: Text(
                  //             dailyAgriDetails[index].locations,
                  //             style: kTextStyleSubtitle4b,
                  //           )),
                  //       Spacer(),
                  //       Expanded(
                  //           flex: 3,
                  //           child: Text(
                  //             '${dailyAgriDetails[index].minHumidity}% - ${dailyAgriDetails[index].maxHumidity}%',
                  //             style: kTextStyleSubtitle4b,
                  //           )),
                  //       Expanded(
                  //           flex: 1,
                  //           child: SizedBox(
                  //               width: 50,
                  //               height: 50,
                  //               child:
                  //                   Image.asset('assets/soilmoistnormal.jpg'))),
                  //     ],
                  //   ),
                  // ));
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black)),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                          color: Color.fromRGBO(33, 150, 243, 1),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10) ),),
                            
                            child: SizedBox(
                              height: 40,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${dailyAgriDetails[index].minHumidity}%',
                                    style: GoogleFonts.roboto(
                                        textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'NunitoSans',
                                    )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                                  child: Text(
                                    dailyAgriDetails[index].locations,
                                    style: kTextStyleSubtitle4b,
                                  ),
                                )
                              ],
                            )),
                            Expanded(
                              child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child:
                                      Image.asset('assets/humidity.png')),
                            )
                          ]),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        : SizedBox();
  }
}
