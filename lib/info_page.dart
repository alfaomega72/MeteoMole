import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informazioni'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppDescriptionCard(context),
            const SizedBox(height: 24),
            _buildIconsExplanationCard(context),
            const SizedBox(height: 24),
            _buildTechnicalDetailsCard(context),
            const SizedBox(height: 24),
            _buildDeveloperCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppDescriptionCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.blue, size: 30),
                const SizedBox(width: 12),
                Text(
                  'Meteo Mole',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Meteo Mole è un\'applicazione meteo completa progettata specificamente per Torino e la regione Piemonte. L\'app fornisce previsioni meteorologiche accurate, dati sulla qualità dell\'aria, livelli pollinici, indice UV e radar meteo in tempo reale.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            Text(
              'Caratteristiche principali:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildFeatureList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList(BuildContext context) {
    final features = [
      {'icon': Icons.wb_sunny, 'text': 'Previsioni meteo dettagliate per 7 giorni', 'color': Colors.orange},
      {'icon': Icons.radar, 'text': 'Radar meteo in tempo reale per l\'Italia', 'color': Colors.green},
      {'icon': Icons.air, 'text': 'Monitoraggio qualità dell\'aria (PM2.5, PM10, CO, NO₂, SO₂, O₃)', 'color': Colors.blue},
      {'icon': Icons.local_florist, 'text': 'Livelli pollinici per 6 tipi di pollini', 'color': Colors.purple},
      {'icon': Icons.wb_sunny_outlined, 'text': 'Indice UV con consigli di protezione', 'color': Colors.red},
    ];

    return Column(
      children: features.map((feature) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Icon(feature['icon'] as IconData, color: feature['color'] as Color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                feature['text'] as String,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildIconsExplanationCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.palette, color: Colors.green, size: 30),
                const SizedBox(width: 12),
                Text(
                  'Spiegazione Icone e Colori',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildIconSection(context, 'Qualità dell\'Aria', [
              {'icon': Icons.sentiment_very_satisfied, 'color': Colors.green, 'text': 'Buona - Verde'},
              {'icon': Icons.sentiment_satisfied, 'color': Colors.yellow.shade700, 'text': 'Moderata - Giallo'},
              {'icon': Icons.sentiment_neutral, 'color': Colors.orange, 'text': 'Sensibile - Arancione'},
              {'icon': Icons.sentiment_dissatisfied, 'color': Colors.red, 'text': 'Malsana - Rosso'},
              {'icon': Icons.dangerous, 'color': Colors.purple, 'text': 'Pericolosa - Viola'},
            ]),
            const SizedBox(height: 16),
            _buildIconSection(context, 'Indice UV', [
              {'icon': Icons.wb_sunny_outlined, 'color': Colors.green, 'text': 'Basso (0-2) - Verde'},
              {'icon': Icons.wb_sunny, 'color': Colors.yellow.shade700, 'text': 'Moderato (3-5) - Giallo'},
              {'icon': Icons.warning_amber, 'color': Colors.orange, 'text': 'Alto (6-7) - Arancione'},
              {'icon': Icons.warning, 'color': Colors.red, 'text': 'Molto Alto (8-10) - Rosso'},
              {'icon': Icons.dangerous, 'color': Colors.purple, 'text': 'Estremo (11+) - Viola'},
            ]),
            const SizedBox(height: 16),
            _buildIconSection(context, 'Livelli Pollinici', [
              {'icon': Icons.sentiment_satisfied, 'color': Colors.green, 'text': 'Basso - Verde'},
              {'icon': Icons.sentiment_neutral, 'color': Colors.yellow.shade700, 'text': 'Moderato - Giallo'},
              {'icon': Icons.sentiment_dissatisfied, 'color': Colors.orange, 'text': 'Alto - Arancione'},
              {'icon': Icons.sentiment_very_dissatisfied, 'color': Colors.red, 'text': 'Molto Alto - Rosso'},
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildIconSection(BuildContext context, String title, List<Map<String, dynamic>> icons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...icons.map((iconData) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: [
              Icon(iconData['icon'] as IconData, color: iconData['color'] as Color, size: 20),
              const SizedBox(width: 12),
              Text(
                iconData['text'] as String,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildTechnicalDetailsCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings, color: Colors.orange, size: 30),
                const SizedBox(width: 12),
                Text(
                  'Dettagli Tecnici',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTechnicalDetail(context, 'Framework', 'Flutter 3.x', Icons.flutter_dash),
            _buildTechnicalDetail(context, 'Linguaggio', 'Dart', Icons.code),
            _buildTechnicalDetail(context, 'Piattaforma Target', 'Android 15 (API Level 36)', Icons.android),
            _buildTechnicalDetail(context, 'API Meteo', 'Open-Meteo.com (gratuita)', Icons.cloud),
            _buildTechnicalDetail(context, 'API Radar', 'Agenzia Italia Meteo (WebView)', Icons.radar),
            _buildTechnicalDetail(context, 'Design', 'Material Design 3', Icons.design_services),
            _buildTechnicalDetail(context, 'Architettura', 'Stateful Widgets con HTTP client', Icons.architecture),
            _buildTechnicalDetail(context, 'Dipendenze', 'http, webview_flutter, flutter_launcher_icons', Icons.extension),
            _buildTechnicalDetail(context, 'Ambiente di Sviluppo', 'Ubuntu 22.04 con Flutter SDK', Icons.computer),
            _buildTechnicalDetail(context, 'Repository', 'GitHub (alfaomega72/MeteoMole)', Icons.source),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicalDetail(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.purple, size: 30),
                const SizedBox(width: 12),
                Text(
                  'Sviluppatore',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.code, color: Colors.purple.shade300, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Sviluppato da Orazio Quattrocchi',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Questa applicazione è stata sviluppata utilizzando tecnologie moderne e API gratuite per fornire un servizio meteo completo e affidabile per la regione Piemonte. L\'app è stata progettata con un\'interfaccia utente intuitiva e colorata per rendere l\'esperienza utente piacevole e informativa.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.purple.shade600, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Versione 1.0.0 - Dicembre 2024',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.purple.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
