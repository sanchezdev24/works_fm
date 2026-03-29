import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

abstract class FeatureModule {
  void register(GetIt it);
  List<RouteBase> routes();
  List<LocalizationsDelegate> get delegates => [];
}