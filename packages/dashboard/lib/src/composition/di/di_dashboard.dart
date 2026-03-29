
import 'package:core/core.dart';
import 'package:dashboard/src/features/main/data/datasources/jobs_remote_datasource.dart';
import 'package:dashboard/src/features/main/data/repositories/jobs_repository_impl.dart';
import 'package:dashboard/src/features/main/domain/repositories/jobs_repository.dart';
import 'package:dashboard/src/features/main/domain/usecases/get_jobs_usecase.dart';
import 'package:dashboard/src/features/main/presentation/bloc/dashboard_bloc.dart';

void registerDashboardModules(GetIt it) {
  it.registerFactory<JobsRemoteDataSource>(
    () => JobsRemoteDataSourceImpl(dio: it<Dio>()),
  );
 
  it.registerFactory<JobsRepository>(
    () => JobsRepositoryImpl(remoteDataSource: it<JobsRemoteDataSource>()),
  );
 
  it.registerFactory<GetJobsUseCase>(
    () => GetJobsUseCase(repository: it<JobsRepository>()),
  );
 
  it.registerFactory<DashboardBloc>(
    () => DashboardBloc(getJobsUseCase: it<GetJobsUseCase>()),
  );
}