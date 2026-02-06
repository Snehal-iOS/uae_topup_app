import 'dart:math';
import '../../core/errors/custom_exception.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/app_logger.dart';

/// Mock HTTP client for development. Response shapes match domain entity
/// fromJson expectations (User, Beneficiary, TopupTransaction).
class MockHttpClient {
  final Random _random = Random();

  // Simulate network delay
  Future<void> _simulateDelay() async {
    final delayMs = AppConstants.minNetworkDelayMs + 
        _random.nextInt(AppConstants.maxNetworkDelayMs - AppConstants.minNetworkDelayMs);
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  // Simulate occasional network errors
  void _simulateNetworkError() {
    if (_random.nextInt(AppConstants.networkErrorProbability) == 0) {
      AppLogger.warning('Simulated network error occurred');
      throw const NetworkException(AppStrings.networkError);
    }
  }

  Future<Map<String, dynamic>> get(String url) async {
    await _simulateDelay();
    _simulateNetworkError();
    
    // Return mock response based on endpoint
    if (url.contains('/user')) {
      return {
        'id': 'user_001',
        'name': 'John Doe',
        'balance': 1500.0,
        'isVerified': true,
        'monthlyTopupTotal': 0.0, // Start at 0, updated only after successful top-ups
        'monthlyResetDate': DateTime(
          DateTime.now().year,
          DateTime.now().month + 1,
          1,
        ).toIso8601String(),
      };
    } else if (url.contains('/beneficiaries')) {
      return {
        'data': [],
      };
    }
    
    throw NetworkException(
      AppStrings.format(AppStrings.unknownEndpoint, [url]),
    );
  }

  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    await _simulateDelay();
    _simulateNetworkError();
    
    if (url.contains('/beneficiaries')) {
      return body;
    } else if (url.contains('/topup')) {
      return {
        'id': 'tx_${DateTime.now().millisecondsSinceEpoch}',
        'beneficiaryId': body['beneficiaryId'],
        'amount': body['amount'],
        'charge': AppConstants.topupServiceCharge,
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'success',
      };
    }
    
    throw NetworkException(
      AppStrings.format(AppStrings.unknownEndpoint, [url]),
    );
  }

  Future<Map<String, dynamic>> put(
    String url,
    Map<String, dynamic> body,
  ) async {
    await _simulateDelay();
    _simulateNetworkError();
    
    return body;
  }

  Future<void> delete(String url) async {
    await _simulateDelay();
    _simulateNetworkError();
  }
}
