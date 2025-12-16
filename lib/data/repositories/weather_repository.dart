import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherRepository {
  // Using the key you provided
  final String apiKey = '00ef128ffcc026000eb923caf0f6d7c6'; 
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<WeatherModel> getWeather(String city) async {
    // 1. Fetch Current Weather
    final urlCurrent = Uri.parse('$baseUrl/weather?q=$city&units=metric&appid=$apiKey&lang=fr');
    final responseCurrent = await http.get(urlCurrent);

    if (responseCurrent.statusCode != 200) {
      throw Exception('Ville introuvable ou erreur API (Code: ${responseCurrent.statusCode})');
    }

    final jsonCurrent = json.decode(responseCurrent.body);
    WeatherModel currentData = WeatherModel.fromJson(jsonCurrent);

    // 2. Fetch 5-Day Forecast
    final urlForecast = Uri.parse('$baseUrl/forecast?q=$city&units=metric&appid=$apiKey&lang=fr');
    final responseForecast = await http.get(urlForecast);

    List<WeatherModel> dailyForecast = [];
    
    if (responseForecast.statusCode == 200) {
      final jsonForecast = json.decode(responseForecast.body);
      final list = jsonForecast['list'] as List;

      // The API returns data every 3 hours (8 items per day).
      // Logic: Take one reading per day (e.g., around noon) to simulate "Daily Forecast"
      // We skip the first few to avoid showing "today" in the forecast list
      for (var i = 7; i < list.length; i += 8) {
        dailyForecast.add(WeatherModel.fromForecastJson(list[i]));
      }
    }

    // 3. Return Combined Data
    return WeatherModel(
      cityName: currentData.cityName,
      temperature: currentData.temperature,
      description: currentData.description,
      iconCode: currentData.iconCode,
      humidity: currentData.humidity,
      windSpeed: currentData.windSpeed,
      date: currentData.date,
      forecast: dailyForecast,
    );
  }
}