import 'package:auth/src/features/login/domain/entitie/login_params.dart';
import 'package:auth/src/features/login/domain/repository_interface/login_repository.dart';
import 'package:core/usecase/usecase.dart';
import 'package:core/utils/typedefs.dart';

class MakeLoginUsecase extends UseCaseWithParams<bool, LoginParams> {

  final LoginRepository repository;
  MakeLoginUsecase({required this.repository});
  @override
  ResultFuture<bool> call(LoginParams params) => repository.makeLogin(params);
}