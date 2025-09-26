import 'package:flutter/material.dart';
import 'package:meteo_mole/weather_service.dart';

class AirQualityPage extends StatefulWidget {
  const AirQualityPage({super.key});

  @override
  State<AirQualityPage> createState() => _AirQualityPageState();
}

class _AirQualityPageState extends State<AirQualityPage> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _airQualityData;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchAirQuality();
  }

  Future<void> _fetchAirQuality() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      // Coordinate per Torino
      final data = await _weatherService.fetchAirQuality(45.0703, 7.6869);
      setState(() {
        _airQualityData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Errore nel recupero dei dati sulla qualità dell\'aria: ${e.toString()}';
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
              : _airQualityData == null
                  ? const Center(child: Text('Nessun dato sulla qualità dell\'aria disponibile'))
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Qualità dell\'Aria - Torino',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 16),
                            _buildCurrentAirQualityCard(),
                            const SizedBox(height: 24),
                            Text(
                              'Dettagli Inquinanti',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            _buildPollutantsGrid(),
                          ],
                        ),
                      ),
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchAirQuality,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildCurrentAirQualityCard() {
    final current = _airQualityData!['current'];
    final pm25 = current['pm2_5']?.toDouble();
    final pm10 = current['pm10']?.toDouble();
    final description = _weatherService.getAirQualityDescription(pm25, pm10);

    Color cardColor = _getAirQualityColor(description);
    IconData iconData = _getAirQualityIcon(description);

    return Card(
      color: cardColor.withOpacity(0.1),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Qualità dell\'Aria Attuale',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(iconData, size: 40, color: cardColor),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(color: cardColor),
                    ),
                    if (pm25 != null) Text('PM2.5: ${pm25.toStringAsFixed(1)} μg/m³'),
                    if (pm10 != null) Text('PM10: ${pm10.toStringAsFixed(1)} μg/m³'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPollutantsGrid() {
    final current = _airQualityData!['current'];
    
    final pollutants = [
      {'name': 'PM2.5', 'value': current['pm2_5'], 'unit': 'μg/m³', 'icon': Icons.blur_on, 'color': Colors.red},
      {'name': 'PM10', 'value': current['pm10'], 'unit': 'μg/m³', 'icon': Icons.grain, 'color': Colors.orange},
      {'name': 'CO', 'value': current['carbon_monoxide'], 'unit': 'μg/m³', 'icon': Icons.local_gas_station, 'color': Colors.brown},
      {'name': 'NO₂', 'value': current['nitrogen_dioxide'], 'unit': 'μg/m³', 'icon': Icons.factory, 'color': Colors.purple},
      {'name': 'SO₂', 'value': current['sulphur_dioxide'], 'unit': 'μg/m³', 'icon': Icons.cloud, 'color': Colors.yellow.shade700},
      {'name': 'O₃', 'value': current['ozone'], 'unit': 'μg/m³', 'icon': Icons.air, 'color': Colors.blue},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: pollutants.length,
      itemBuilder: (context, index) {
        final pollutant = pollutants[index];
        final value = pollutant['value'];
        
        return Card(
          color: (pollutant['color'] as Color).withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  pollutant['icon'] as IconData,
                  size: 30,
                  color: pollutant['color'] as Color,
                ),
                const SizedBox(height: 8),
                Text(
                  pollutant['name'] as String,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  value != null 
                    ? '${value.toStringAsFixed(1)} ${pollutant['unit']}'
                    : 'N/A',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getAirQualityColor(String description) {
    switch (description) {
      case 'Buona':
        return Colors.green;
      case 'Moderata':
        return Colors.yellow.shade700;
      case 'Sensibile':
        return Colors.orange;
      case 'Malsana':
        return Colors.red;
      case 'Molto malsana':
        return Colors.purple;
      case 'Pericolosa':
        return Colors.red.shade900;
      default:
        return Colors.grey;
    }
  }

  IconData _getAirQualityIcon(String description) {
    switch (description) {
      case 'Buona':
        return Icons.sentiment_very_satisfied;
      case 'Moderata':
        return Icons.sentiment_satisfied;
      case 'Sensibile':
        return Icons.sentiment_neutral;
      case 'Malsana':
        return Icons.sentiment_dissatisfied;
      case 'Molto malsana':
        return Icons.sentiment_very_dissatisfied;
      case 'Pericolosa':
        return Icons.dangerous;
      default:
        return Icons.help_outline;
    }
  }
}
