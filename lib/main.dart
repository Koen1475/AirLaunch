import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thrown Height Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Navigeer naar HomePage als de initiële route
      initialRoute: '/',
      routes: {
        // Definieer de routes voor verschillende pagina's
        '/': (context) => HomePage(),
        '/thrownHeightPage': (context) => ThrownHeightPage(),
      },
    );
  }
}

// Home pagina
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AirLaunch',
          style: TextStyle(
            fontSize:
                44.0, // Hier wordt de lettergrootte van de app-balk tekst ingesteld
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle:
            true, // Deze eigenschap zorgt ervoor dat de titel in het midden van de app-balk wordt geplaatst
        backgroundColor: Colors.transparent, // Kleur van de app-balk
        elevation: 0, // Hiermee verwijder je de schaduw van de app-balk
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigeer naar de pagina die de worp-hoogte berekent
            Navigator.pushNamed(context, '/thrownHeightPage');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 8, 179, 105),
            padding: EdgeInsets.only(right: 35, left: 35, top: 15, bottom: 15),
          ),
          child: Text(
            'THROW!',
            style: TextStyle(
                color: Colors.white, fontSize: 38, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}

// Pagina voor de worp-hoogte berekening
class ThrownHeightPage extends StatefulWidget {
  @override
  _ThrownHeightPageState createState() => _ThrownHeightPageState();
}

class _ThrownHeightPageState extends State<ThrownHeightPage> {
  double _thrownHeight = 0.0;
  AccelerometerEvent? _previousEvent;
  late DateTime _previousTime;
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    _previousTime = DateTime.now();
    // Initialize the accelerometer sensor
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      if (_previousEvent != null) {
        // Calculate the acceleration change
        double accelerationChange = event.x +
            event.y +
            event.z -
            _previousEvent!.x -
            _previousEvent!.y -
            _previousEvent!.z;
        // Check if acceleration change indicates throwing motion
        if (accelerationChange > 20.0) {
          // Calculate thrown height using a simple physics formula
          setState(() {
            final currentTime = DateTime.now();
            final timeDifference =
                currentTime.difference(_previousTime).inMilliseconds /
                    1000; // Convert to seconds
            _thrownHeight = 0.5 * 9.81 * timeDifference * timeDifference;
            _previousTime = currentTime;
          });
        }
      }
      _previousEvent = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'AirLaunch',
          style: TextStyle(
            fontSize:
                44.0, // Hier wordt de lettergrootte van de app-balk tekst ingesteld
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle:
            true, // Deze eigenschap zorgt ervoor dat de titel in het midden van de app-balk wordt geplaatst
        backgroundColor: Colors.transparent, // Kleur van de app-balk
        elevation: 0, // Hiermee verwijder je de schaduw van de app-balk
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 8, 179, 105),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Text(
                    'Thrown Height:',
                    style: TextStyle(fontSize: 24.0, color: Colors.white),
                  ),
                  Text(
                    _thrownHeight.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 56.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Centimeters',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Voeg een navigatiebalk toe onderaan de pagina
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent, // maak de achtergrond transparant
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                // Navigeer terug naar de Home pagina
                Navigator.pushNamed(context, '/');
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.home,
                    color: Color.fromARGB(255, 8, 179, 105),
                  ),
                  Text(
                    'Home',
                    style: TextStyle(color: Color.fromARGB(255, 8, 179, 105)),
                  ),
                ],
              ),
            ),
            SizedBox(
                width:
                    20), // Voeg wat ruimte toe tussen het pictogram en de tekst
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Cancel accelerometer subscription to prevent memory leaks
    _accelerometerSubscription.cancel();
  }
}
