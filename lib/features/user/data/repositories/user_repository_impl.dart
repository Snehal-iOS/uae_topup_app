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
    // Always load from cache first to preserve balance and monthlyTopupTotal
    final cachedUser = localDataSource.getCachedUser();
    if (cachedUser != null) {
      return cachedUser; // Return cached user to preserve balance and monthlyTopupTotal across app restarts

    }

    // Only fetch from API if no cached user exists (first time app launch)
    try {
      final response = await httpClient.get('/api/user');
      final user = User.fromJson(response);
      await localDataSource.cacheUser(user);
      return user;
    } catch (e) {
      rethrow; // If API fails and no cache, and rethrow the error
    }
  }

  @override
  Future<User> updateUser(User user) async {
    // Always cache the user to persist balance and monthlyTopupTotal
    await localDataSource.cacheUser(user);

    try {
      final response = await httpClient.put('/api/user', user.toJson());
      final updatedUser = User.fromJson(response);
      // Cache the response as well (though it should be the same)
      await localDataSource.cacheUser(updatedUser);
      return updatedUser;
    } catch (e) {
      return user; // Cache already updated above, return the user
    }
  }
}
