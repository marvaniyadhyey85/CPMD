
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() =>
      _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Position? currentPosition;
  String message = 'Location not fetched yet';
  bool loading = false;

  final List<String> locationHistory = [];

  Future<void> getLocation() async {
    setState(() {
      loading = true;
      message = 'Getting current location...';
    });

    try {
      bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        setState(() {
          message = 'Please enable GPS/location services.';
        });
        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          message = 'Location permission denied.';
        });
        return;
      }

      if (permission ==
          LocationPermission.deniedForever) {
        setState(() {
          message =
              'Location permission permanently denied. '
              'Enable it in app settings.';
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Enable location permission in Settings.',
            ),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () {
                Geolocator.openAppSettings();
              },
            ),
          ),
        );
        return;
      }

      final Position position =
          await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );

      if (!mounted) return;

      setState(() {
        currentPosition = position;
        message = 'Location fetched successfully.';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        message =
            'Unable to get location. Try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void recordLocation() {
    if (currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Get your location first.'),
        ),
      );
      return;
    }

    final position = currentPosition!;
    final timestamp = DateTime.now();

    final record =
        'Lat: ${position.latitude.toStringAsFixed(5)}, '
        'Lng: ${position.longitude.toStringAsFixed(5)}\n'
        'Time: ${timestamp.toLocal()}';

    setState(() {
      locationHistory.insert(0, record);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location recorded successfully.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS Location'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(
            Icons.location_on,
            size: 90,
            color: Colors.indigo,
          ),
          const SizedBox(height: 15),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17),
          ),
          const SizedBox(height: 20),

          if (currentPosition != null) ...[
            Card(
              child: ListTile(
                leading: const Icon(Icons.map),
                title: const Text('Latitude'),
                subtitle: Text(
                  currentPosition!.latitude.toString(),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.map),
                title: const Text('Longitude'),
                subtitle: Text(
                  currentPosition!.longitude.toString(),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.gps_fixed),
                title: const Text('Accuracy'),
                subtitle: Text(
                  '${currentPosition!.accuracy.toStringAsFixed(2)} metres',
                ),
              ),
            ),
          ],

          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: loading ? null : getLocation,
            icon: const Icon(Icons.my_location),
            label: Text(
              loading ? 'Fetching...' : 'Get Current Location',
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: recordLocation,
            icon: const Icon(Icons.history),
            label: const Text('Record Location & Time'),
          ),
          const SizedBox(height: 25),

          const Text(
            'Location History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          if (locationHistory.isEmpty)
            const Text('No locations recorded yet.'),

          ...locationHistory.map(
            (record) => Card(
              child: ListTile(
                leading: const Icon(
                  Icons.access_time,
                  color: Colors.indigo,
                ),
                title: Text(record),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
