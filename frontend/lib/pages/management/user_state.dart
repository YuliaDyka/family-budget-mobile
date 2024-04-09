import '../../model/user.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  UserLoaded(this.user);
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}

class UserRegistrationInProgress extends UserState {}

class UserRegistrationSuccess extends UserState {
  final String userName;
  UserRegistrationSuccess(this.userName);
}

class UserRegistrationFailure extends UserState {
  final String error;

  UserRegistrationFailure(this.error);
}

class LoginInProgress extends UserState {}

class LoginSuccess extends UserState {
  final String userName;
  LoginSuccess(this.userName);
}

class LoginFailure extends UserState {
  final String error;

  LoginFailure(this.error);
}

class EditUserInProgressState extends UserState {}

class EditUserSuccessState extends UserState {}

class EditUserFailedState extends UserState {
  final String error;
  EditUserFailedState(this.error);
}
