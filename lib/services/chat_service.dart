import 'dart:typed_data';

import 'package:flutter_gemini/flutter_gemini.dart';

class ChatService {
  final Gemini _gemini = Gemini.instance;

  Stream<Candidates?> sendMessage(String text, List<Uint8List>? images) {
    return _gemini.promptStream(parts: [
      Part.text(text),
      if (images != null && images.isNotEmpty) Part.uint8List(images.first),
    ]);
  }
}
