import 'package:shotgun/domain/repositories/auth_repo.dart';

class AuthStatusCallImpl {
  final AuthRepository _authRepository;

  AuthStatusCallImpl(this._authRepository);

  Future<AuthStatus?> call() async {
    return _authRepository.getAuthStatus();
  }
}
