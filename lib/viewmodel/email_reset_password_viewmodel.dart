import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:techcontrol/app/theme.dart';
import 'package:techcontrol/model/email_reset_password_model.dart';
import 'package:techcontrol/services/supabase_service.dart';
import 'package:techcontrol/widgets/snackbar_widget.dart';

class EmailForResetPasswordViewModel extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  bool isLoading = false;

  Future<void> emailResetPassword(
    EmailResetPasswordModel emailResetPassword,
    BuildContext context,
  ) async {
    try {
      isLoading = true;
      notifyListeners();
      _supabaseService.emailResetPassword(emailResetPassword.email);

      if (context.mounted) {
        context.push('/verify_otp_page', extra: emailResetPassword.email);
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarService.showDetails(
          context,
          "Erro ao enviar co, tente novamente!",
          AppTheme.lightTheme.colorScheme.error,
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
