import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
 late  WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},  
      onHttpError: (HttpResponseError error) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse('https://www.google.com/maps/dir/Rua+Paulo+Centrone,+340+-+Jardim+America,+Mar%C3%ADlia+-+SP/Av.+Independ%C3%AAncia,+243+-+Mar%C3%ADlia,+SP/@-22.2077059,-49.9609513,16z/data=!3m1!4b1!4m13!4m12!1m5!1m1!1s0x94bfd6e32289b167:0x720386224a972036!2m2!1d-49.9662177!2d-22.2040141!1m5!1m1!1s0x94bfd7303b0d7551:0xf7d9032f17817001!2m2!1d-49.9452923!2d-22.2114177?entry=ttu&g_ep=EgoyMDI1MDMyNS4xIKXMDSoASAFQAw%3D%3D'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
