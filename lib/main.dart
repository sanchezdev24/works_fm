
import 'package:flutter/material.dart';
import 'package:works_fm/app_init.dart';
import 'package:works_fm/src/boostrap/boostrap.dart';

void main() async {
  final it = await boostrap();
  runApp(AppInit(it: it,));
}
