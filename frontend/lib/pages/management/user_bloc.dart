import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab1/pages/management/user_event.dart';
import 'package:lab1/pages/management/user_state.dart';

import '../../model/user.dart';
import '../../service/logic_service.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final LogicService _Service;

  UserBloc(this._Service) : super(UserInitial()) {
    on<LoadUser>((event, emit) async {
      emit(UserLoading());
      try {
        final User? user = await _Service.getUser();
        if (user != null) {
          emit(UserLoaded(user));
        } else {
          emit(UserError('User not found'));
        }
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(UserRegistrationInProgress());
      try {
        final result = await _Service.register(
          event.name,
          event.email,
          event.password,
          event.confirmPassword,
        );
        if (result == null) {
          final user = await _Service.getUser();
          final userName = user?.name ?? '';
          emit(UserRegistrationSuccess(userName));
        } else {
          emit(UserRegistrationFailure(result));
        }
      } catch (e) {
        emit(UserRegistrationFailure(e.toString()));
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(LoginInProgress());
      try {
        final hasInternetConnection = await _Service.checkInternetConnection();
        final success = hasInternetConnection
            ? await _Service.login(event.email, event.password)
            : await _Service.loginOffline(event.email, event.password);
        if (success) {
          final user = await _Service.getUser();
          final userName = user?.name ?? '';
          final result = hasInternetConnection ? userName : '$userName (Offline)';
          emit(LoginSuccess(result));
        } else {
          emit(LoginFailure('Invalid email or password'));
        }
      } catch (e) {
        emit(LoginFailure('Login failed: ${e.toString()}'));
      }
    });

    on<EditUserEvent>((event, emit) async {
      emit(EditUserInProgressState());
      try {
        final userID = await _Service.getUserId(event.user.email) as int;
        final result = await _Service.updateUserData(userID, event.user.name, event.user.email, event.user.password);
        if (result) {
          final user = await _Service.getUser();
          final userName = user?.name ?? '';
          emit(EditUserSuccessState());
          _Service.storeUpdatedUser(event.user);
        } else {
          emit(EditUserFailedState('Edit user data failed!!!'));
        }
      } catch (e) {
        emit(EditUserFailedState(e.toString()));
      }
    });

    // on<Logout>((event, emit) async {
    //   await _Service.logout();
    //   emit(UserInitial());
    // });
  }
}
