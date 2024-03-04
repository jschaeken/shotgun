import 'package:shotgun/features/auth/data/models/auth_status_model.dart';
import 'package:shotgun/features/auth/domain/entities/auth/user.dart';

abstract class AuthRemoteDataSource {
  /// Calls the authStatus endpoint in firebase

  Future<AuthStatusModel> getAuthStatus();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<AuthStatusModel> getAuthStatus() async {
    await Future.delayed(const Duration(seconds: 1));
    return AuthStatusModel(
      user: User(
        id: 'X',
        photoUrl: 'https://picsum.photos/200/300',
        name: 'Jacques TEST',
      ),
    );
  }
}
