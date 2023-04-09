class DailyModel {
  final String dailyDetailsID;
  final String locationDescription;
  final List<dynamic> locationCoordinate;
  final String rainFallActual;
  final String rainFallActualColorCode;
  final String rainFallNormal;
  final String rainFallNormalColorCode;
  final String lowTemp;
  final String lowTempColorCode;
  final String highTemp;
  final String highTempColorCode;
  final String percentrainFallColorCode;
  

  DailyModel(
      this.dailyDetailsID,
      this.locationDescription,
      this.locationCoordinate,
      this.rainFallActual,
      this.rainFallActualColorCode,
      this.rainFallNormal,
      this.rainFallNormalColorCode,
      this.lowTemp,
      this.lowTempColorCode,
      this.highTemp,
      this.highTempColorCode,
      this.percentrainFallColorCode);
}
