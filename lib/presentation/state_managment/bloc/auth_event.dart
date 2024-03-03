part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class GetAuthStatus extends AuthEvent {}

final class LoginStarted extends AuthEvent {
  final String email;
  final String password;

  LoginStarted(this.email, this.password);
}

final class CreateAccountStarted extends AuthEvent {
  final String email;
  final String password;

  CreateAccountStarted(this.email, this.password);
}

final class LogoutStarted extends AuthEvent {}
