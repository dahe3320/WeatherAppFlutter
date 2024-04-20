import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const WeatherScreen());
}

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  Position? _currentPosition;
  String? _city;
  String? _description;
  double? _temperature;
  String? _weatherIconUrl;

  Map<String, String> weatherImages = {
    'Clear': 'assets/clear.jpg',
    'Clouds': 'assets/cloudy.jpg',
    'Rain': 'assets/rainy.jpg',
    'Snow': 'assets/snow.jpg',
  };

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
    });
    _getWeatherData();
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    String weatherCondition = _description?.toLowerCase() ?? '';
    String imagePath = '';

    String timeDisplay =
        DateFormat('EEEE, MMMM d, HH:mm').format(DateTime.now().toLocal());
    if (weatherCondition.contains('clear')) {
      imagePath = 'assets/clear.jpg';
    } else if (weatherCondition.contains('cloud')) {
      imagePath = 'assets/cloudy.jpg';
    } else if (weatherCondition.contains('rain')) {
      imagePath = 'assets/rainy.jpg';
    } else if (weatherCondition.contains('snow')) {
      imagePath = 'assets/snow.jpg';
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        toolbarHeight: 80,
        centerTitle: true,
        actions: const [
          Icon(Icons.wb_sunny_outlined),
          Padding(
            padding: EdgeInsets.only(right: 30.0),
          )
        ],
        backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      ),
      body: Stack(
        children: [
          // Background image
          if (imagePath.isNotEmpty)
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          Center(
            child: _currentPosition == null
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_city',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 52, 52, 52)),
                      ),
                      Image.network(
                        '$_weatherIconUrl',
                      ),
                      _description != null && _temperature != null
                          ? Column(
                              children: [
                                Text(
                                  '${_temperature!.toStringAsFixed(0)}°C',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 52, 52, 52)),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '$_description'.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 52, 52, 52)),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  timeDisplay,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 52, 52, 52)),
                                ),
                              ],
                            )
                          : const CircularProgressIndicator(),
                    ],
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 70, 193, 255),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        selectedIconTheme: const IconThemeData(
            color: Color.fromARGB(255, 70, 193, 255), size: 30),
        unselectedItemColor: const Color.fromARGB(255, 13, 85, 121),
        unselectedIconTheme:
            const IconThemeData(color: Color.fromARGB(255, 13, 85, 121)),
        backgroundColor: const Color.fromARGB(255, 52, 52, 52),
        currentIndex: _currentIndex, // Add this line
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected tab index
          });

          // Perform your navigation based on the index
          if (index == 0) {
            GoRouter.of(context).go('/');
          } else if (index == 1) {
            GoRouter.of(context).go('/about');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Weather',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }

  // Step 3: Fetch weather data from the OpenWeatherMap API
  void _getWeatherData() async {
    const String apiKey = 'xxx';
    if (_currentPosition == null) {
      return; // Exit early if no location is available
    }
    final String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=${_currentPosition?.latitude}&lon=${_currentPosition?.longitude}&appid=$apiKey&units=metric&lang=en';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Parse the JSON data
      final jsonData = json.decode(response.body);
      // Extract the relevant weather information from jsonData
      final weatherData = jsonData['weather'][0];
      final mainData = jsonData['main'];
      String description = weatherData['description'];
      double temperature = mainData['temp'];
      String city = jsonData['name'];
      String weatherIcon = weatherData['icon'];
      String weatherIconUrl = '';
      if (weatherIcon.isNotEmpty) {
        weatherIconUrl =
            'https://openweathermap.org/img/wn/$weatherIcon@4x.png';
      } else {
        // Handle the case when weatherIcon is null or empty
        weatherIconUrl = ''; // Provide a default icon URL or empty string
      }

      setState(() {
        _city = city;
        _description = description;
        _temperature = temperature;
        _weatherIconUrl = weatherIconUrl;
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
