import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uae_topup_app/features/user/data/datasources/user_local_data_source.dart';
import 'package:uae_topup_app/features/user/domain/entities/user.dart';

void main() {
  late UserLocalDataSource dataSource;
  late SharedPreferences sharedPreferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    dataSource = UserLocalDataSource(sharedPreferences);
  });

  group('UserLocalDataSource', () {
    final tUser = User(
      id: '1',
      name: 'Test User',
      balance: 1000.0,
      isVerified: true,
      monthlyTopupTotal: 0.0,
      monthlyResetDate: DateTime(2025, 2, 1),
    );

    test('should cache user successfully', () async {
      // Act
      await dataSource.cacheUser(tUser);

      // Assert
      final cachedJson = sharedPreferences.getString('CACHED_USER');
      expect(cachedJson, isNotNull);
      final cachedUser = User.fromJson(jsonDecode(cachedJson!) as Map<String, dynamic>);
      expect(cachedUser, equals(tUser));
    });

    test('should return cached user when available', () async {
      // Arrange
      await dataSource.cacheUser(tUser);

      // Act
      final result = dataSource.getCachedUser();

      // Assert
      expect(result, isNotNull);
      expect(result, equals(tUser));
    });

    test('should return null when no cached user exists', () {
      // Act
      final result = dataSource.getCachedUser();

      // Assert
      expect(result, isNull);
    });

    test('should clear cache successfully', () async {
      // Arrange
      await dataSource.cacheUser(tUser);
      expect(dataSource.getCachedUser(), isNotNull);

      // Act
      await dataSource.clearCache();

      // Assert
      expect(dataSource.getCachedUser(), isNull);
    });

    test('should update cached user when caching again', () async {
      // Arrange
      await dataSource.cacheUser(tUser);
      final updatedUser = tUser.copyWith(balance: 1500.0);

      // Act
      await dataSource.cacheUser(updatedUser);

      // Assert
      final result = dataSource.getCachedUser();
      expect(result?.balance, equals(1500.0));
    });
  });
}
