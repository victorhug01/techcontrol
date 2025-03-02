import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:techcontrol/app/theme.dart';
import 'package:techcontrol/model/sign_in_model.dart';
import 'package:techcontrol/services/supabase_service.dart';
import 'package:techcontrol/widgets/snackbar_widget.dart';

class SignInViewModel extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  bool isLoading = false;

  Future<void> signIn(SignInModel signInModel, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await _supabaseService.signIn(signInModel.email, signInModel.password);

      if (response.session != null) {
        if (context.mounted) {
          context.go('/home');
        }
      } else {
        throw Exception("Falha ao autenticar");
      }
    } catch (e) {
      if (context.mounted) {
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
}
