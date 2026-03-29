import 'package:auth/src/composition/network/network_routes.dart';
import 'package:auth/src/features/login/domain/entitie/login_params.dart';
import 'package:core/core.dart';
import 'package:core/error/failures.dart';

abstract class LoginRemoteDatasource {
  Future<bool> makeLogin(LoginParams params);
}

class MockLoginRemoteDatasource implements LoginRemoteDatasource {
  @override
  Future<bool> makeLogin(LoginParams params) async {
    await Future.delayed(Duration(seconds: 5));
    // throw UnexpectedFailure(code: '');
    return true;
  }
  
}

class LoginRemoteDatasourceImpl implements LoginRemoteDatasource {
  final Dio dio;
  LoginRemoteDatasourceImpl({required this.dio});
  @override
  Future<bool> makeLogin(LoginParams params) async {
    final response = await dio.post(NetworkRoutes.login, data: params);
    if(response.statusCode == 200) {
      return true;
    }
    throw UnexpectedFailure(code: response.statusCode.toString());
  }
  
}