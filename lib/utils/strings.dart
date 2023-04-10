

//Daily Monitoring

const dailyMap = 'http://18.139.91.35/payong/API/DailyMon.php?';
// http://18.139.91.35/payong/API/DailyMon.php?page=1&fdate=2023-04-07&option=MinTemp
// http://18.139.91.35/payong/API/DailyMon.php?page=1&fdate=2023-04-07&option=MaxTemp
// http://18.139.91.35/payong/API/DailyMon.php?page=1&fdate=2023-04-07&option=NormalRainfall
// http://18.139.91.35/payong/API/DailyMon.php?page=1&fdate=2023-04-07&option=ActualRainfall

const dailyDetails = 'http://18.139.91.35/payong/API/DailyMonDetails.php?'; //http://18.139.91.35/payong/API/DailyMonDetails.php?fdate=2023-04-07&location_id=12



// 10 Days Forecast
//Map
const days10Map = 'http://18.139.91.35/payong/API/daily_details.php?'; //http://18.139.91.35/payong/API/daily_details.php?fdate=2023-03-16 
const days10MapLocation = 'http://18.139.91.35/payong/API/locations.php?'; //http://18.139.91.35/payong/API/locations.php?location=Aliaga,Nueva Ecija

const days10Details = 'http://18.139.91.35/payong/API/daily_details.php?'; //http://18.139.91.35/payong/API/daily_details.php?DailyDetailsID=1

const day10SearchApi = 'http://18.139.91.35/payong/API/locations.php?location=';


//Agri Module

const parentAgri = 'http://18.139.91.35/payong/API/agri_daily.php';

const agriForecastTempApi = 'http://18.139.91.35/payong/API/agri_daily_details.php?AgriDailyID=1&option=Temperature';
const agriForecastWindApi = 'http://18.139.91.35/payong/API/agri_daily_details.php?AgriDailyID=1&option=WindCondition';
const agriForecastWeatherApi = 'http://18.139.91.35/payong/API/agri_daily_details.php?AgriDailyID=1&option=WeatherCondition';
const agriForecastHumidityApi = 'http://18.139.91.35/payong/API/agri_daily_details.php?AgriDailyID=1&option=Humidity';
const agriForecastLeafWetnessApi = 'http://18.139.91.35/payong/API/agri_daily_details.php?AgriDailyID=1&option=LeafWetness';