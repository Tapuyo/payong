// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

class AgriForecastTempWidget extends HookWidget {
  const AgriForecastTempWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<AgriForecastTempModel>? dailyAgriDetails =
        context.select((AgriProvider p) => p.agriForecastTemp);
    useEffect(() {
      Future.microtask(() async {
        await AgriServices.getForecastTemp(context);
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
                  return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                                          children: [
                        Expanded(
                            flex: 3,
                            child: Text(
                              dailyAgriDetails[index].locations,
                              style: kTextStyleSubtitle4b,
                            )),
                            Spacer(),
                        Expanded(
                            flex: 2,
                            child: Text('High Land \n${dailyAgriDetails[index].highLandMaxTemp} - ${dailyAgriDetails[index].highLandMinTemp}',
                              style: kTextStyleSubtitle4b,
                            )),
                        Expanded(
                            flex: 2,
                            child: Text('Low Land \n${dailyAgriDetails[index].lowLandMaxTemp} - ${dailyAgriDetails[index].lowLandMinTemp}',
                              style: kTextStyleSubtitle4b,
                            )),
                                          ],
                                        ),
                      ));
                },
              ),
            ),
          )
        : SizedBox();
  }
}
