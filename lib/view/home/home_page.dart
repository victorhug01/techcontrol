import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:techcontrol/app/theme.dart';
import 'package:techcontrol/model/sign_out_model.dart';
import 'package:techcontrol/services/supabase_service.dart';
import 'package:techcontrol/viewmodel/sign_out_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = SupabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
      body: Center(
        child: Text('Bem-vindo(a)'),
      ),
    );
  }
}
