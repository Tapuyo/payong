class DailyModel {
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


  DailyModel(
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
