
import 'package:auth/src/features/login/domain/entitie/login_params.dart';
import 'package:auth/src/features/login/domain/usecase/make_login_usecase.dart';
import 'package:core/core.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>{
  LoginBloc({required this.makeLoginUsecase}): super( LoginStateInitial()) {
    on<LoginEventOnLogin>(_onMakeLogin);
  }
  final MakeLoginUsecase makeLoginUsecase;

  Future<void> _onMakeLogin(LoginEventOnLogin event, Emitter<LoginState> emit) async {

    emit(LoginStateIsLoading());

    print("_onMakeLogin");
    final login = await makeLoginUsecase(LoginParams(email: event.email, pwd: event.pwd)).run();
    login.match(
      (failure) => emit(LoginStateIsError(failure.message!)), 
      (result) => emit(LoginStateIsSuccess())
    );

  }
}