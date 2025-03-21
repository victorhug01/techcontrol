import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:techcontrol/main.dart';
import 'package:techcontrol/services/supabase_service.dart';
import 'package:techcontrol/view/auth/add_email_reset/email_reset_password_page.dart';
import 'package:techcontrol/view/auth/reset_password/reset_password_page.dart';
import 'package:techcontrol/view/auth/signin/sign_in_page.dart';
import 'package:techcontrol/view/auth/signup/sign_up_page.dart';
import 'package:techcontrol/view/auth/verify_otp/verify_otp_page.dart';
import 'package:techcontrol/view/connectivity/connectivity_page.dart';
import 'package:techcontrol/view/navigation_home/home_navigation.dart';

class RoutersApp {
  final GoRouter routesConfig = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final session = SupabaseService().currentUser;
      final isLoggingIn = state.matchedLocation == '/login';
      final isSigningUp = state.matchedLocation == '/cadastro';
      final isEmailResetPassWrd = state.matchedLocation == '/email_for_reset';
      final isVerifyOTP = state.matchedLocation == '/verify_otp_page';
      final hasConnection = ConnectionNotifier.of(context).value;

      if (!hasConnection) {
        return '/connectivity';
      }

      if (session == null && !isLoggingIn && !isSigningUp && !isEmailResetPassWrd && !isVerifyOTP) {
        return '/login';
      }

      if (session != null && (isLoggingIn || isSigningUp || isEmailResetPassWrd || isVerifyOTP)) {
        return '/navigation_screens';
      }

      return null;
    },

    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) {
          return const SignInPage();
        },
      ),
      GoRoute(
        path: '/cadastro',
        name: 'cadastro',
        builder: (BuildContext context, GoRouterState state) => SignUpPage(),
      ),
      GoRoute(
        path: '/navigation_screens',
        name: 'navigation_screens',
        builder: (BuildContext context, GoRouterState state) {
          return const NavigationHomeScreens();
        },
      ),
      GoRoute(
        path: '/connectivity',
        name: 'connectivity',
        builder: (BuildContext context, GoRouterState state) {
          return const ConnectivityPage();
        },
      ),
      GoRoute(
        path: '/email_for_reset',
        name: 'email_for_reset',
        builder: (BuildContext context, GoRouterState state) => const EmailForResetPassordPage(),
      ),
      GoRoute(
        path: '/reset_password',
        name: 'reset_password',
        builder: (BuildContext context, GoRouterState state) {
          return const ResetPasswordPage();
        },
      ),
      GoRoute(
        path: '/verify_otp_page',
        name: 'verify_otp_page',
        builder: (BuildContext context, GoRouterState state) {
          final email = state.extra as String? ?? ''; // Recupera o email do extra
          return VerifyOTPPage(email: email);
        },
      ),
    ],
  );
}
