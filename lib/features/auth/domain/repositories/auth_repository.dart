import 'package:dartz/dartz.dart';
import 'package:gss_manager_app/core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> login(String email, String password);

  Future<void> logout();
}
