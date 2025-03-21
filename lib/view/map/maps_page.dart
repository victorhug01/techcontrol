import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:techcontrol/app/theme.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late MapController _mapController;
  LatLng _currentPosition = LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    Position position = await Geolocator.getCurrentPosition();

    LatLng newPosition = LatLng(position.latitude, position.longitude);

    if (newPosition != _currentPosition) {
      if (mounted) {
        setState(() {
          _currentPosition = newPosition;
          _mapController.move(_currentPosition, 15.0);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _currentPosition,
            initialZoom: 13.0,
            minZoom: 5.0,
            maxZoom: 20.0,
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=${dotenv.env['TOMTOM_MAPS_API_KEY']!}',
              userAgentPackageName: 'unknow',
              tileDisplay: TileDisplay.fadeIn(),
              minZoom: 5,
              maxZoom: 18,
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: _currentPosition,
                  child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
