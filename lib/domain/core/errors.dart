
import 'package:flutter_ddd/domain/core/failure.dart';

class NotAuthenticatedError extends Error {}

class UnexpectedValueError extends Error{
  final ValueFailure valueFailure;

  UnexpectedValueError(this.valueFailure);

  @override
  String toString(){
    const explation = "Encountered a ValueFailure at an unrecoverable point. Terminating. ";
    return Error.safeToString('$explation Failure was: $valueFailure');
  }
}