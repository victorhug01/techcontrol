import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:techcontrol/app/theme.dart';
import 'package:techcontrol/model/sign_out_model.dart';
import 'package:techcontrol/viewmodel/sign_out_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    setState(() {
      _currentPosition = newPosition;
      _mapController.move(_currentPosition, 15.0);
    });
  }
}


  @override
  Widget build(BuildContext context) {
    final String apiKey = "iYIAzn2GA4clGsdVIFk2wpHa7krLKLca";

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              if (context.mounted) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                      ),
                    );
                  },
                );
              }
              await context.read<SignOutViewModel>().signOut(SignOutModel());
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
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
                  'https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=$apiKey', // ✅ Corrigido para usar {z}/{x}/{y}
              userAgentPackageName: 'unknow',
              tileDisplay: TileDisplay.fadeIn(),
              minZoom: 5,
              maxZoom: 18,
              retinaMode: true,
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
