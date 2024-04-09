import 'package:lab1/model/user.dart';

abstract class UserEvent {}

class LoadUser extends UserEvent {}

class LoginRequested extends UserEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class SignUpRequested extends UserEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  SignUpRequested(this.name, this.email, this.password, this.confirmPassword);
}

class Logout extends UserEvent {}

class EditUserEvent extends UserEvent {
  final User user;

  EditUserEvent(this.user);

  List<Object> get props => [user];

}