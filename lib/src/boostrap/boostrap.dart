import 'package:core/core.dart';
import 'package:works_fm/src/composition/di/app_di.dart';
import 'package:flutter/material.dart';

Future<GetIt> boostrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  const baseUrl = 'https://works-backend-sckq.onrender.com/api/v1';
  final it = await setudDI(baseUrl);
  return it;
}