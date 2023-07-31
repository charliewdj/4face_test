

import '../../repository/repository.dart';

class SignOutUseCase {
  final Repository repository;

  SignOutUseCase({required this.repository});

  Future<void> call() {
    return repository.signOut();
  }
}