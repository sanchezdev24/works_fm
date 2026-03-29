
import 'package:core/utils/typedefs.dart';
import 'package:dashboard/src/features/main/domain/entities/job_entity.dart';
import 'package:dashboard/src/features/main/domain/usecases/get_jobs_usecase.dart';

abstract class JobsRepository {
  ResultFuture<List<JobEntity>> getJobs(GetJobsParams params);
}
