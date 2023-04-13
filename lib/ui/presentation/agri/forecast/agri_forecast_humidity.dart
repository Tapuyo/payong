// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                            flex: 3,
                            child: Text('${dailyAgriDetails[index].minHumidity} - ${dailyAgriDetails[index].maxHumidity}',
                              style: kTextStyleSubtitle4b,
                            )),
                        Expanded(
                                  flex: 1,
                                  child:
                                      Icon(FontAwesomeIcons.glassWaterDroplet)),
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
