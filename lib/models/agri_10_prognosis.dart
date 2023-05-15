class Agri10Prognosis {
  final String agriInfoID;
  final String regionDescription;
  final String title;
  final String content;
  final String rainFall;
  final String rainyDays;
  final String relativeHumidity;
  final List<SoilConditionModeil> soilCondition;
  final List<Temperature> temp;
  

  Agri10Prognosis(
      this.agriInfoID,
      this.regionDescription,
      this.title,
      this.content,
      this.rainFall,
      this.rainyDays,
      this.relativeHumidity,
      this.soilCondition,
      this.temp
      );
}

class SoilConditionModeil{
  final String soilCondition;
  final String location;

  SoilConditionModeil(this.soilCondition, this.location);
}

class Temperature{
  final String temperatureDetails;

  Temperature(this.temperatureDetails);
}

