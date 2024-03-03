import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shotgun/domain/models/auth/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      switch (event.runtimeType) {
        case GetAuthStatus:
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
        case LoginStarted:
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
        case CreateAccountStarted:
          emit(AuthLoading());
          break;
        case LogoutStarted:
          emit(AuthLoading());
          break;
        default:
          emit(AuthInitial());
      }
    });
  }
}
