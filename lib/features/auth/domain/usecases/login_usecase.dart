import 'package:dartz/dartz.dart';
import 'package:gss_manager_app/core/error/failures.dart';
import 'package:gss_manager_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, void>> call(String email, String password) {
    return repository.login(email, password);
  }
}
