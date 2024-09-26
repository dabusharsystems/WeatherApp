import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherServiceAPI{
  final String apiKey ="d8145e18e0f4ab8ad437fb0dc4715d61";
  
  Future<Map<String, dynamic>?> fetchWeather(String city) async{
    try {
      final response = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'),
      );
      if(response.statusCode == 200){
        return jsonDecode(response.body);
      }
      else{
        throw Exception('Failed to get Data from Weather Server');
      }
    } catch (e){
      print('Error: $e');
    }
  }
}