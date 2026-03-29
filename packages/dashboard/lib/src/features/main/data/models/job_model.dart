

import 'package:dashboard/src/features/main/domain/entities/job_entity.dart';

class JobModel extends JobEntity {
  const JobModel({
    required super.id,
    required super.applyUrl,
    required super.title,
    required super.company,
    required super.companyLogo,
    required super.experienceLevel,
    required super.jobType,
    required super.publishedAt,
    required super.location,
    required super.salary,
    required super.description,
    required super.tags,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    // salary es un objeto: { min, max, currency, formatted }
    final salaryObj = json['salary'] as Map<String, dynamic>?;
    final salaryFormatted = salaryObj?['formatted'] as String? ?? '';

    return JobModel(
      id:              json['id']              as String? ?? '',
      applyUrl:        json['applyUrl']         as String? ?? '',
      title:           json['title']            as String? ?? '',
      company:         json['company']          as String? ?? '',
      companyLogo:     json['companyLogoUrl']   as String? ?? '',
      experienceLevel: json['experienceLevel']  as String? ?? '',
      jobType:         json['jobType']          as String? ?? '',
      publishedAt:     json['publishedAt']      as String? ?? '',
      location:        json['location']         as String? ?? '',
      salary:          salaryFormatted,
      description:     json['description']      as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'applyUrl': applyUrl,
      'title': title,
      'company': company,
      'companyLogoUrl': companyLogo,
      'experienceLevel': experienceLevel,
      'jobType': jobType,
      'publishedAt': publishedAt,
      'location': location,
      'salary': {'formatted': salary},
      'description': description,
      'tags': tags,
    };
  }
}
