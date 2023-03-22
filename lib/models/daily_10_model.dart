class DailyModel10 {
  final String dailyDetailsID;
  final String locationDescription;
  final List<dynamic> locationCoordinate;
  final String rainFall;
  final String rainFallColorCode;
  final String rainFallPercentage;
  final String rainFallPercentageColorCode;
  final String lowTemp;
  final String lowTempColorCode;
  final String highTemp;
  final String highTempColorCode;
  final String rainFallDescription;
  final String cloudCover;
  final String humidity;
  final String windSpeed;
  final String windDirection;
  final String meanTemp;


  DailyModel10(
      this.dailyDetailsID,
      this.locationDescription,
      this.locationCoordinate,
      this.rainFall,
      this.rainFallColorCode,
      this.rainFallPercentage,
      this.rainFallPercentageColorCode,
      this.lowTemp,
      this.lowTempColorCode,
      this.highTemp,
      this.highTempColorCode,
      this.rainFallDescription,
      this.cloudCover,
      this.humidity,
      this.windSpeed,
      this.windDirection,
      this.meanTemp
      );


      
}


// "DailyDetailsID":"1",
//       "ForecastDate":"2023-03-03",
//       "LocationDescription":"Tayum,Abra",
//       "RainFall":"0",
//       "RainFallColorCode":"",
//       "RainFallPercentage":"0",
//       "RainFallPercentageColorCode":"#cc0000",
//       "RainFallDescription":"NO RAIN",
//       "CloudCover":"CLOUDY",
//       "Humidity":"82",
//       "WindSpeed":"15",
//       "WindDirection":"NE",
//       "LowTemp":"26",
//       "LowTempColorCode":"#37d4f5",
//       "HighTemp":"26",
//       "HighTempColorCode":"#e9f132",
//       "MeanTemp":"26",
//       "coordinates":[
//          {
//             "coordinate":"17.61731114443119, 120.62541906043792"
//          },
//          {
//             "coordinate":"17.60274923767965, 120.63863698669239"
//          }
//       ]