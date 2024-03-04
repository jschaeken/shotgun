import 'package:dartz/dartz.dart';
import 'package:shotgun/features/auth/domain/entities/auth/auth_status.dart';
import 'package:shotgun/features/core/domain/entities/error/failure.dart';
import 'package:shotgun/features/auth/domain/repositories/auth_repo.dart';

class GetAuthStatus {
  final AuthRepository _authRepository;

  GetAuthStatus(this._authRepository);

  Future<Either<Failure, AuthStatus>> call() async {
    return await _authRepository.getAuthStatus();
  }
}
