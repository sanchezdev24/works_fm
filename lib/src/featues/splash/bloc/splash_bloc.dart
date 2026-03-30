
import 'package:core/core.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState>{
  SplashBloc(): super( SplashStateInitial()) {
    on<SplashEventGoLogin>(_onGoLogin);
  }

  Future<void> _onGoLogin(SplashEventGoLogin event, Emitter<SplashState> emit) async {
    await Future.delayed(Duration(seconds: 2));
    emit(SplashStateIsGoLogin());
  }
}