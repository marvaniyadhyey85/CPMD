
import 'package:flutter/material.dart';
import 'photo_screen.dart';
import 'sensor_screen.dart';
import 'location_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Device Utility'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(
            Icons.phone_android,
            size: 90,
            color: Colors.indigo,
          ),
          const SizedBox(height: 12),
          const Text(
            'Device Utility Dashboard',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),

          featureCard(
            context,
            'Camera & Gallery',
            'Capture, select and replace photos',
            Icons.photo_camera,
            const PhotoScreen(),
          ),

          featureCard(
            context,
            'Sensors & Shake Detection',
            'Read accelerometer data',
            Icons.sensors,
            const SensorScreen(),
          ),

          featureCard(
            context,
            'GPS Location',
            'Get and record your current location',
            Icons.location_on,
            const LocationScreen(),
          ),
        ],
      ),
    );
  }

  Widget featureCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Widget screen,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.indigo,
          size: 35,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => screen,
            ),
          );
        },
      ),
    );
  }
}
