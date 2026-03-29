import 'package:core/core.dart';
import 'package:core/di/core_di.dart';
import 'package:works_fm/src/composition/di/feature_modules.dart';
import 'package:works_fm/src/composition/router/app_router.dart';
import 'package:works_fm/src/featues/splash/bloc/splash_bloc.dart';
import 'package:flutter/material.dart';

Future<GetIt> setudDI(String baseUrl) async {
  final it = GetIt.instance;
  registerCore(it, baseUrl: baseUrl);
  for (final module in featureModules) {
    module.register(it);
  }
  it.registerFactory<SplashBloc>(
    () => SplashBloc(),
  );
  await it.allReady();

  it.registerLazySingleton<RouteObserver<ModalRoute<void>>>(
    () =>RouteObserver<ModalRoute<void>>(),
  );
  it.registerLazySingleton<AppRouter>(
    () => AppRouter(it),
  );
  return it;
}