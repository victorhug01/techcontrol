import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  WebViewController? controller; // Removido 'late' e tornou-se nullable
  LatLng? _currentLocation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Inicializa um WebViewController básico imediatamente
    controller =
        WebViewController()
          ..enableZoom(true)
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..enableZoom(true);

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
        );
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _isLoading = false;
        });
        await _openRouteInMaps();
      } catch (e) {
        setState(() {
          _isLoading = false;
          _currentLocation = const LatLng(-22.2040141, -49.9662177);
        });
        _loadMapUrl();
      }
    } else {
      setState(() {
        _isLoading = false;
        _currentLocation = const LatLng(-22.2040141, -49.9662177);
      });
      _loadMapUrl();
    }
  }

  Future<void> _openRouteInMaps() async {
    if (_currentLocation == null) return;

    const destino = LatLng(-22.2114177, -49.9452923);
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&origin=${_currentLocation!.latitude},${_currentLocation!.longitude}'
      '&destination=${destino.latitude},${destino.longitude}'
      '&travelmode=driving',
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _loadMapUrl();
      }
    } catch (e) {
      _loadMapUrl();
    }
  }

  void _loadMapUrl() {
    if (_currentLocation == null || controller == null) return;

    const destino = LatLng(-22.2114177, -49.9452923);
    final url = _generateMapsUrl(_currentLocation!, destino);

    controller!
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            final url = request.url;
            if (url.startsWith('intent://') || url.startsWith('maps:') || url.startsWith('tel:')) {
              try {
                final uri = Uri.parse(url.replaceFirst('intent://', 'https://'));
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                  return NavigationDecision.prevent;
                }
              } catch (e) {
                debugPrint("Erro ao lançar URL: $e");
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  String _generateMapsUrl(LatLng origem, LatLng destino) {
    return 'https://www.google.com/maps/dir/'
        '${origem.latitude},${origem.longitude}/'
        '${destino.latitude},${destino.longitude}/'
        'data=!3m1!4b1!4m2!4m1!3e0';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navegação'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _isLoading = true);
              _getCurrentLocation();
            },
          ),
        ],
      ),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : WebViewWidget(controller: controller!),
      ),
    );
  }
}
