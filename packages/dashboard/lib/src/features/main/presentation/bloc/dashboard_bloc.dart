

import 'package:core/core.dart';
import 'package:dashboard/src/features/main/domain/entities/job_entity.dart';
import 'package:dashboard/src/features/main/domain/usecases/get_jobs_usecase.dart';
part 'dashboard_event.dart';
part 'dashboard_state.dart';
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetJobsUseCase getJobsUseCase;

  static const int _pageLimit = 20;

  DashboardBloc({required this.getJobsUseCase})
      : super(const DashboardState()) {
    on<DashboardLoadJobsEvent>(_onLoadJobs);
    on<DashboardRefreshJobsEvent>(_onRefreshJobs);
    on<DashboardLoadMoreJobsEvent>(_onLoadMoreJobs);
    on<DashboardSearchChangedEvent>(_onSearchChanged);
    on<DashboardFilterByJobTypeEvent>(_onFilterByJobType);
  }

  Future<void> _onLoadJobs(
    DashboardLoadJobsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));

    final result = await getJobsUseCase
        .call(
          GetJobsParams(
            jobType: event.jobType ?? state.selectedJobType,
            search: event.search ?? state.searchQuery,
            limit: _pageLimit,
            page: 1,
          ),
        )
        .run();

    result.match(
      (failure) => emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: failure.message ?? failure.toString(),
      )),
      (jobs) => emit(state.copyWith(
        status: DashboardStatus.success,
        jobs: jobs,
        currentPage: 1,
        hasReachedMax: jobs.length < _pageLimit,
      )),
    );
  }

  Future<void> _onRefreshJobs(
    DashboardRefreshJobsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    add(DashboardLoadJobsEvent(
      jobType: state.selectedJobType,
      search: state.searchQuery,
    ));
  }

  Future<void> _onLoadMoreJobs(
    DashboardLoadMoreJobsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    if (state.hasReachedMax || state.isLoadingMore) return;

    emit(state.copyWith(status: DashboardStatus.loadingMore));

    final nextPage = state.currentPage + 1;

    final result = await getJobsUseCase
        .call(
          GetJobsParams(
            jobType: state.selectedJobType,
            search: state.searchQuery,
            limit: _pageLimit,
            page: nextPage,
          ),
        )
        .run();

    result.match(
      (failure) => emit(state.copyWith(
        status: DashboardStatus.success,
        errorMessage: failure.message ?? failure.toString(),
      )),
      (newJobs) {
        final allJobs = [...state.jobs, ...newJobs];
        emit(state.copyWith(
          status: DashboardStatus.success,
          jobs: allJobs,
          currentPage: nextPage,
          hasReachedMax: newJobs.length < _pageLimit,
        ));
      },
    );
  }

  Future<void> _onSearchChanged(
    DashboardSearchChangedEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
    add(DashboardLoadJobsEvent(search: event.query));
  }

  Future<void> _onFilterByJobType(
    DashboardFilterByJobTypeEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(selectedJobType: event.jobType));
    add(DashboardLoadJobsEvent(jobType: event.jobType));
  }
}
