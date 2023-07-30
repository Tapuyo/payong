// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:payong/utils/hex_to_color.dart';
import 'package:payong/utils/themes.dart';
import 'package:provider/provider.dart';

bool dayNow = true;
CarouselController buttonCarouselController = CarouselController();

class AgriAdvisoryWidget extends HookWidget {
  const AgriAdvisoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final agriTab = useState(0);
    if (DateTime.now().hour > 6 && DateTime.now().hour < 18) {
      //evening
      dayNow = true;
    } else {
      //day
      dayNow = false;
    }

    final bool isRefresh = context.select((AgriProvider p) => p.isRefresh);
    final String id = context.select((AgriProvider p) => p.dailyIDSelected);
    final List<AgriAdvModel>? dailyAgriDetails =
        context.select((AgriProvider p) => p.agriAdvModels);
    final String backImg =
        context.select((InitProvider p) => p.backImgAssetUrl);
    final bool withRain = context.select((InitProvider p) => p.withRain);
    ValueNotifier titleChoose = useState('');
    ValueNotifier contentChoose = useState('');
    ValueNotifier carouselInt = useState(0);
    useEffect(() {
      Future.microtask(() async {
        if (agriTab.value == 0) {
          await AgriServices.getAgriAdvisory(context, id, true, true);
        } else {
          await AgriServices.getAgriAdvisory(context, id, true, false);
        }
        if (dailyAgriDetails != null) {
          contentChoose.value = dailyAgriDetails[0].content;
        }
      });
      return;
    }, [id, agriTab.value]);

    return dailyAgriDetails != null
        ? Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: FittedBox(
                  child: Image.asset(backImg),
                  fit: BoxFit.fitHeight,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ColoredBox(color: Colors.white30),
              ),
              if (withRain)
                ParallaxRain(
                  // ignore: prefer_const_literals_to_create_immutables
                  dropColors: [Colors.white],
                  trail: true,
                  dropFallSpeed: 5,
                ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () async {
                                      contentChoose.value = '';
                                      agriTab.value = 0;
                                      await AgriServices.getAgriAdvisory(
                                          context, id, true, true);
                                      buttonCarouselController.nextPage(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.linear);
                                     
                                    },
                                    child: Container(
                                      // width: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: agriTab.value == 0
                                            ? dayNow
                                                ? kColorSecondary
                                                : kColorBlue
                                            : Colors.white,
                                      ),
                                      height: 35,
                                      child: Center(
                                        child: Text(
                                          'Farm',
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
                                      contentChoose.value = '';
                                      agriTab.value = 1;
                                      await AgriServices.getAgriAdvisory(
                                          context, id, true, false);
                                       buttonCarouselController.nextPage(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.linear);
                                    },
                                    child: Container(
                                      // width: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: agriTab.value == 1
                                            ? dayNow
                                                ? kColorSecondary
                                                : kColorBlue
                                            : Colors.white,
                                      ),
                                      height: 35,
                                      child: Center(
                                        child: Text(
                                          'Fishing',
                                          style: kTextStyleSubtitle4b,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CarouselSlider(
                            carouselController: buttonCarouselController,
                            options: CarouselOptions(
                                onPageChanged: (value, val) {
                                  carouselInt.value = value;
                                  contentChoose.value =
                                      dailyAgriDetails[value].content;
                                },
                                height: 140.0,
                                viewportFraction: 1,
                                autoPlay: false,
                                enlargeFactor: .4),
                            items: dailyAgriDetails.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return advisoryWidget(
                                      context, i, titleChoose, contentChoose);
                                },
                              );
                            }).toList(),
                          ),
                          if (contentChoose.value != '')
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 130),
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Container(
                                      margin: const EdgeInsets.all(15.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                          color: kColorBlue.withOpacity(.5),
                                          borderRadius: BorderRadius.circular(10),
                                          border:
                                              Border.all(color: kColorBlue)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          contentChoose.value,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            buttonCarouselController.nextPage(
                                                duration:
                                                    Duration(milliseconds: 100),
                                                curve: Curves.linear);
                            
                                            titleChoose.value = dailyAgriDetails[
                                                    carouselInt.value]
                                                .title;
                                          },
                                          child: Row(
                                            children: [
                                              Icon(Icons.arrow_back_ios),
                                              Icon(Icons.arrow_back_ios)
                                            ],
                                          )),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            buttonCarouselController.previousPage(
                                                duration:
                                                    Duration(milliseconds: 100),
                                                curve: Curves.linear);
                            
                                            titleChoose.value = dailyAgriDetails[
                                                    carouselInt.value]
                                                .title;
                                          },
                                          child: Row(
                                            children: [
                                              Icon(Icons.arrow_forward_ios),
                                              Icon(Icons.arrow_forward_ios)
                                            ],
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                        ]),
                  ),
                ),
              ),
            ],
          )
        : SizedBox();
  }

  Widget advisoryWidget(BuildContext context, AgriAdvModel? agriAdsModel,
      ValueNotifier titleChoose, ValueNotifier contentChoose) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () async {
            titleChoose.value = agriAdsModel!.title;
            contentChoose.value = agriAdsModel.content;
          },
          child: Container(
            // width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kColorBlue),
              color: kColorBlue.withOpacity(.5),
            ),
            // height: 40,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      agriAdsModel!.title,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Publish date: ${agriAdsModel!.datePublish}',
                      style: TextStyle(
                          fontSize: 14, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    //  Text(
                    //   "Valid until ${agriAdsModel!.dateValid}",
                    //   style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 63, 61, 61)),
                    //   textAlign: TextAlign.center,
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
