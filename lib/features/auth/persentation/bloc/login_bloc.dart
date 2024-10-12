import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gss_manager_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:gss_manager_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:gss_manager_app/features/auth/persentation/bloc/login_event.dart';
import 'package:gss_manager_app/features/auth/persentation/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  LoginBloc({required this.loginUseCase, required this.logoutUseCase})
      : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<LogoutButtonPressed>(_onLogoutButtonPressed);
  }

  void _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    final result = await loginUseCase(event.email, event.password);
    emit(result.fold(
      (failure) => LoginFailure(error: failure.props.first.toString()),
      (success) => LoginSuccess(),
    ));
  }

  void _onLogoutButtonPressed(
      LogoutButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    await logoutUseCase();
    emit(LoginInitial());
  }
}
