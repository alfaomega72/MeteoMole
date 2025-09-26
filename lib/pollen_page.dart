import 'package:flutter/material.dart';
import 'package:meteo_mole/weather_service.dart';

class PollenPage extends StatefulWidget {
  const PollenPage({super.key});

  @override
  State<PollenPage> createState() => _PollenPageState();
}

class _PollenPageState extends State<PollenPage> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _pollenData;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchPollen();
  }

  Future<void> _fetchPollen() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      // Coordinate per Torino
      final data = await _weatherService.fetchPollen(45.0703, 7.6869);
      setState(() {
        _pollenData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Errore nel recupero dei dati sui pollini: ${e.toString()}';
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
              : _pollenData == null
                  ? const Center(child: Text('Nessun dato sui pollini disponibile'))
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Livelli Pollinici - Torino',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 16),
                            _buildPollenOverviewCard(),
                            const SizedBox(height: 24),
                            Text(
                              'Dettagli per Tipo di Polline',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            _buildPollenTypesGrid(),
                          ],
                        ),
                      ),
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchPollen,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildPollenOverviewCard() {
    final current = _pollenData!['current'];
    
    // Calcola il livello massimo di polline
    double maxLevel = 0;
    String dominantPollen = 'Nessuno';
    
    final pollenTypes = {
      'alder_pollen': 'Ontano',
      'birch_pollen': 'Betulla',
      'grass_pollen': 'Graminacee',
      'mugwort_pollen': 'Artemisia',
      'olive_pollen': 'Olivo',
      'ragweed_pollen': 'Ambrosia',
    };

    pollenTypes.forEach((key, name) {
      final value = current[key]?.toDouble() ?? 0;
      if (value > maxLevel) {
        maxLevel = value;
        dominantPollen = name;
      }
    });

    final description = _weatherService.getPollenDescription(maxLevel);
    Color cardColor = _getPollenColor(description);
    IconData iconData = _getPollenIcon(description);

    return Card(
      color: cardColor.withOpacity(0.1),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Livello Pollinico Generale',
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
                    Text('Polline dominante: $dominantPollen'),
                    Text('Livello: ${maxLevel.toStringAsFixed(1)}'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPollenTypesGrid() {
    final current = _pollenData!['current'];
    
    final pollenTypes = [
      {'name': 'Ontano', 'key': 'alder_pollen', 'icon': Icons.park, 'color': Colors.brown},
      {'name': 'Betulla', 'key': 'birch_pollen', 'icon': Icons.nature, 'color': Colors.green},
      {'name': 'Graminacee', 'key': 'grass_pollen', 'icon': Icons.grass, 'color': Colors.lightGreen},
      {'name': 'Artemisia', 'key': 'mugwort_pollen', 'icon': Icons.local_florist, 'color': Colors.purple},
      {'name': 'Olivo', 'key': 'olive_pollen', 'icon': Icons.eco, 'color': Colors.lightGreen.shade800},
      {'name': 'Ambrosia', 'key': 'ragweed_pollen', 'icon': Icons.coronavirus, 'color': Colors.orange},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: pollenTypes.length,
      itemBuilder: (context, index) {
        final pollen = pollenTypes[index];
        final value = current[pollen['key']]?.toDouble();
        final description = _weatherService.getPollenDescription(value);
        
        return Card(
          color: (pollen['color'] as Color).withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  pollen['icon'] as IconData,
                  size: 30,
                  color: pollen['color'] as Color,
                ),
                const SizedBox(height: 8),
                Text(
                  pollen['name'] as String,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _getPollenColor(description),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (value != null)
                  Text(
                    'Livello: ${value.toStringAsFixed(1)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getPollenColor(String description) {
    switch (description) {
      case 'Basso':
        return Colors.green;
      case 'Moderato':
        return Colors.yellow.shade700;
      case 'Alto':
        return Colors.orange;
      case 'Molto alto':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getPollenIcon(String description) {
    switch (description) {
      case 'Basso':
        return Icons.sentiment_satisfied;
      case 'Moderato':
        return Icons.sentiment_neutral;
      case 'Alto':
        return Icons.sentiment_dissatisfied;
      case 'Molto alto':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.help_outline;
    }
  }
}
