class AgriForecastTempModel {
  final String lowLandMinTemp;
  final String lowLandMaxTemp;
  final String highLandMinTemp;
  final String highLandMaxTemp;
  final String locations;
  final String lowLandMinTempIcon;
  final String highLandMinTempIcon;

  AgriForecastTempModel(
      this.lowLandMinTemp,
      this.lowLandMaxTemp,
      this.highLandMinTemp, 
      this.highLandMaxTemp,
      this.locations,
      this.lowLandMinTempIcon,
      this.highLandMinTempIcon);
}
