import 'package:auth/src/features/login/domain/entitie/login_params.dart';
import 'package:core/utils/typedefs.dart';

abstract class LoginRepository {
  ResultFuture<bool> makeLogin(LoginParams params);
}