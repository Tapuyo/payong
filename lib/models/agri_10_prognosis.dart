class Agri10Prognosis {
  final String agriInfoID;
  final String regionDescription;
  final String title;
  final String content;
  final String rainFall;
  final String rainyDays;
  final String relativeHumidity;
  final List<SoilConditionModeil> soilCondition;
  final String temperature;
  

  Agri10Prognosis(
      this.agriInfoID,
      this.regionDescription,
      this.title,
      this.content,
      this.rainFall,
      this.rainyDays,
      this.relativeHumidity,
      this.soilCondition,
      this.temperature
      );
}

class SoilConditionModeil{
  final String soilCondition;
  final String location;

  SoilConditionModeil(this.soilCondition, this.location);
}

