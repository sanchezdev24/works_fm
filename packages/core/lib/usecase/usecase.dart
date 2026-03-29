import 'package:core/utils/typedefs.dart';

abstract class UseCaseWithParams<T, Params> {
  const UseCaseWithParams();
  ResultFuture<T> call(Params params);
}

abstract class UseCaseWithoutParams<T> {
  const UseCaseWithoutParams();
  ResultFuture<T> call();
}

abstract class UseCaseVoidWithParams<T, Params> {
  const UseCaseVoidWithParams();
  ResultVoid call(Params params);
}