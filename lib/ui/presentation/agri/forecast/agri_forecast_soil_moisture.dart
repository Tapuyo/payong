// ignore_for_file: prefer_const_constructors
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:payong/models/agri_forecast_weather_model.dart';
import 'package:payong/models/agri_soil_condition.dart';
import 'package:payong/provider/agri_provider.dart';
import 'package:payong/services/agri_service.dart';
import 'package:payong/utils/themes.dart';
import 'package:provider/provider.dart';

bool dayNow = true;

class AgriForecastSoilMoistWidget extends HookWidget {
  const AgriForecastSoilMoistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<AgriForecastSoilConditionModel>? dailyAgriDetails =
        context.select((AgriProvider p) => p.agriForecastSoilCondition);
    useEffect(() {
      Future.microtask(() async {
        await AgriServices.getForecastSoilCondition(context);
      });
      return;
    }, []);

    return dailyAgriDetails != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height + 200,
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 500),
                scrollDirection: Axis.vertical,
                itemCount: dailyAgriDetails.length,
                itemBuilder: (context, index) {
                //   return Card(
                //       child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Row(
                //             children: [
                //               Expanded(
                //                   flex: 2,
                //                   child: Text(
                //                     dailyAgriDetails[index].locations,
                //                     style: kTextStyleSubtitle4b,
                //                   )),
                //               Spacer(),
                //               Expanded(
                //                   flex: 3,
                //                   child: Text(
                //                     dailyAgriDetails[index].weatherCondition,
                //                     style: kTextStyleSubtitle4b,
                //                   )),
                //               Expanded(
                //                   flex: 1,
                //                   child:
                //                       SizedBox(
                // width: 50,
                // height: 50,
                // child: Image.asset('assets/sunny.png'))),
                //             ],
                //           )));
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
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(113, 157, 130, 1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                    dailyAgriDetails[index].soilCondition,
                                    style: GoogleFonts.roboto(
                                        textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'NunitoSans',
                                    )),
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
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 10),
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
                                      child: Image.asset(
                                          'assets/soilmoistnormal.jpg')),
                                )
                              ]),
                        ],
                      ),
                    ),
                );
                },
              ),
              // child: SoilMoisture(context),
            ),
          )
        : SizedBox();
  }

  

}
