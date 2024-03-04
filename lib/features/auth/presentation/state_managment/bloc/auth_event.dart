part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class GetAuthStatusEvent extends AuthEvent {}

final class LoginStartedEvent extends AuthEvent {
  final String email;
  final String password;

  LoginStartedEvent(this.email, this.password);
}

final class CreateAccountStartedEvent extends AuthEvent {
  final String email;
  final String password;

  CreateAccountStartedEvent(this.email, this.password);
}

final class LogoutStartedEvent extends AuthEvent {}
