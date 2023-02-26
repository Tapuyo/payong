class AgriModel {
  final String forecastAgriID;
  final String locationDescription;
  final List<dynamic> locationCoordinate;
  final String agriDate;
  final String weatherDescription;
  final String weatherIcon;
  final String wind;
  final String humidity;
  final String lowTemp;
  final String highTemp;
  final String rainFallFrom;
  final String rainFallTo;

  AgriModel(
      this.forecastAgriID,
      this.locationDescription,
      this.locationCoordinate,
      this.agriDate,
      this.weatherDescription,
      this.weatherIcon,
      this.wind,
      this.humidity,
      this.lowTemp,
      this.highTemp,
      this.rainFallFrom,
      this.rainFallTo);
}
