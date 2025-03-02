import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:techcontrol/model/sign_out_model.dart';
import 'package:techcontrol/viewmodel/sign_out_viewmodel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await context.read<SignOutViewModel>().signOut(SignOutModel());
              if (context.mounted) {
                context.go('/');
              }
            },
          ),
        ],
      ),
      body: const Center(
        child: Text("Bem-vindo à Home!"),
      ),
    );
  }
}
