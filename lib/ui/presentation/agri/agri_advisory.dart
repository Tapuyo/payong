// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class AgriAdvisoryWidget extends HookWidget {
  const AgriAdvisoryWidget({Key? key}) : super(key: key);

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
    final List<AgriAdvModel>? dailyAgriDetails =
        context.select((AgriProvider p) => p.agriAdvModels);
    useEffect(() {
      Future.microtask(() async {
        await AgriServices.getAgriAdvisory(context, id);
      });
      return;
    }, [id]);

    return dailyAgriDetails != null
        ? SizedBox(
            height: MediaQuery.of(context).size.height - 250,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height + 100,
                        child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 500),
                          scrollDirection: Axis.vertical,
                          itemCount: dailyAgriDetails.length,
                          itemBuilder: (context, index) {
                            return advisoryWidget(dailyAgriDetails[index]);
                          },
                        ),
                      ),
                    ]),
              ),
            ),
          )
        : SizedBox();
  }

  Widget advisoryWidget(AgriAdvModel? agriAdsModel) {
    return agriAdsModel != null
        ? Column(children: [
            Divider(
              thickness: 3,
            ),
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
                      SizedBox(
                        height: 18,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black26,
                        ),
                        child: Html(
                          shrinkWrap: true,
                          data: agriAdsModel.content,
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
