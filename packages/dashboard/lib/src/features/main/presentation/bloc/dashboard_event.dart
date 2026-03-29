part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class DashboardLoadJobsEvent extends DashboardEvent {
  final String? jobType;
  final String? experienceLevel;
  final String? search;

  const DashboardLoadJobsEvent({
    this.jobType,
    this.experienceLevel,
    this.search,
  });

  @override
  List<Object?> get props => [jobType, experienceLevel, search];
}

class DashboardRefreshJobsEvent extends DashboardEvent {
  const DashboardRefreshJobsEvent();
}

class DashboardLoadMoreJobsEvent extends DashboardEvent {
  const DashboardLoadMoreJobsEvent();
}

class DashboardSearchChangedEvent extends DashboardEvent {
  final String query;

  const DashboardSearchChangedEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class DashboardFilterByJobTypeEvent extends DashboardEvent {
  final String? jobType;

  const DashboardFilterByJobTypeEvent({this.jobType});

  @override
  List<Object?> get props => [jobType];
}
