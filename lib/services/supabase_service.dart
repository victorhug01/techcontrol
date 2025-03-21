import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<AuthResponse> signIn(String email, String password) async {
    return await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp(String email, String password) {
    return supabase.auth.signUp(password: password, email: email);
  }

  Future emailResetPassword(String email) {
    return supabase.auth.resetPasswordForEmail(email);
  }

  Future verifyOTP(String codeOPT, String email) {
    return supabase.auth.verifyOTP(email: email, token: codeOPT, type: OtpType.recovery);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  User? get currentUser => supabase.auth.currentUser;
}
