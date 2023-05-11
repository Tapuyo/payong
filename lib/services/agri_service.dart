import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:payong/models/agri_10_days_forecast.dart';
import 'package:payong/models/agri_10_forecast_model.dart';
import 'package:payong/models/agri_10_prognosis.dart';
import 'package:payong/models/agri_advisory_model.dart';
import 'package:payong/models/agri_advisory_model.dart';
import 'package:payong/models/agri_forecast_humidity_model.dart';
import 'package:payong/models/agri_forecast_leafwetness_model.dart';
import 'package:payong/models/agri_forecast_model.dart';
import 'package:payong/models/agri_forecast_temperature_model.dart';
import 'package:payong/models/agri_forecast_weather_model.dart';
import 'package:payong/models/agri_forecast_wind_model.dart';
import 'package:payong/models/agri_model.dart';
import 'package:payong/models/agri_soil_condition.dart';
import 'package:payong/models/daily_10_map.dart';
import 'package:payong/provider/agri_provider.dart';
import 'package:payong/utils/strings.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

abstract class AgriServices {
  static Future<void> getAgriSypnosis(BuildContext context) async {
    final response = await http.get(Uri.parse(parentAgri));
    var jsondata = json.decode(response.body);

    List<AgriModel> newDailyList = [];

    for (var u in jsondata) {
      AgriModel daily = AgriModel(u['AgriDailyID'] ?? '', u['DateIssue'] ?? '',
          u['ValidityDate'] ?? DateTime.now().toString(), u['Title'] ?? '', u['Content'] ?? '');
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setDailyDetails(newDailyList.first);
    dailyProvider.setDailyId(newDailyList.first.agriDailyID);
  }

  static Future<void> getAgriForecast(BuildContext context, String id) async {
    final responseParent = await http
        .get(Uri.parse('http://18.139.91.35/payong/API/agri_daily.php'));
    var jsondataParent = json.decode(responseParent.body);
    String agriID = '';
    for (var u in jsondataParent) {
      agriID = u['AgriInfoID'];
    }

    final response = await http.get(Uri.parse(
        'http://203.177.82.125:8081/payong_app/API/agri_daily_details.php?AgriDailyID=$agriID'));
    var jsondata = json.decode(response.body);

    List<AgriForecastModel> newDailyList = [];

    for (var u in jsondata) {
      List<String> humidityLocation = [];
      for (var humid in u['HumidityLocation']) {
        humidityLocation.add(humid['Provinces']);
      }

      List<String> leafWetnessLocation = [];
      for (var leaf in u['LeafWetnessLocation']) {
        leafWetnessLocation.add(leaf['Provinces']);
      }

      List<String> tempLocation = [];
      for (var temp in u['TempLocation']) {
        tempLocation.add(temp['Provinces']);
      }

      List<String> windContidionLocation = [];
      for (var wind in u['WindContidionLocation']) {
        windContidionLocation.add(wind['Regions']);
      }
      AgriForecastModel daily = AgriForecastModel(
          u['AgriDailyID'] ?? '',
          u['MinHumidity'] ?? '',
          u['MaxHumidity'] ?? '',
          humidityLocation,
          u['MinLeafWetness'] ?? '',
          u['MaxLeafWetness'] ?? '',
          leafWetnessLocation,
          u['LowLandcMinTemp'] ?? '',
          u['LowLandcMaxTemp'] ?? '',
          u['HighLandMinTemp'] ?? '',
          u['HighLandMaxTemp'] ?? '',
          tempLocation,
          u['WindCondition'] ?? '',
          windContidionLocation);
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setForecast(newDailyList);
  }

  static Future<void> getAgriAdvisory(
      BuildContext context, String id, bool daily, bool farm) async {
    final dailyProvider = context.read<AgriProvider>();

    dailyProvider.clearAdvisory();
    final responseParent = await http
        .get(Uri.parse('http://18.139.91.35/payong/API/agri_info.php'));
    var jsondataParent = json.decode(responseParent.body);

    String agriID = jsondataParent[0]['AgriInfoID'];
    print(agriID);
    var response;
    if (daily) {
      if (farm) {
        response = await http.get(Uri.parse(
            'http://18.139.91.35/payong/API/agri_daily_advisory.php?category=farm'));
      } else {
        response = await http.get(Uri.parse(
            'http://18.139.91.35/payong/API/agri_daily_advisory.php?category=fishing'));
      }
    } else {
      response = await http.get(Uri.parse(
          'http://18.139.91.35/payong/API/agri_advisory.php?AgriInfoID=$agriID'));
    }
    print(response.body);
    var jsondata = json.decode(response.body);

    List<AgriAdvModel> newDailyList = [];

    for (var u in jsondata) {
      List<AgriAdImgvModel> imgList = [];
     
     if(u['img'] != null){
      for (var image in u['img']) {
         AgriAdImgvModel img = AgriAdImgvModel(image['Img']);
         imgList.add(img);
      }}

      AgriAdvModel daily = AgriAdvModel(
        u['Titles'] ?? '',
        u['Content'] ?? '',
        imgList
      );
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously

    dailyProvider.setAdvisory(newDailyList);
  }

  static Future<void> getAgri10Days(
    BuildContext context,
    String id,
  ) async {
    final responseParent = await http
        .get(Uri.parse('http://18.139.91.35/payong/API/agri_info.php'));
    var jsondataParent = json.decode(responseParent.body);

    String agriID = jsondataParent[0]['AgriInfoID'];
    print(
        'http://18.139.91.35/payong/API/agri_FORECAST.php?AgriInfoID=$agriID');
    final response = await http.get(Uri.parse(
        'http://18.139.91.35/payong/API/agri_FORECAST.php?AgriInfoID=$agriID'));

    var jsondata = json.decode(response.body);

    List<Agri10DaysForecastvModel> newDailyList = [];

    for (var u in jsondata) {
      Agri10DaysForecastvModel daily = Agri10DaysForecastvModel(
        u['Title'] ?? '',
        u['Content'] ?? '',
      );
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setAgri10Forecast(newDailyList);
  }

  static Future<List<AgriRegionalForecast>> getAgri10DaysRegional(
    BuildContext context,
    String id,
  ) async {
    final response = await http
        .get(Uri.parse('http://18.139.91.35/payong/API/agri_forecast.php'));

    var jsondata = json.decode(response.body);

    List<AgriRegionalForecast> newDailyList = [];

    print('DATA FORECAST' + jsondata.toString());

    for (var u in jsondata) {
      List<AgriRegionalForecastWeatherSystem> weatherSystem = [];

      if(u['WeatherSystem'] != null){
      for (var a in u['WeatherSystem']) {
        AgriRegionalForecastWeatherSystem weather =
            AgriRegionalForecastWeatherSystem(
                a['Name'] ?? '', a['Description'] ?? '', a['Icon'] ?? '');
        weatherSystem.add(weather);
      }}

      List<AgriRegionalForecastWindCondition> windCondition = [];

       if(u['WindCondition'] != null){
      for (var a in u['WindCondition']) {
        AgriRegionalForecastWindCondition weather =
            AgriRegionalForecastWindCondition(
                a['Location'] ?? '', a['Description'] ?? '', a['Icon']?? '');
        windCondition.add(weather);
      }}

      List<AgriRegionalForecastGaleWarning> galeWarning = [];

       if(u['GaleWarning'] != null){
      for (var a in u['GaleWarning']) {
        AgriRegionalForecastGaleWarning weather =
            AgriRegionalForecastGaleWarning(
                a['Location']?? '', a['Description']?? '', a['Icon']?? '');
        galeWarning.add(weather);
      }}

      List<AgriRegionalForecastEnso> enso = [];

       if(u['EnsoWarning'] != null){
       for (var a in u['EnsoWarning']) {
        AgriRegionalForecastEnso weather = AgriRegionalForecastEnso(
          a['Location']?? '',
          a['Description'] ?? '',
          a['Icon']?? ''
        );
        enso.add(weather);
      }}

      List<AgriRegionalForecastMap> map = [];

      for (var a in u['Maps']) {
        AgriRegionalForecastMap weather = AgriRegionalForecastMap(
          a['Map']?? '',
          a['Description']?? '',
        );
        map.add(weather);
      }

      AgriRegionalForecast daily = AgriRegionalForecast(
          u['AgriInfoID'] ?? '',
          u['Title'] ?? '',
          u['Content'] ?? '',
          weatherSystem,
          windCondition,
          galeWarning,
          enso,
          map);
      newDailyList.add(daily);
    }
    print(newDailyList.last.content);
    return newDailyList;
  }

  static Future<void> getForecastTemp(
    BuildContext context,
  ) async {
    final responseParent = await http
        .get(Uri.parse('http://18.139.91.35/payong/API/agri_daily.php'));
    var jsondataParent = json.decode(responseParent.body);

    String agriID = jsondataParent[0]['AgriDailyID'];
    print('$agriForecastTempApi$agriID&option=Temperature');
    final response = await http
        .get(Uri.parse('$agriForecastTempApi$agriID&option=Temperature'));

    var jsondata = json.decode(response.body);

    List<AgriForecastTempModel> newDailyList = [];

    for (var u in jsondata) {
      print('asdasdasdasd');
      AgriForecastTempModel daily = AgriForecastTempModel(
        u['LowLandMinTemp'] ?? '',
        u['LowLandMaxTemp'] ?? '',
        u['HighLandMinTemp'] ?? '',
        u['HighLandMaxTemp'] ?? '',
        u['Locations'] ?? '',
         u['LowLandMinTempIcon'] ?? '',
          u['HighLandMinTempIcon'] ?? '',
      );
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setAgriForecastTemp(newDailyList);
  }

  static Future<void> getForecastWind(
    BuildContext context,
  ) async {
    final responseParent = await http
        .get(Uri.parse('http://18.139.91.35/payong/API/agri_daily.php'));
    var jsondataParent = json.decode(responseParent.body);

    String agriID = jsondataParent[0]['AgriDailyID'];
    final response = await http
        .get(Uri.parse('$agriForecastWindApi$agriID&option=WindCondition'));

    var jsondata = json.decode(response.body);

    List<AgriForecastWindModel> newDailyList = [];

    for (var u in jsondata) {
      AgriForecastWindModel daily = AgriForecastWindModel(
        u['WindCondition'] ?? '',
        u['Locations'] ?? '',
        u['WindConditionIcon'] ?? ''
      );
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setAgriForecastWind(newDailyList);
  }

  static Future<void> getForecastSoilCondition(
    BuildContext context,
  ) async {
    final responseParent = await http
        .get(Uri.parse('http://18.139.91.35/payong/API/agri_daily.php'));
    var jsondataParent = json.decode(responseParent.body);

    String agriID = jsondataParent[0]['AgriDailyID'];
    final response = await http.get(Uri.parse(
        'http://18.139.91.35//payong/API/AgriDailySoilCondition.php?AgriDailyID=1'));

    var jsondata = json.decode(response.body);

    List<AgriForecastSoilConditionModel> newDailyList = [];

    for (var u in jsondata) {
      AgriForecastSoilConditionModel daily = AgriForecastSoilConditionModel(
        u['SoilCondition'] ?? '',
        u['Locations'] ?? '',
      );
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setAgriForecastSoilCondition(newDailyList);
  }

  static Future<void> getForecastWeather(
    BuildContext context,
  ) async {
    final responseParent = await http
        .get(Uri.parse('http://18.139.91.35/payong/API/agri_daily.php'));
    var jsondataParent = json.decode(responseParent.body);

    String agriID = jsondataParent[0]['AgriDailyID'];
    final response = await http.get(
        Uri.parse('$agriForecastWeatherApi$agriID&option=WeatherCondition'));

    var jsondata = json.decode(response.body);

    List<AgriForecastWeatherModel> newDailyList = [];

    for (var u in jsondata) {
      AgriForecastWeatherModel daily = AgriForecastWeatherModel(
        u['WeatherCondition'] ?? '',
        u['Locations'] ?? '',
        u['WeatherConditionIcon']
      );
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setAgriForecastWeather(newDailyList);
  }

  static Future<void> getForecastHumidity(
    BuildContext context,
  ) async {
    final responseParent = await http
        .get(Uri.parse('http://18.139.91.35/payong/API/agri_daily.php'));
    var jsondataParent = json.decode(responseParent.body);

    String agriID = jsondataParent[0]['AgriDailyID'];
    print('$agriForecastHumidityApi$agriID&option=Humidity');
    final response = await http
        .get(Uri.parse('$agriForecastHumidityApi$agriID&option=Humidity'));

    var jsondata = json.decode(response.body);

    List<AgriForecastHumidityModel> newDailyList = [];

    for (var u in jsondata) {
      AgriForecastHumidityModel daily = AgriForecastHumidityModel(
        u['MinHumidity'] ?? '',
        u['MaxHumidity'] ?? '',
        u['Locations'] ?? '',
        u['HumidityIcon'] ?? '',
      );
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setAgriForecastHumidity(newDailyList);
  }

  static Future<void> getForecastLeafwetness(
    BuildContext context,
  ) async {
    final responseParent = await http
        .get(Uri.parse('http://18.139.91.35/payong/API/agri_daily.php'));
    var jsondataParent = json.decode(responseParent.body);

    String agriID = jsondataParent[0]['AgriDailyID'];
    final response = await http.get(
        Uri.parse('$agriForecastLeafWetnessApi$agriID&option=LeafWetness'));

    var jsondata = json.decode(response.body);

    List<AgriForecastLeafWetnessModel> newDailyList = [];

    for (var u in jsondata) {
      AgriForecastLeafWetnessModel daily = AgriForecastLeafWetnessModel(
        u['MinLeafWetness'] ?? '',
        u['MaxLeafWetness'] ?? '',
        u['Locations'] ?? '',
        u['LeafWetnessIcon'] ?? '',
      );
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    final dailyProvider = context.read<AgriProvider>();
    dailyProvider.setAgriForecastLeafwetness(newDailyList);
  }

  static Future<List<Daily10MapModel>> getRegionMap(
      BuildContext context, String page) async {
    final response = await http.get(Uri.parse(
        'http://18.139.91.35/payong/API/regioncoordinates.php?page=1'));
    var jsondata = json.decode(response.body);

    List<Daily10MapModel> newDailyList = [];

    for (var u in jsondata) {
      Daily10MapModel daily = Daily10MapModel(u['RegionID'] ?? '',
          u['RegionDescription'] ?? '', u['coordinates'] ?? []);
      newDailyList.add(daily);
    }
    // ignore: use_build_context_synchronously
    return newDailyList;
  }

  static Future<List<Agri10Prognosis>> getProgDetails(BuildContext context, String id) async {
    // id = '7';
    print('http://18.139.91.35/payong/API/prognosis.php?AgriInfoID=$id');
    final response = await http.get(Uri.parse(
        'http://18.139.91.35/payong/API/prognosis.php?AgriInfoID=$id'));
    var jsondata = json.decode(response.body);
    final dailyProvider = context.read<AgriProvider>();
    List<Agri10Prognosis> newDailyList = [];

    print(jsondata.toString());

    for (var u in jsondata) {
      List<SoilConditionModeil>  soilCondition = [];

      for (var a in u['SoilCondition']) {
        SoilConditionModeil soil = SoilConditionModeil(
          a['SoilCondition'],
          a['Location']
        );
        soilCondition.add(soil);
      }

      Agri10Prognosis daily = Agri10Prognosis(
        u['AgriInfoID'] ?? '',
        u['RegionDescription'] ?? '',
        u['Title'] ?? '',
        u['Content'] ?? '',
        u['RainFall'] ?? '',
        u['RainyDays'] ?? '',
        u['RelativeHumidity'] ?? '',
        soilCondition,
        u['Temperature'].toString(),
      );
      newDailyList.add(daily);
    }
     dailyProvider.setProg(newDailyList);
    return newDailyList;
  }
}
