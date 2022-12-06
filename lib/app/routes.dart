import 'package:flutter/material.dart';
import 'package:flutter_firebase_multi_auth/pages/dashboard_page.dart';
import 'package:flutter_firebase_multi_auth/pages/email_verify_page.dart';
import 'package:flutter_firebase_multi_auth/pages/login_page.dart';
import 'package:flutter_firebase_multi_auth/pages/settings_page.dart';
import 'package:flutter_firebase_multi_auth/pages/tasks_page.dart';
import 'package:flutter_firebase_multi_auth/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/settings',
    redirect: (BuildContext context, GoRouterState state) {
      if (authService.status == AuthStatus.signedOut) {
        return '/login';
      } else if (authService.status == AuthStatus.emailVerifyPending) {
        return '/email-verify';
      } else if (authService.status == AuthStatus.signedIn && state.location.contains('/login')) {
        return '/settings';
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/email-verify',
        builder: (BuildContext context, GoRouterState state) {
          return const EmailVerifyPage();
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (BuildContext context, GoRouterState state) {
          return const SettingsPage();
        },
      ),
      GoRoute(
        path: '/dashboard',
        builder: (BuildContext context, GoRouterState state) {
          return const DashboardPage();
        },
      ),
      GoRoute(
        path: '/tasks',
        builder: (BuildContext context, GoRouterState state) {
          return const TasksPage();
        },
      ),
    ],
  );
});
