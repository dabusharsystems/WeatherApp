import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weather_provider.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  //Boolean checks for state checking
  bool _isLoading = true;
  bool _isDisposed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final city = ModalRoute.of(context)!.settings.arguments as String;

        Provider.of<WeatherProvider>(context, listen: false).fetchWeather(city).then((_) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }).catchError((error) {
          if (mounted) {
            setState(() {
              _isLoading = false; // Stop loading if there's an error
            });
            print('Error fetching weather data: $error');
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
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
          ? Center(child: Text('No weather data available'))
          : weatherProvider.errorMessage != null
          ? Center(child: Text(weatherProvider.errorMessage!))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
