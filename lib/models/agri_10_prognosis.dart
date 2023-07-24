class Agri10Prognosis {
  final String agriInfoID;
  final String regionDescription;
  final String title;
  final String content;
  final String rainFall;
  final String rainyDays;
  final String relativeHumidity;
    final List<Temperature> temp;
  final String wetIcon;
  final String wetSoilLocation;
  final String moistIcon;
  final String moistSoilLocation;
  final String dryIcon;
  final String drySoilLocation;


  

  Agri10Prognosis(
      this.agriInfoID,
      this.regionDescription,
      this.title,
      this.content,
      this.rainFall,
      this.rainyDays,
      this.relativeHumidity,
      this.temp,
      this.wetIcon,
      this.wetSoilLocation,
      this.moistIcon,
      this.moistSoilLocation,
      this.dryIcon,
      this.drySoilLocation
      );
}

class Temperature{
  final String temperatureDetails;

  Temperature(this.temperatureDetails);
}

