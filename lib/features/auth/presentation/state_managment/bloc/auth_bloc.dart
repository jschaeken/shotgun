import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shotgun/features/auth/domain/entities/auth/user.dart';
import 'package:shotgun/features/auth/domain/repositories/auth_repo.dart';
import 'package:shotgun/features/core/domain/entities/error/failure.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      switch (event.runtimeType) {
        case const (GetAuthStatusEvent):
          // Set the state to AuthLoading
          emit(AuthLoading());
          // Get the auth status from the repository
          final result = await authRepository.getAuthStatus();
          // If the result is a failure, emit AuthFailure, else emit AuthSuccess with the user
          result.fold(
            (failure) => emit(AuthFailure(failure)),
            (authStatus) => emit(AuthSuccess(authStatus.user!)),
          );
          break;
        case const (LoginStartedEvent):
          emit(AuthLoading());
          await Future.delayed(const Duration(seconds: 3));
          emit(
            AuthSuccess(
              User(
                id: 'X',
                photoUrl: 'https://picsum.photos/200/300',
                name: 'Jacques',
              ),
            ),
          );
          break;
        case const (CreateAccountStartedEvent):
          emit(AuthLoading());
          break;
        case const (LogoutStartedEvent):
          emit(AuthLoading());
          break;
        default:
          emit(AuthInitial());
      }
    });
  }
}
