

import 'package:core/core.dart';
import 'package:core/error/failures.dart';
import 'package:core/utils/typedefs.dart';
import 'package:dashboard/src/features/main/data/datasources/jobs_remote_datasource.dart';
import 'package:dashboard/src/features/main/domain/entities/job_entity.dart';
import 'package:dashboard/src/features/main/domain/repositories/jobs_repository.dart';
import 'package:dashboard/src/features/main/domain/usecases/get_jobs_usecase.dart';

class JobsRepositoryImpl implements JobsRepository {
  final JobsRemoteDataSource remoteDataSource;

  const JobsRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<List<JobEntity>> getJobs(GetJobsParams params) =>
      TaskEither.tryCatch(
        () async => remoteDataSource.getJobs(
          search: params.search,
          jobType: params.jobType,
          experienceLevel: params.experienceLevel,
          page: params.page,
          limit: params.limit,
        ),
        (error, _) {
          if (error is DioException) {
            return UnexpectedFailure(code: 'network_error', message: error.message);
          }
          return UnexpectedFailure(code:'unexpected_error', message: error.toString());
        },
      );
}
