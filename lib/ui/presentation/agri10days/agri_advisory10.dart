// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parallax_rain/parallax_rain.dart';
import 'package:payong/models/agri_advisory_model.dart';
import 'package:payong/models/agri_forecast_model.dart';
import 'package:payong/models/daily_model.dart';
import 'package:payong/provider/agri_provider.dart';
import 'package:payong/provider/daily_provider.dart';
import 'package:payong/provider/init_provider.dart';
import 'package:payong/services/agri_service.dart';
import 'package:payong/services/daily_services.dart';
import 'package:payong/ui/presentation/agri10days/components/agri_advisory_view_pdf.dart';
import 'package:payong/utils/hex_to_color.dart';
import 'package:payong/utils/themes.dart';
import 'package:provider/provider.dart';

bool dayNow = true;

class AgriAdvisory10Widget extends HookWidget {
  const AgriAdvisory10Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (DateTime.now().hour > 6 && DateTime.now().hour < 18) {
      //evening
      dayNow = true;
    } else {
      //day
      dayNow = false;
    }

    final bool isRefresh = context.select((AgriProvider p) => p.isRefresh);
    final String id = context.select((AgriProvider p) => p.dailyIDSelected);
    final String backImg =
        context.select((InitProvider p) => p.backImgAssetUrl);
    final bool withRain = context.select((InitProvider p) => p.withRain);
    final List<AgriAdvModel>? dailyAgriDetails =
        context.select((AgriProvider p) => p.agriAdvModels);

    useEffect(() {
      Future.microtask(() async {
        await AgriServices.getAgriAdvisory(context, id, false, true);
      });
      return;
    }, [id]);
    print(withRain);
    return dailyAgriDetails != null
        ? Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Image.asset(backImg),
                ),
              ),
              if (withRain)
                ParallaxRain(
                  // ignore: prefer_const_literals_to_create_immutables
                  dropColors: [Colors.white],
                  trail: true,
                  dropFallSpeed: 5,
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height + 1000,
                              child: ListView.builder(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                                scrollDirection: Axis.horizontal,
                                itemCount: dailyAgriDetails.length,
                                itemBuilder: (context, index) {
                                  return advisoryWidget(
                                      context, dailyAgriDetails[index]);
                                },
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            ],
          )
        : SizedBox();
  }

  Widget advisoryWidget(BuildContext context, AgriAdvModel? agriAdsModel) {
    return agriAdsModel != null
        ? Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        agriAdsModel.title,
                        style: kTextStyleSubtitle4b,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              if (agriAdsModel.img.isNotEmpty)
                                SizedBox(
                                  width: 300,
                                  height: 250,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: agriAdsModel.img.length,
                                    itemBuilder: (BuildContext context,
                                            int index) =>
                                        SizedBox(
                                            width: 250,
                                            height: 200,
                                            child: Image.network(
                                                agriAdsModel.img[index].img)),
                                  ),
                                ),
                              SizedBox(
                                height: 12,
                              ),
                              ElevatedButton(
                                  child: Text("Read more",
                                      style: TextStyle(fontSize: 14)),
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.blue),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              side: BorderSide(
                                                  color: Colors.blue)))),
                                  onPressed: () {
                                     Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                         AgriAvisoryViewPdf(urlPdf: agriAdsModel.content)),
                              );
                                  }),
                              // Text(
                              //   agriAdsModel.content,
                              //   style: TextStyle(color: Colors.black),
                              //   textAlign: TextAlign.justify,
                              // ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ])
        : SizedBox();
  }
}
