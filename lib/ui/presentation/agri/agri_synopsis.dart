// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parallax_rain/parallax_rain.dart';
import 'package:payong/models/agri_model.dart';
import 'package:payong/models/daily_model.dart';
import 'package:payong/provider/agri_provider.dart';
import 'package:payong/provider/daily_provider.dart';
import 'package:payong/provider/init_provider.dart';
import 'package:payong/services/daily_services.dart';
import 'package:payong/utils/hex_to_color.dart';
import 'package:payong/utils/themes.dart';
import 'package:provider/provider.dart';

bool dayNow = true;

class AgriSynopsisWidget extends HookWidget {
  const AgriSynopsisWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (DateTime.now().hour > 6 && DateTime.now().hour < 18) {
      //evening
      dayNow = true;
    } else {
      //day
      dayNow = false;
    }
    String asd =
        "<strong><span class=\"ILfuVd\" lang=\"en\"><span class=\"hgKElc\">They went to fetch a pail of water, but unfortunately, their plan is disrupted when Jack falls and hits his head, and rolls back down the hill. Then, Jill falls too, and comes tumbling down after Jack. As you can see, the synopsis outlines what happens in the story.<\/span><\/span><\/strong>";
    final bool isRefresh = context.select((AgriProvider p) => p.isRefresh);
    final String id = context.select((AgriProvider p) => p.dailyIDSelected);
    final String? locId = context.select((InitProvider p) => p.myLocationId);
    final String backImg = context.select((InitProvider p) => p.backImgAssetUrl);
    final bool withRain = context.select((InitProvider p) => p.withRain);
    final AgriModel? agriSypnosis =
        context.select((AgriProvider p) => p.dailyDetails);
    DateTime pubDate =
        DateFormat("yyyy-MM-dd").parse(agriSypnosis != null ? agriSypnosis.dateIssue:DateTime.now().toString());
    final String publishDate = DateFormat.yMMMMd('en_US').format(pubDate);
    print(withRain);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Container(
        
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.blue,
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Image.asset(backImg),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ColoredBox(color: Colors.white30),),
            if(withRain) ParallaxRain(
                  // ignore: prefer_const_literals_to_create_immutables
                  dropColors: [Colors.white],
                  trail: true,
                  dropFallSpeed: 5,
                ),
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  agriSypnosis != null
                      ? 'Publish Date ${publishDate.toString()}'
                      : 'No Data',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  agriSypnosis != null ? agriSypnosis.title : 'No Data',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white60,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
                    child: Text(agriSypnosis != null ?
                      agriSypnosis.content: '',
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'NunitoSans',
                              wordSpacing: 2)),
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
