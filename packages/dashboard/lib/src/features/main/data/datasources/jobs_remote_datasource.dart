

import 'package:core/core.dart';
import 'package:core/error/exceptions.dart';
import 'package:dashboard/src/composition/network/network_routes.dart';
import 'package:dashboard/src/features/main/data/models/job_model.dart';

abstract class JobsRemoteDataSource {
  Future<List<JobModel>> getJobs({
    String? search,
    String? jobType,
    String? experienceLevel,
    int page = 1,
    int limit = 20,
  });
}

class JobsRemoteDataSourceImpl implements JobsRemoteDataSource {
  final Dio dio;

  const JobsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<JobModel>> getJobs({
    String? search,
    String? jobType,
    String? experienceLevel,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await dio.get(
        NetworkRoutes.jobs,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (search != null && search.isNotEmpty) 'search': search,
          if (jobType != null && jobType.isNotEmpty) 'jobType': jobType,
          if (experienceLevel != null && experienceLevel.isNotEmpty)
            'experienceLevel': experienceLevel,
        },
      );

      // Estructura real: { success: true, data: { data: [...], total, page, ... } }
      final body = response.data as Map<String, dynamic>;
      final outer = body['data'] as Map<String, dynamic>;
      final jobs = outer['data'] as List<dynamic>;

      return jobs
          .map((json) => JobModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException(
            message: 'No se pudo conectar al servidor. Verifica tu internet.');
      }
      throw ServerException(
        message: e.message ?? 'Error de servidor',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}

class MockJobsRemoteDataSourceImpl implements JobsRemoteDataSource {
  @override
  Future<List<JobModel>> getJobs({
    String? search,
    String? jobType,
    String? experienceLevel,
    int page = 1,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      const JobModel(
        id: '2beff0b7-4055-44c5-be78-de7208ba91fb',
        applyUrl: 'https://softlayermx.com/careers',
        title: 'Ionic Angular Developer',
        company: 'Softlayer MX',
        companyLogo: '',
        experienceLevel: 'mid',
        jobType: 'contract',
        publishedAt: '2026-03-01T01:18:05.012Z',
        location: 'Guadalajara, MX',
        salary: 'MXN 45,000 - 70,000',
        description: 'We are looking for a talented Ionic Angular Developer.',
        tags: ['ionic', 'angular', 'typescript', 'capacitor'],
      ),
    ];
  }
}
