

import 'package:core/core.dart';

class JobEntity extends Equatable {
  final String id;
  final String applyUrl;
  final String title;
  final String company;
  final String companyLogo;
  final String experienceLevel;
  final String jobType;
  final String publishedAt;
  final String location;
  final String salary;
  final String description;
  final List<String> tags;

  const JobEntity({
    required this.id,
    required this.applyUrl,
    required this.title,
    required this.company,
    required this.companyLogo,
    required this.experienceLevel,
    required this.jobType,
    required this.publishedAt,
    required this.location,
    required this.salary,
    required this.description,
    required this.tags,
  });

  @override
  List<Object?> get props => [
        id,
        applyUrl,
        title,
        company,
        companyLogo,
        experienceLevel,
        jobType,
        publishedAt,
        location,
        salary,
        description,
        tags,
      ];
}
