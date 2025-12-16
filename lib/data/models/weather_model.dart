class WeatherModel {
  final String cityName;
  final double temperature;
  final String description;
  final String iconCode;
  final int humidity;
  final double windSpeed;
  final DateTime date;
  
  // List of future forecasts
  final List<WeatherModel> forecast;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.date,
    this.forecast = const [],
  });

  // Factory to parse the "Current Weather" API response
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
    );
  }

  // Factory to parse a single item from the "Forecast" API list
  factory WeatherModel.fromForecastJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: '', // Not relevant for individual forecast items
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
    );
  }
}