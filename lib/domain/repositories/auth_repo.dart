import 'package:shotgun/domain/models/auth/user.dart';

class AuthStatus {
  final bool isAuthenticated;
  final User user;

  AuthStatus({required this.isAuthenticated, required this.user});
}

abstract class AuthRepository {
  Future<AuthStatus?> getAuthStatus();
  Future<AuthStatus?> login(String email, String password);
  Future<AuthStatus?> createAccount(String email, String password);
  Future<AuthStatus?> logout();
}

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<AuthStatus?> createAccount(String email, String password) {
    // TODO: implement createAccount
    throw UnimplementedError();
  }

  @override
  Future<AuthStatus?> getAuthStatus() {
    // TODO: implement getAuthStatus
    throw UnimplementedError();
  }

  @override
  Future<AuthStatus?> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<AuthStatus?> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
