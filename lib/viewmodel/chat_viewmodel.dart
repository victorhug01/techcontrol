import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:techcontrol/services/chat_service.dart';

class ChatViewModel extends ChangeNotifier {
  final Gemini gemini = Gemini.instance;
  final ChatService _chatService = ChatService();

  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  late ChatUser currentUser;
  late ChatUser geminiUser;

  bool isThinking = false;

  ChatViewModel() {
    currentUser = ChatUser(id: '0', firstName: 'User');
    geminiUser = ChatUser(
      id: '1',
      firstName: 'Gemini',
      profileImage:
          'https://static.vecteezy.com/system/resources/previews/046/861/646/non_2x/gemini-icon-on-a-transparent-background-free-png.png',
    );
  }

void sendMessage(ChatMessage chatMessage) {
  _messages = [chatMessage, ..._messages];
  notifyListeners();

  _setThinking(true);

  List<Uint8List>? images;
  if (chatMessage.medias?.isNotEmpty ?? false) {
    images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
  }

  // Criar uma mensagem temporária do Gemini
  ChatMessage thinkingMessage = ChatMessage(
    user: geminiUser,
    createdAt: DateTime.now(),
    text: "Pensando... 🤔",
  );

  _messages = [thinkingMessage, ..._messages];
  notifyListeners();

  // Índice da mensagem do Gemini que será atualizada
  int geminiMessageIndex = 0;

  _chatService.sendMessage(chatMessage.text, images).listen((event) {
    String response = event!.content?.parts
            ?.whereType<TextPart>()
            .map((part) => part.text.trim())
            .join(' ') ?? "";

    response = response.replaceAll('.', '.\n');

    // Atualiza a resposta dentro da mensagem existente do Gemini
    _messages[geminiMessageIndex] = ChatMessage(
      user: geminiUser,
      createdAt: _messages[geminiMessageIndex].createdAt,
      text: _messages[geminiMessageIndex].text == "Pensando... 🤔"
          ? response
          : "${_messages[geminiMessageIndex].text} $response",
    );

    notifyListeners();
  }, onDone: () {
    _setThinking(false);
  });
}


  Future<void> pickAndSendMedia(MediaType mediaType) async {
    XFile? file;

    if (mediaType == MediaType.image) {
      file = await ImagePicker().pickImage(source: ImageSource.gallery);
    } else if (mediaType == MediaType.file) {
      // Filtrando para permitir apenas PDFs
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        file = XFile(result.files.single.path!);

        if (file.name.split('.').last != 'pdf') {
          return;
        }
      }
    }

    if (file != null) {
      ChatMessage loadingMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Carregando mídia... ⏳",
        medias: [ChatMedia(url: file.path, fileName: file.name, type: mediaType)],
      );

      _messages = [loadingMessage, ..._messages];
      notifyListeners();

      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: mediaType == MediaType.image
            ? "Descreva essa imagem?"
            : "Descreva esse documento?",
        medias: [ChatMedia(url: file.path, fileName: file.name, type: mediaType)],
      );

      Future.delayed(Duration(seconds: 2), () {
        _messages.remove(loadingMessage);
        sendMessage(chatMessage);
      });
    }
  }

  void _setThinking(bool value) {
    isThinking = value;
    notifyListeners();
  }
}