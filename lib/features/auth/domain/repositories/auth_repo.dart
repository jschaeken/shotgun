import 'package:dartz/dartz.dart';
import 'package:shotgun/features/auth/domain/entities/auth/auth_status.dart';
import 'package:shotgun/features/core/domain/entities/error/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthStatus>> getAuthStatus();
  Future<Either<Failure, AuthStatus>> login(String email, String password);
  Future<Either<Failure, AuthStatus>> createAccount(
      String email, String password);
  Future<Either<Failure, AuthStatus>> logout();
}
