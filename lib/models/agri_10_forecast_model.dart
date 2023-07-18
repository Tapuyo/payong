class AgriRegionalForecast {
  final String agriInfoID;
  final String title;
  final String content;
  final List<AgriRegionalForecastWeatherSystem> weatherSystem;
  final List<AgriRegionalForecastWindCondition> windCondition;
  final List<AgriRegionalForecastGaleWarning> galeWarning;
  final List<AgriRegionalForecastEnso> enso;
  final List<AgriRegionalForecastMap> map;
  final List<AgriWeatherCondition> weatherCondition;

  AgriRegionalForecast(
      this.agriInfoID,
      this.title,
      this.content,
      this.weatherSystem,
      this.windCondition,
      this.galeWarning,
      this.enso,this.map,
      this.weatherCondition);
}

class AgriRegionalForecastWeatherSystem {
  final String name;
  final String description;
  final String icon;


  AgriRegionalForecastWeatherSystem(
      this.name,
      this.description,
      this.icon);
}


class AgriRegionalForecastWeatherCondition {
  final String location;
  final String description;
  final String icon;


  AgriRegionalForecastWeatherCondition(
      this.location,
      this.description,
      this.icon);
}

class AgriRegionalForecastWindCondition {
  final String location;
  final String description;
  final String icon;


  AgriRegionalForecastWindCondition(
      this.location,
      this.description,
      this.icon);
}

class AgriRegionalForecastGaleWarning {
  final String location;
  final String description;
  final String icon;


  AgriRegionalForecastGaleWarning(
      this.location,
      this.description,
      this.icon);
}

class AgriRegionalForecastEnso {
  final String location;
  final String description;
  final String icon;


  AgriRegionalForecastEnso(
      this.location,
      this.description,
      this.icon);
}

class AgriRegionalForecastMap {
  final String map;
  final String description;


  AgriRegionalForecastMap(
      this.map,
      this.description,
      );
}

class AgriWeatherCondition {
  final String location;
  final String description;
  final String icon;


  AgriWeatherCondition(
      this.location,
      this.description,
      this.icon);
}
