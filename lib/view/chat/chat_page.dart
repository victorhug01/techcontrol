import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:techcontrol/viewmodel/chat_viewmodel.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatViewModel(),
      child: Scaffold(
        body: Consumer<ChatViewModel>(
          builder: (context, viewModel, child) {
            return DashChat(
              messageOptions: const MessageOptions(borderRadius: 10.0),
              inputOptions: InputOptions(
                inputToolbarMargin: EdgeInsets.only(left: 10.0),
                inputDecoration: InputDecoration(
                  hintText: "Pesquisar por algo...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                trailing: [
                  SpeedDial(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    children: [
                      SpeedDialChild(
                        child: Icon(Icons.image),
                        label: 'Imagem',
                        onTap: () {
                          viewModel.pickAndSendMedia(MediaType.image);
                        },
                      ),
                      SpeedDialChild(
                        child: Icon(Icons.file_present),
                        label: 'Arquivo',
                        onTap: () {
                          viewModel.pickAndSendMedia(MediaType.file);
                        },
                      ),
                    ],
                    child: Icon(Icons.attachment_sharp),
                  ),
                ],
              ),
              currentUser: viewModel.currentUser,
              onSend: viewModel.sendMessage,
              messages: viewModel.messages,
            );
          },
        ),
      ),
    );
  }
}
