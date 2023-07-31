import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../Domain/entities/user/user_entity.dart';
import '../../../Domain/usecases/user/sign_in_usecase.dart';
import '../../../Domain/usecases/user/sign_up_usecase.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final SignInUserUseCase signInUserUseCase;
  final SignUpUseCase signUpUseCase;
  CredentialCubit({required this.signInUserUseCase, required this.signUpUseCase}) : super(CredentialInitial());

  Future<void> signInUser({required String username, required String password}) async {
    emit(CredentialLoading());
    try {
      await signInUserUseCase.call(UserEntity(username: username, password: password));
      emit(CredentialSuccess());
    } on SocketException catch(_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void> signUpUser({required UserEntity user}) async {
    emit(CredentialLoading());
    try {
      await signUpUseCase.call(user);
      emit(CredentialSuccess());
    } on SocketException catch(_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }
}
