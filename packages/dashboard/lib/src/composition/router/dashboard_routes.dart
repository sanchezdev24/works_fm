import 'package:dashboard/src/composition/router/router.dart';
import 'package:core/core.dart';
import 'package:dashboard/src/features/main/presentation/bloc/dashboard_bloc.dart';
import 'package:dashboard/src/features/main/presentation/pages/jobs_screen.dart';

final List<GoRoute> dashboardRoutes = [
 /* GoRoute(
    path: DashboardRoutesPaths.dashboard,
    builder: (context, state) => BlocProvider(
      create: (_) => GetIt.I<DashboardBloc>()
        ..add( DashboardLoadJobsEvent()),
      child: const DashboardScreen(),
    ),
  ), */
];