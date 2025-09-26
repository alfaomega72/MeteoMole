import 'package:flutter/material.dart';
import 'package:meteo_mole/forecast_page.dart';
import 'package:meteo_mole/radar_page.dart';
import 'package:meteo_mole/air_quality_page.dart';
import 'package:meteo_mole/pollen_page.dart';
import 'package:meteo_mole/uv_index_page.dart';
import 'package:meteo_mole/info_page.dart';

void main() {
  runApp(const MeteoMoleApp());
}

class MeteoMoleApp extends StatefulWidget {
  const MeteoMoleApp({super.key});

  @override
  State<MeteoMoleApp> createState() => _MeteoMoleAppState();
}

class _MeteoMoleAppState extends State<MeteoMoleApp> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ForecastPage(),
    RadarPage(),
    AirQualityPage(),
    PollenPage(),
    UVIndexPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showInfoPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InfoPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meteo Mole',
      theme: ThemeData(
        colorSchemeSeed: Colors.blueAccent,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blueAccent,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Meteo Mole'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: _showInfoPage,
              tooltip: 'Informazioni',
            ),
          ],
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud),
              label: 'Previsioni',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.radar),
              label: 'Radar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.air),
              label: 'Aria',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_florist),
              label: 'Pollini',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wb_sunny),
              label: 'UV',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
