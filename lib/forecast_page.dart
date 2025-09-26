import 'package:flutter/material.dart';
import 'package:meteo_mole/weather_service.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _weatherData;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      // Coordinate per Torino (esempio)
      final data = await _weatherService.fetchWeather(45.0703, 7.6869);
      setState(() {
        _weatherData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Errore nel recupero dei dati meteo: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : _weatherData == null
                  ? const Center(child: Text('Nessun dato meteo disponibile'))
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Previsioni per Torino',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 16),
                            _buildCurrentWeatherCard(),
                            const SizedBox(height: 24),
                            Text(
                              'Previsioni Orarie',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            _buildHourlyForecast(),
                            const SizedBox(height: 24),
                            Text(
                              'Previsioni Giornaliere',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            _buildDailyForecast(),
                          ],
                        ),
                      ),
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchWeather,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildCurrentWeatherCard() {
    final currentWeather = _weatherData!['current_weather'];
    final temperature = currentWeather['temperature'];
    final windSpeed = currentWeather['windspeed'];
    final weatherCode = currentWeather['weathercode'];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ora Attuale',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(_getWeatherIcon(weatherCode), size: 40),
                const SizedBox(width: 16),
                Text(
                  '${temperature}°C',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Vento: ${windSpeed} km/h'),
            Text('Condizioni: ${_getWeatherDescription(weatherCode)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildHourlyForecast() {
    final hourly = _weatherData!['hourly'];
    final temperatures = hourly['temperature_2m'] as List;
    final weatherCodes = hourly['weather_code'] as List;
    final times = hourly['time'] as List;

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 24, // Prossime 24 ore
        itemBuilder: (context, index) {
          final time = DateTime.parse(times[index]);
          final temp = temperatures[index];
          final code = weatherCodes[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${time.hour}:00'),
                  Icon(_getWeatherIcon(code)),
                  Text('${temp}°C'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDailyForecast() {
    final daily = _weatherData!['daily'];
    final maxTemperatures = daily['temperature_2m_max'] as List;
    final minTemperatures = daily['temperature_2m_min'] as List;
    final weatherCodes = daily['weather_code'] as List;
    final times = daily['time'] as List;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: daily['time'].length,
      itemBuilder: (context, index) {
        final date = DateTime.parse(times[index]);
        final maxTemp = maxTemperatures[index];
        final minTemp = minTemperatures[index];
        
        // Assegna un colore di sfondo alternato per i giorni
        Color cardColor = index % 2 == 0 ? Colors.blue.shade50 : Colors.lightBlue.shade50;

        final code = weatherCodes[index];
        return Card(
          color: cardColor, // Applica il colore di sfondo
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(child: Text('${date.day}/${date.month}')),
                Icon(_getWeatherIcon(code)),
                const SizedBox(width: 16),
                Text('Max: ${maxTemp}°C / Min: ${minTemp}°C'),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getWeatherIcon(int weatherCode) {
    // Mappatura semplificata dei codici meteo Open-Meteo a icone Material Design
    switch (weatherCode) {
      case 0: // Clear sky
        return Icons.wb_sunny;
      case 1: // Mainly clear, partly cloudy, and overcast
      case 2:
      case 3:
        return Icons.cloud;
      case 45: // Fog and rime fog
      case 48:
        return Icons.foggy;
      case 51: // Drizzle: Light, moderate, and dense intensity
      case 53:
      case 55:
        return Icons.grain;
      case 56: // Freezing Drizzle: Light and dense intensity
      case 57:
        return Icons.ac_unit;
      case 61: // Rain: Slight, moderate and heavy intensity
      case 63:
      case 65:
        return Icons.umbrella;
      case 66: // Freezing Rain: Light and heavy intensity
      case 67:
        return Icons.ac_unit;
      case 71: // Snow fall: Slight, moderate, and heavy intensity
      case 73:
      case 75:
        return Icons.snowing;
      case 77: // Snow grains
        return Icons.snowing;
      case 80: // Rain showers: Slight, moderate, and violent
      case 81:
      case 82:
        return Icons.beach_access;
      case 85: // Snow showers slight and heavy
      case 86:
        return Icons.snowing;
      case 95: // Thunderstorm: Slight or moderate
        return Icons.thunderstorm;
      case 96: // Thunderstorm with slight and moderate hail
      case 99:
        return Icons.thunderstorm;
      default:
        return Icons.cloud_off;
    }
  }

  String _getWeatherDescription(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return 'Cielo sereno';
      case 1:
        return 'Principalmente sereno';
      case 2:
        return 'Parzialmente nuvoloso';
      case 3:
        return 'Coperto';
      case 45:
        return 'Nebbia';
      case 48:
        return 'Nebbia brinata';
      case 51:
        return 'Pioggerella leggera';
      case 53:
        return 'Pioggerella moderata';
      case 55:
        return 'Pioggerella intensa';
      case 56:
        return 'Pioggerella gelata leggera';
      case 57:
        return 'Pioggerella gelata intensa';
      case 61:
        return 'Pioggia leggera';
      case 63:
        return 'Pioggia moderata';
      case 65:
        return 'Pioggia intensa';
      case 66:
        return 'Pioggia gelata leggera';
      case 67:
        return 'Pioggia gelata intensa';
      case 71:
        return 'Nevicata leggera';
      case 73:
        return 'Nevicata moderata';
      case 75:
        return 'Nevicata intensa';
      case 77:
        return 'Gragnola';
      case 80:
        return 'Rovesci di pioggia leggeri';
      case 81:
        return 'Rovesci di pioggia moderati';
      case 82:
        return 'Rovesci di pioggia violenti';
      case 85:
        return 'Rovesci di neve leggeri';
      case 86:
        return 'Rovesci di neve intensi';
      case 95:
        return 'Temporale';
      case 96:
        return 'Temporale con grandine leggera';
      case 99:
        return 'Temporale con grandine intensa';
      default:
        return 'Condizioni sconosciute';
    }
  }
}

