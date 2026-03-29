import 'package:auth/src/composition/router/router.dart';
import 'package:auth/src/features/login/presentation/bloc/login_bloc.dart';
import 'package:auth/src/features/login/presentation/screens/login_screen.dart';
import 'package:core/core.dart';

final List<GoRoute> authRoutes = [
  GoRoute(
    path: AuthRoutesPaths.login,
    builder: (context, state) => BlocProvider(
      create: (context) => GetIt.I<LoginBloc>(),
      child: const LoginScreen(),
    )),
];