import 'package:shotgun/features/auth/domain/entities/auth/auth_status.dart';
import 'package:shotgun/features/auth/domain/entities/auth/user.dart';

class AuthStatusModel extends AuthStatus {
  AuthStatusModel({
    required super.user,
  });
}

AuthStatusModel authStatusModelFromJson(Map<String, dynamic> json) {
  return AuthStatusModel(
    user: User(
      id: json['id'] as String,
      photoUrl: json['photoUrl'] as String,
      name: json['name'] as String,
    ),
  );
}
