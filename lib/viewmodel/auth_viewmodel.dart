import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:techcontrol/app/theme.dart';
import 'package:techcontrol/services/supabase_service.dart';
import 'package:techcontrol/widgets/snackbar_widget.dart';

class AuthViewModel extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  bool isLoading = false;

  Future<void> signIn(String email, String password, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await _supabaseService.signIn(email, password);

      if (response.session != null) {
        if (context.mounted) {
          context.go('/home');
        }
      } else {
        throw Exception("Falha ao autenticar");
      }
    } catch (e) {
      if (context.mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email ou senha inválidos!")));
        SnackbarService.showDetails(
          context,
          "Email ou senha inválidos!",
          AppTheme.lightTheme.colorScheme.error,
        );
      }
      
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 LOGOUT
  Future<void> signOut() async {
    await _supabaseService.signOut();
    notifyListeners();
  }
}
