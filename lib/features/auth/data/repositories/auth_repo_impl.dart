import 'package:dartz/dartz.dart';
import 'package:shotgun/features/auth/data/datasources/remote_datasource.dart';
import 'package:shotgun/features/auth/data/models/auth_status_model.dart';
import 'package:shotgun/features/auth/domain/entities/auth/auth_status.dart';
import 'package:shotgun/features/core/domain/entities/error/failure.dart';
import 'package:shotgun/features/auth/domain/repositories/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthStatus>> getAuthStatus() async {
    try {
      final AuthStatusModel model = await remoteDataSource.getAuthStatus();
      return Right(model);
    } on Exception {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, AuthStatus>> createAccount(
      String email, String password) {
    // TODO: implement createAccount
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, AuthStatus>> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, AuthStatus>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
