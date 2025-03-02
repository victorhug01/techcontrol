import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:techcontrol/app/theme.dart';
import 'package:techcontrol/model/sign_up_model.dart';
import 'package:techcontrol/services/supabase_service.dart';
import 'package:techcontrol/widgets/snackbar_widget.dart';

class SignUpViewModel extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  bool isLoading = false;

  Future<void> signUp(SignUpModel signUpModel, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await _supabaseService.signUp(signUpModel.email, signUpModel.password);

      if (response.session != null) {
        if (context.mounted) {
          SnackbarService.showDetails(context, "Conta criada com sucesso!", Colors.green);
          context.go('/login');
        }
      } else {
        throw Exception("Falha ao autenticar");
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarService.showDetails(context, e.toString(), AppTheme.lightTheme.colorScheme.error);
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
