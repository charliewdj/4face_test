import '../../../Domain/entities/user/user_entity.dart';
import '../../../Domain/repository/repository.dart';
import '../../remote_data_source/remote_data_source.dart';

class RepositoryImpl implements Repository{

  final RemoteDataSource remoteDataSource;

  RepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> signInUser(UserEntity user) async => remoteDataSource.signInUser(user);

  @override
  Future<void> signOut() async => remoteDataSource.signOut();

  @override
  Future<void> signUpUser(UserEntity user) async => remoteDataSource.signUpUser(user);

  @override
  Future<void> createUser(UserEntity user) async => remoteDataSource.createUser(user);

  @override
  Future<String> getCurrentUid() async => remoteDataSource.getCurrentUid();
}