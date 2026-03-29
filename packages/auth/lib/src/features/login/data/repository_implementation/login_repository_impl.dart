import 'package:auth/src/features/login/data/datasource/login_remote_datasource.dart';
import 'package:auth/src/features/login/domain/entitie/login_params.dart';
import 'package:auth/src/features/login/domain/repository_interface/login_repository.dart';
import 'package:core/core.dart';
import 'package:core/error/failures.dart';
import 'package:core/utils/typedefs.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDatasource remoteDatasource;
  LoginRepositoryImpl({required this.remoteDatasource});
  @override
  ResultFuture<bool> makeLogin(LoginParams params) => 
  TaskEither.tryCatch(
    () {
      return remoteDatasource.makeLogin(params);
    },
    (error, stackTrace) {
      return UnexpectedFailure(code: '', message: '');
    }
  );
}