
import 'package:dashboard/dashboard.dart';
import 'package:dashboard/src/composition/di/di_dashboard.dart';
import 'package:dashboard/src/composition/router/dashboard_routes.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

class DashboardModules extends FeatureModule {
  @override
  void register(GetIt it) {
    registerDashboardModules(it);
  }

  @override
  List<RouteBase> routes() => dashboardRoutes;

  @override
  List<LocalizationsDelegate> get delegates => [
    DashboardLocalizations.delegate,
  ];
}