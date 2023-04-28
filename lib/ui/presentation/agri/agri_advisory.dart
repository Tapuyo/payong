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
    ValueNotifier titleChoose = useState('');
    ValueNotifier contentChoose = useState('');
    useEffect(() {
      Future.microtask(() async {
        await AgriServices.getAgriAdvisory(context, id, true);
      });
      return;
    }, [id]);

    return dailyAgriDetails != null
        ? Stack(
          children: [
            SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 150,
            child: FittedBox(
              child: Image.asset('assets/manila.jpeg'),
              fit: BoxFit.fitHeight,
            ),
          ),
           Container(
              width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 150,
            child: ColoredBox(color: Colors.white54),),
            SizedBox(
                height: MediaQuery.of(context).size.height - 180,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Advisory for ${DateFormat.MMMEd().format(DateTime.now()).toString()}",
                                  style: kTextStyleSubtitle4b,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () async {
                                    agriTab.value = 0;
                                    await AgriServices.getAgriAdvisory(
                                        context, id, true);
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
                              SizedBox(width: 8,),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () async {
                                    agriTab.value = 1;
                                    await AgriServices.getAgriAdvisory(
                                        context, id, true);
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
                          SizedBox(
                            height: 20,
                          ),
                          CarouselSlider(
                            carouselController: buttonCarouselController,
                            options: CarouselOptions(
                                height: 100.0,
                                viewportFraction: .9,
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
                            Container(
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                color: Colors.white30,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  contentChoose.value,
                                  style: kTextStyleSubtitle4b,
                                ),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  buttonCarouselController.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.linear);
                                },
                                child: Container(
                                  width: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: kColorBlue,
                                  ),
                                  height: 35,
                                  child: Center(
                                    child: Text(
                                      'Next',
                                      style: kTextStyleSubtitle4b,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
      flex: 1,
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
                                border: Border.all(color: Colors.black),
              color: titleChoose.value == agriAdsModel!.title
                  ? kColorBlue
                  : Colors.white,
            ),
            height: 35,
            child: Center(
              child: Text(
                agriAdsModel.title,
                style: kTextStyleSubtitle4b,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
