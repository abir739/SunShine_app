import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final String? weatherDescription;
  final int windSpeed;

  WeatherIcon({required this.weatherDescription, required this.windSpeed});

  IconData getWeatherIcon() {
    // Map weather descriptions and wind speed to corresponding icons
    if (weatherDescription?.toLowerCase() == 'moderate rain') {
   
        return Icons.cloud; // Rainy with other wind speeds
  
    } else if (weatherDescription?.toLowerCase().contains('clouds')==true ) {
      return Icons.cloud; // Cloudy
    } else {
      return Icons.person; // Default icon for unknown weather
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text("${weatherDescription ?? "loading .."}"),
        Icon(getWeatherIcon(), size: 20.0),
      ],
    );
  }
}
