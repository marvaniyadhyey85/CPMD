
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorScreen extends StatefulWidget {
  const SensorScreen({super.key});

  @override
  State<SensorScreen> createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  StreamSubscription<AccelerometerEvent>? subscription;

  double x = 0;
  double y = 0;
  double z = 0;
  String message = 'Move or shake your device';

  @override
  void initState() {
    super.initState();

    subscription = accelerometerEventStream().listen(
      (event) {
        final double magnitude = math.sqrt(
          event.x * event.x +
          event.y * event.y +
          event.z * event.z,
        );

        if (!mounted) return;

        setState(() {
          x = event.x;
          y = event.y;
          z = event.z;

          if (magnitude > 18) {
            message = 'Device shaken!';
          } else {
            message = 'Device sensor is active';
          }
        });
      },
      onError: (error) {
        if (!mounted) return;
        setState(() {
          message = 'Sensor is unavailable.';
        });
      },
    );
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor & Shake Detection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sensors,
              size: 85,
              color: Colors.indigo,
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            sensorCard('X-axis', x),
            sensorCard('Y-axis', y),
            sensorCard('Z-axis', z),
            const SizedBox(height: 15),
            const Text(
              'Readings update when the device moves.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget sensorCard(String axis, double value) {
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.speed,
          color: Colors.indigo,
        ),
        title: Text(axis),
        trailing: Text(
          '${value.toStringAsFixed(2)} m/s²',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
