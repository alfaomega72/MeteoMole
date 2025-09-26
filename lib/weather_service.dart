import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1';

  Future<Map<String, dynamic>> fetchWeather(double latitude, double longitude) async {
    final url = Uri.parse(
      '$_baseUrl/forecast?latitude=$latitude&longitude=$longitude&current_weather=true&hourly=temperature_2m,weather_code&daily=temperature_2m_max,temperature_2m_min,weather_code&timezone=Europe/Rome',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Errore nel recupero dei dati meteo: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchAirQuality(double latitude, double longitude) async {
    final url = Uri.parse(
      '$_baseUrl/air-quality?latitude=$latitude&longitude=$longitude&current=pm10,pm2_5,carbon_monoxide,nitrogen_dioxide,sulphur_dioxide,ozone,aerosol_optical_depth,dust,uv_index&hourly=pm10,pm2_5,carbon_monoxide,nitrogen_dioxide,sulphur_dioxide,ozone,uv_index&timezone=Europe/Rome',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Errore nel recupero dei dati sulla qualità dell\'aria: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchPollen(double latitude, double longitude) async {
    final url = Uri.parse(
      '$_baseUrl/air-quality?latitude=$latitude&longitude=$longitude&current=alder_pollen,birch_pollen,grass_pollen,mugwort_pollen,olive_pollen,ragweed_pollen&hourly=alder_pollen,birch_pollen,grass_pollen,mugwort_pollen,olive_pollen,ragweed_pollen&timezone=Europe/Rome',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Errore nel recupero dei dati sui pollini: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchUVIndex(double latitude, double longitude) async {
    final url = Uri.parse(
      '$_baseUrl/air-quality?latitude=$latitude&longitude=$longitude&current=uv_index,uv_index_clear_sky&hourly=uv_index,uv_index_clear_sky&daily=uv_index_max,uv_index_clear_sky_max&timezone=Europe/Rome',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Errore nel recupero dei dati sull\'indice UV: ${response.statusCode}');
    }
  }

  // Metodo per ottenere tutti i dati in una sola chiamata
  Future<Map<String, dynamic>> fetchAllData(double latitude, double longitude) async {
    try {
      final weatherData = await fetchWeather(latitude, longitude);
      final airQualityData = await fetchAirQuality(latitude, longitude);
      final pollenData = await fetchPollen(latitude, longitude);
      final uvData = await fetchUVIndex(latitude, longitude);

      return {
        'weather': weatherData,
        'airQuality': airQualityData,
        'pollen': pollenData,
        'uv': uvData,
      };
    } catch (e) {
      throw Exception('Errore nel recupero dei dati completi: $e');
    }
  }

  // Metodi di utilità per interpretare i dati
  String getAirQualityDescription(double? pm25, double? pm10) {
    if (pm25 == null && pm10 == null) return 'Dati non disponibili';
    
    double maxPM = (pm25 ?? 0) > (pm10 ?? 0) ? (pm25 ?? 0) : (pm10 ?? 0);
    
    if (maxPM <= 12) return 'Buona';
    if (maxPM <= 35) return 'Moderata';
    if (maxPM <= 55) return 'Sensibile';
    if (maxPM <= 150) return 'Malsana';
    if (maxPM <= 250) return 'Molto malsana';
    return 'Pericolosa';
  }

  String getUVDescription(double? uvIndex) {
    if (uvIndex == null) return 'Dati non disponibili';
    
    if (uvIndex <= 2) return 'Basso';
    if (uvIndex <= 5) return 'Moderato';
    if (uvIndex <= 7) return 'Alto';
    if (uvIndex <= 10) return 'Molto alto';
    return 'Estremo';
  }

  String getPollenDescription(double? pollenLevel) {
    if (pollenLevel == null) return 'Dati non disponibili';
    
    if (pollenLevel <= 1) return 'Basso';
    if (pollenLevel <= 2) return 'Moderato';
    if (pollenLevel <= 3) return 'Alto';
    return 'Molto alto';
  }
}
