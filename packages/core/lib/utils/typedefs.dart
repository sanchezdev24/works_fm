import 'package:core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

typedef ResultFuture<T> = TaskEither<Failure, T>;
typedef ResultVoid = TaskEither<Failure, Unit>;