import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weather_provider.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Only fetch weather data if it's not already loading
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final city = ModalRoute.of(context)!.settings.arguments as String;
        Provider.of<WeatherProvider>(context, listen: false).fetchWeather(city).then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : weatherProvider.weatherData == null && weatherProvider.errorMessage == null
          ? Center(child: CircularProgressIndicator())
          : weatherProvider.errorMessage != null
          ? Center(child: Text(weatherProvider.errorMessage!))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'City: ${weatherProvider.weatherData!['name']}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Temperature: ${weatherProvider.weatherData!['main']['temp']} °C / ${_convertToFahrenheit(weatherProvider.weatherData!['main']['temp'])} °F',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Weather: ${weatherProvider.weatherData!['weather'][0]['description']}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Humidity: ${weatherProvider.weatherData!['main']['humidity']}%',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Wind Speed: ${weatherProvider.weatherData!['wind']['speed']} m/s',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  double _convertToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }
}
