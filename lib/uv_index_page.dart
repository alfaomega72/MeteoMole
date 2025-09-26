import 'package:flutter/material.dart';
import 'package:meteo_mole/weather_service.dart';

class UVIndexPage extends StatefulWidget {
  const UVIndexPage({super.key});

  @override
  State<UVIndexPage> createState() => _UVIndexPageState();
}

class _UVIndexPageState extends State<UVIndexPage> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _uvData;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchUVIndex();
  }

  Future<void> _fetchUVIndex() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      // Coordinate per Torino
      final data = await _weatherService.fetchUVIndex(45.0703, 7.6869);
      setState(() {
        _uvData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Errore nel recupero dei dati sull\'indice UV: ${e.toString()}';
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
              : _uvData == null
                  ? const Center(child: Text('Nessun dato sull\'indice UV disponibile'))
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Indice UV - Torino',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 16),
                            _buildCurrentUVCard(),
                            const SizedBox(height: 24),
                            Text(
                              'Previsioni UV Orarie',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            _buildHourlyUVForecast(),
                            const SizedBox(height: 24),
                            _buildUVProtectionCard(),
                          ],
                        ),
                      ),
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchUVIndex,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildCurrentUVCard() {
    final current = _uvData!['current'];
    final uvIndex = current['uv_index']?.toDouble();
    final uvClearSky = current['uv_index_clear_sky']?.toDouble();
    final description = _weatherService.getUVDescription(uvIndex);

    Color cardColor = _getUVColor(description);
    IconData iconData = _getUVIcon(description);

    return Card(
      color: cardColor.withOpacity(0.1),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Indice UV Attuale',
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
                    if (uvIndex != null) Text('Indice UV: ${uvIndex.toStringAsFixed(1)}'),
                    if (uvClearSky != null) Text('UV cielo sereno: ${uvClearSky.toStringAsFixed(1)}'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourlyUVForecast() {
    final hourly = _uvData!['hourly'];
    final uvIndexes = hourly['uv_index'] as List?;
    final times = hourly['time'] as List?;

    if (uvIndexes == null || times == null) {
      return const Text('Dati orari non disponibili');
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 24, // Prossime 24 ore
        itemBuilder: (context, index) {
          if (index >= times.length || index >= uvIndexes.length) {
            return const SizedBox.shrink();
          }
          
          final time = DateTime.parse(times[index]);
          final uvIndex = uvIndexes[index]?.toDouble();
          final description = _weatherService.getUVDescription(uvIndex);
          final color = _getUVColor(description);
          
          return Card(
            margin: const EdgeInsets.all(8.0),
            color: color.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${time.hour}:00'),
                  Icon(_getUVIcon(description), color: color),
                  Text(uvIndex?.toStringAsFixed(1) ?? 'N/A'),
                  Text(
                    description,
                    style: TextStyle(fontSize: 10, color: color),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUVProtectionCard() {
    final current = _uvData!['current'];
    final uvIndex = current['uv_index']?.toDouble();
    final description = _weatherService.getUVDescription(uvIndex);

    String protectionAdvice = _getProtectionAdvice(description);
    Color cardColor = _getUVColor(description);

    return Card(
      color: cardColor.withOpacity(0.05),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.health_and_safety, color: cardColor),
                const SizedBox(width: 8),
                Text(
                  'Consigli di Protezione',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: cardColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              protectionAdvice,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Color _getUVColor(String description) {
    switch (description) {
      case 'Basso':
        return Colors.green;
      case 'Moderato':
        return Colors.yellow.shade700;
      case 'Alto':
        return Colors.orange;
      case 'Molto alto':
        return Colors.red;
      case 'Estremo':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getUVIcon(String description) {
    switch (description) {
      case 'Basso':
        return Icons.wb_sunny_outlined;
      case 'Moderato':
        return Icons.wb_sunny;
      case 'Alto':
        return Icons.warning_amber;
      case 'Molto alto':
        return Icons.warning;
      case 'Estremo':
        return Icons.dangerous;
      default:
        return Icons.help_outline;
    }
  }

  String _getProtectionAdvice(String description) {
    switch (description) {
      case 'Basso':
        return 'Nessuna protezione particolare necessaria. Puoi stare all\'aperto senza preoccupazioni.';
      case 'Moderato':
        return 'Cerca l\'ombra durante le ore centrali del giorno. Indossa cappello e occhiali da sole.';
      case 'Alto':
        return 'Protezione necessaria! Usa crema solare SPF 30+, cappello, occhiali da sole e vestiti protettivi.';
      case 'Molto alto':
        return 'Protezione extra necessaria! Evita il sole dalle 10 alle 16. Usa crema solare SPF 50+.';
      case 'Estremo':
        return 'Evita l\'esposizione al sole! Se devi uscire, usa protezione massima e cerca sempre l\'ombra.';
      default:
        return 'Dati non disponibili per fornire consigli specifici.';
    }
  }
}
