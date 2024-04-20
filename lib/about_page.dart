import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AboutPage(),
    );
  }
}

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
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
      body: Container(
        color: const Color.fromARGB(255, 56, 56, 56),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'This app was created by Daniel Hed',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 70, 193, 255)),
            ),
            SizedBox(height: 60),
            Center(
              child: SizedBox(
                width: 300,
                child: Text(
                  'This weather app is created for assignment 3 in the course 1DV535 using the OpenWeatherAPI. It displays the weather of the current location that the user is located at and the look of the app is dynamic depending on the weather.',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
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
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

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
}
