class AgriForecastModel {
  final String agriDailyID;
  final String minHumidity;
  final String maxHumidity;
  final List<String> humidityLocation;
  final String minLeafWetness;
  final String maxLeafWetness;
  final List<String> leafWetnessLocation;
  final String lowLandcMinTemp;
  final String lowLandcMaxTemp;
  final String highLandMinTemp;
  final String highLandMaxTemp;
  final List<String> tempLocation;
  final String windCondition;
  final List<String> windContidionLocation;

  AgriForecastModel(
      this.agriDailyID,
      this.minHumidity,
      this.maxHumidity, 
      this.humidityLocation,
      this.minLeafWetness,
      this.maxLeafWetness,
      this.leafWetnessLocation,
      this.lowLandcMinTemp,
      this.lowLandcMaxTemp,
      this.highLandMinTemp,
      this.highLandMaxTemp,
      this.tempLocation,
      this.windCondition,
      this.windContidionLocation);
} 
