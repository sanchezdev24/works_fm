import 'package:core/core.dart';
import 'package:dashboard/dashboard.dart';
import 'package:works_fm/src/composition/di/feature_modules.dart';
import 'package:works_fm/src/composition/router/app_router_paths.dart';
import 'package:works_fm/src/composition/router/app_shell.dart';
import 'package:works_fm/src/featues/splash/bloc/splash_bloc.dart';
import 'package:works_fm/src/featues/splash/screens/error_screen.dart';
import 'package:works_fm/src/featues/splash/screens/splash_screen.dart';
import 'package:flutter/material.dart';

/* class AppRouter {
  final GetIt it;
  AppRouter(this.it);

  late final GoRouter router = GoRouter(
    initialLocation: AppRouterPaths.splash,
    redirect: _redirect,
    routes: [
      GoRoute(path: AppRouterPaths.splash,
      builder: (context, state) => BlocProvider(
        create: (context) => it<SplashBloc>(),
        child: const SplashScreen(),
      )),
      ...featureModules.expand((f)=>f.routes())
    ],
    observers: [
      it<RouteObserver<ModalRoute<void>>>()
    ],
    errorBuilder: (context, state) => ErrorScreen(errorMsg: state.error!.message),
  );

  String? _redirect(BuildContext context, GoRouterState state) {
    return null;
  }
} */

// lib/src/composition/router/app_router.dart
class AppRouter {
  final GetIt it;
  AppRouter(this.it);

  late final GoRouter router = GoRouter(
    initialLocation: AppRouterPaths.splash,
    routes: [
      // ── Splash (fuera del shell) ──────────────────────────────
      GoRoute(
        path: AppRouterPaths.splash,
        builder: (context, state) => BlocProvider(
          create: (_) => it<SplashBloc>(),
          child: const SplashScreen(),
        ),
      ),

      // ── Login (fuera del shell) ───────────────────────────────
       ...featureModules.expand((f)=>f.routes()),

      // ── Shell con Bottom Nav ──────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          // Tab 0 - Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: DashboardRoutesPaths.dashboard,
                builder: (context, state) => BlocProvider(
                  create: (_) => GetIt.I<DashboardBloc>()
                    ..add( DashboardLoadJobsEvent()),
                  child: const DashboardScreen(),
                ),
              ),
            ],
          ),

          // Tab 1 - 
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/my-jobs',
                builder: (context, state) => Center(child: Text('My Jobs'),),
              ),
            ],
          ),

          // Tab 2 - 
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => Center(child: Text('Profile'),),
              ),
            ],
          ),
        ],
      ),
    ],
    observers: [it<RouteObserver<ModalRoute<void>>>()],
    errorBuilder: (context, state) => ErrorScreen(errorMsg: state.error!.message),
    redirect: _redirect
  );

   String? _redirect(BuildContext context, GoRouterState state) {
    return null;
  }
}