import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:techcontrol/services/supabase_service.dart';
import 'package:techcontrol/view/auth/signin/sign_in_page.dart';
import 'package:techcontrol/view/auth/signup/sign_up_page.dart';
import 'package:techcontrol/view/home/home_page.dart';

class RoutersApp {
  final GoRouter routesConfig = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final session = SupabaseService().currentUser;
      final isLoggingIn = state.matchedLocation == '/login';
      final isSigningUp = state.matchedLocation == '/cadastro';

      // Se a sessão ainda está carregando, não faz nada (evita redirecionamento prematuro)
      if (session == null && !isLoggingIn && !isSigningUp) {
        return '/login';
      }

      // Se o usuário está logado e tenta acessar login ou cadastro, redireciona para home
      if (session != null && (isLoggingIn || isSigningUp)) {
        return '/home';
      }

      return null; // Permite navegação normal
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
        path: '/home',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
    ],
  );
}
