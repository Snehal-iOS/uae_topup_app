import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uae_topup_app/features/beneficiary/data/datasources/beneficiary_local_data_source.dart';
import 'package:uae_topup_app/features/beneficiary/domain/entities/beneficiary.dart';

void main() {
  late BeneficiaryLocalDataSource dataSource;
  late SharedPreferences sharedPreferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    dataSource = BeneficiaryLocalDataSource(sharedPreferences);
  });

  group('BeneficiaryLocalDataSource', () {
    final tBeneficiaries = [
      Beneficiary(
        id: '1',
        phoneNumber: '+971501234567',
        nickname: 'Test Beneficiary 1',
        monthlyTopupAmount: 100.0,
        monthlyResetDate: DateTime(2025, 2, 1),
        isActive: true,
      ),
      Beneficiary(
        id: '2',
        phoneNumber: '+971501234568',
        nickname: 'Test Beneficiary 2',
        monthlyTopupAmount: 200.0,
        monthlyResetDate: DateTime(2025, 2, 1),
        isActive: false,
      ),
    ];

    test('should cache beneficiaries successfully', () async {
      // Act
      await dataSource.cacheBeneficiaries(tBeneficiaries);

      // Assert
      final cachedJson = sharedPreferences.getString('CACHED_BENEFICIARIES');
      expect(cachedJson, isNotNull);
      final List<dynamic> jsonList = jsonDecode(cachedJson!) as List;
      final cachedBeneficiaries = jsonList.map((json) => Beneficiary.fromJson(json as Map<String, dynamic>)).toList();
      expect(cachedBeneficiaries, equals(tBeneficiaries));
    });

    test('should return cached beneficiaries when available', () async {
      // Arrange
      await dataSource.cacheBeneficiaries(tBeneficiaries);

      // Act
      final result = dataSource.getCachedBeneficiaries();

      // Assert
      expect(result, isNotNull);
      expect(result, equals(tBeneficiaries));
    });

    test('should return null when no cached beneficiaries exist', () {
      // Act
      final result = dataSource.getCachedBeneficiaries();

      // Assert
      expect(result, isNull);
    });

    test('should clear cache successfully', () async {
      // Arrange
      await dataSource.cacheBeneficiaries(tBeneficiaries);
      expect(dataSource.getCachedBeneficiaries(), isNotNull);

      // Act
      await dataSource.clearCache();

      // Assert
      expect(dataSource.getCachedBeneficiaries(), isNull);
    });

    test('should update cached beneficiaries when caching again', () async {
      // Arrange
      await dataSource.cacheBeneficiaries(tBeneficiaries);
      final updatedBeneficiaries = [tBeneficiaries[0].copyWith(monthlyTopupAmount: 150.0), tBeneficiaries[1]];

      // Act
      await dataSource.cacheBeneficiaries(updatedBeneficiaries);

      // Assert
      final result = dataSource.getCachedBeneficiaries();
      expect(result?[0].monthlyTopupAmount, equals(150.0));
    });

    test('should handle empty list', () async {
      // Act
      await dataSource.cacheBeneficiaries([]);

      // Assert
      final result = dataSource.getCachedBeneficiaries();
      expect(result, isEmpty);
    });
  });
}
