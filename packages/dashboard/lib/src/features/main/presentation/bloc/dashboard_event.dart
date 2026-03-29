part of 'dashboard_bloc.dart';

abstract class DashboardEvent {
}

class DashboardLoadJobsEvent extends DashboardEvent {
  final String? jobType;
  final String? experienceLevel;
  final String? search;

  DashboardLoadJobsEvent({
    this.jobType,
    this.experienceLevel,
    this.search,
  });
}

class DashboardRefreshJobsEvent extends DashboardEvent {
}

class DashboardLoadMoreJobsEvent extends DashboardEvent {
}

class DashboardSearchChangedEvent extends DashboardEvent {
  final String query;

  DashboardSearchChangedEvent({required this.query});
}

class DashboardFilterByJobTypeEvent extends DashboardEvent {
  final String? jobType;

  DashboardFilterByJobTypeEvent({this.jobType});
}
