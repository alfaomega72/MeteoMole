import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'YOUR_OPEN_METEO_API_KEY'; // Sostituisci con la tua chiave API di Open-Meteo
  final String baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<Map<String, dynamic>> fetchWeather(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        '$baseUrl?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset&current_weather=true&timezone=auto'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

