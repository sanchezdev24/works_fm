

import 'package:auth/auth.dart';
import 'package:auth/src/composition/di/di_auth.dart';
import 'package:auth/src/composition/router/auth_routes.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

class AuthModules extends FeatureModule {
  @override
  void register(GetIt it) {
    registerAuthModules(it);
  }

  @override
  List<RouteBase> routes() => authRoutes;

  @override
  List<LocalizationsDelegate> get delegates => [
    AuthLocalizations.delegate,
  ];
}