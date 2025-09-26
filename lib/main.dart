import 'package:flutter/material.dart';
import 'package:meteo_mole/forecast_page.dart';
import 'package:meteo_mole/radar_page.dart';

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
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud),
              label: 'Previsioni',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.radar),
              label: 'Radar',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

