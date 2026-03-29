import 'package:core/core.dart';
import 'package:dio/dio.dart';

void registerCore(GetIt it, {required String baseUrl}) {
  it.registerLazySingleton<Dio>(
    () {
      final dio = Dio(
        BaseOptions(baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }
        )
      );
      return dio;
    },
  );
}