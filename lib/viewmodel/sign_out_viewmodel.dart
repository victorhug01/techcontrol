import 'package:flutter/widgets.dart';
import 'package:techcontrol/model/sign_out_model.dart';
import 'package:techcontrol/services/supabase_service.dart';

class SignOutViewModel extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  bool isLoading = false;
  Future<void> signOut(SignOutModel signOutModel) async {
    if (signOutModel.confirmSignOut) {
      await _supabaseService.signOut();
      notifyListeners();
    }
  }
}
