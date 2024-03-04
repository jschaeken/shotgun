import 'package:shotgun/features/auth/domain/entities/auth/user.dart';

class AuthStatus {
  final User? user;

  const AuthStatus({
    this.user,
  });
}

enum AuthStatusEnum {
  authenticated,
  unauthenticated,
  loading,
  initial,
  success,
  failure,
}
