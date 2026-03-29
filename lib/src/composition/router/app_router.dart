import 'package:core/core.dart';
import 'package:works_fm/src/composition/di/feature_modules.dart';
import 'package:works_fm/src/composition/router/app_router_paths.dart';
import 'package:works_fm/src/featues/splash/bloc/splash_bloc.dart';
import 'package:works_fm/src/featues/splash/screens/error_screen.dart';
import 'package:works_fm/src/featues/splash/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
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
}