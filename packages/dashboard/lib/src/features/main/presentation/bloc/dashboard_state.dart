part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, success, failure, loadingMore }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final List<JobEntity> jobs;
  final String? errorMessage;
  final String? selectedJobType;
  final String searchQuery;
  final bool hasReachedMax;
  final int currentPage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.jobs = const [],
    this.errorMessage,
    this.selectedJobType,
    this.searchQuery = '',
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  bool get isInitial => status == DashboardStatus.initial;
  bool get isLoading => status == DashboardStatus.loading;
  bool get isSuccess => status == DashboardStatus.success;
  bool get isFailure => status == DashboardStatus.failure;
  bool get isLoadingMore => status == DashboardStatus.loadingMore;

  DashboardState copyWith({
    DashboardStatus? status,
    List<JobEntity>? jobs,
    String? errorMessage,
    String? selectedJobType,
    String? searchQuery,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      jobs: jobs ?? this.jobs,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedJobType: selectedJobType ?? this.selectedJobType,
      searchQuery: searchQuery ?? this.searchQuery,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        jobs,
        errorMessage,
        selectedJobType,
        searchQuery,
        hasReachedMax,
        currentPage,
      ];
}
