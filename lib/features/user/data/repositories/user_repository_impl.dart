import '../../../../data/datasources/mock_http_client.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final MockHttpClient httpClient;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.httpClient,
    required this.localDataSource,
  });

  @override
  Future<User> getUser() async {
    final cachedUser = localDataSource.getCachedUser();
    if (cachedUser != null) {
      return cachedUser;
    }

    try {
      final response = await httpClient.get('/api/user');
      final user = User.fromJson(response);
      await localDataSource.cacheUser(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> updateUser(User user) async {
    await localDataSource.cacheUser(user);

    try {
      final response = await httpClient.put('/api/user', user.toJson());
      final updatedUser = User.fromJson(response);
      await localDataSource.cacheUser(updatedUser);
      return updatedUser;
    } catch (e) {
      return user;
    }
  }
}
