
part of 'splash_bloc.dart';
abstract class SplashEvent extends Equatable {
  const SplashEvent();
  @override
  List<Object?> get props => [];
}

class SplashEventStarted extends SplashEvent{
  const SplashEventStarted();
}

class SplashEventGoLogin extends SplashEvent{
  const SplashEventGoLogin();
}