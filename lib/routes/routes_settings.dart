import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:techcontrol/main.dart';
import 'package:techcontrol/services/supabase_service.dart';
import 'package:techcontrol/view/auth/signin/sign_in_page.dart';
import 'package:techcontrol/view/auth/signup/sign_up_page.dart';
import 'package:techcontrol/view/connectivity/connectivity_page.dart';
import 'package:techcontrol/view/navigation_home/home_navigation.dart';

class RoutersApp {
  final GoRouter routesConfig = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final session = SupabaseService().currentUser;
      final isLoggingIn = state.matchedLocation == '/login';
      final isSigningUp = state.matchedLocation == '/cadastro';
      final hasConnection = ConnectionNotifier.of(context).value;

      if (!hasConnection) {
        return '/connectivity';
      }

      if (session == null && !isLoggingIn && !isSigningUp) {
        return '/login';
      }

      if (session != null && (isLoggingIn || isSigningUp)) {
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
    ],
  );
}
