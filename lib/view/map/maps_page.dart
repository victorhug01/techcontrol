import 'package:flutter/material.dart';

class MapsPageSdk extends StatefulWidget {
  const MapsPageSdk({super.key});

  @override
  State<MapsPageSdk> createState() => _MapsPageSdkState();
}

class _MapsPageSdkState extends State<MapsPageSdk> {
  @override
  Widget build(BuildContext context) {
    return AndroidView(viewType: 'tomtom_map',layoutDirection: TextDirection.ltr,);
  }
}
