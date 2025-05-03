part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmailSignInEvent extends AuthEvent {
  final String email;
  final String password;

  EmailSignInEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class EmailSignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;

  EmailSignUpEvent({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

class SignOutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}
