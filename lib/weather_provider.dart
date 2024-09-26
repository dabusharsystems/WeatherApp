import 'package:flutter/material.dart';
import 'weather_services_api.dart';

class WeatherProvider with ChangeNotifier {
  WeatherServiceAPI _weatherService = WeatherServiceAPI();
  Map<String, dynamic>? _weatherData;
  String? _errorMessage;

  Map<String, dynamic>? get weatherData => _weatherData;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWeather(String city) async {
    _errorMessage = null;
    _weatherData = null;
    notifyListeners();

    final data = await _weatherService.fetchWeather(city);

    if (data == null) {
      _errorMessage = 'Could not fetch weather data. Please try again.';
    } else {
      _weatherData = data;
    }
    notifyListeners();
  }
}
