import 'package:core/core.dart' as core;
import 'package:dashboard/dashboard.dart';
import 'package:works_fm/src/featues/splash/bloc/splash_bloc.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(SplashEventGoLogin());
  }
  @override
  Widget build(BuildContext context) {
    return core.BlocListener<SplashBloc, SplashState>(listener: (context, state) {
      if(state is SplashStateIsGoLogin) {
        context.go(DashboardRoutesPaths.dashboard);
      }
    },child: Center(child: Text('Splash'),),);
  }
}