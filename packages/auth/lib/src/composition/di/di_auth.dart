import 'package:auth/src/features/login/data/datasource/login_remote_datasource.dart';
import 'package:auth/src/features/login/data/repository_implementation/login_repository_impl.dart';
import 'package:auth/src/features/login/domain/repository_interface/login_repository.dart';
import 'package:auth/src/features/login/domain/usecase/make_login_usecase.dart';
import 'package:auth/src/features/login/presentation/bloc/login_bloc.dart';
import 'package:core/core.dart';

void registerAuthModules(GetIt it) {
  //it.registerFactory<LoginRemoteDatasource>(() => LoginRemoteDatasourceImpl(dio: it<Dio>()));
  it.registerFactory<LoginRemoteDatasource>(() => MockLoginRemoteDatasource());
  it.registerFactory<LoginRepository>(() => LoginRepositoryImpl(remoteDatasource: it<LoginRemoteDatasource>()));
  it.registerFactory<MakeLoginUsecase>(() => MakeLoginUsecase(repository: it<LoginRepository>()));
  it.registerFactory<LoginBloc>(() => LoginBloc(makeLoginUsecase: it<MakeLoginUsecase>()));
}