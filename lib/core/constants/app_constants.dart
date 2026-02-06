/// This file contains all constant including numbers and business rules:
class AppConstants {
  AppConstants._();

  static const int maxActiveBeneficiaries = 5; // Max no. of active beneficiaries
  static const int maxNicknameLength = 20; // Validation Limits

  // UAE Phone Validation
  static const int uaePhoneLengthWithCountryCode = 13; // Total length
  static const int uaePhoneLengthWithLeadingZero = 10; // Total length ex country code with "0"
  static const int uaePhoneDigitsCount = 9; // Total length ex country code and "0"
  static const String uaeMobileFirstDigit = '5'; // UAE standards

  // Monthly Limits in AED
  static const double monthlyLimitVerified = 1000.0; // Monthly limit for Verified users in AED per-beneficiary
  static const double monthlyLimitUnverified = 500.0; // Monthly limit for Unverified users in AED per-beneficiary
  static const double totalMonthlyLimit = 3000.0; // Total monthly topup limit for all the beneficiaries
  static const double topupServiceCharge = 3.0; // Fixed service charge per top-up transaction in AED

  static const List<double> topupPresetAmounts = [ // Predefined top-up amount options in AED
    5.0,
    10.0,
    20.0,
    30.0,
    50.0,
    75.0,
    100.0,
  ];

  // Progress Bar Color Thresholds ratio from 0.0 to 1.0
  static const double progressGreenThreshold = 0.5; // less than or equal to 50%
  static const double progressAmberThreshold = 0.8; // less than or equal to 80%

  // Network Configuration (for mock client)
  static const int minNetworkDelayMs = 300;
  static const int maxNetworkDelayMs = 1000;
  static const int networkErrorProbability = 100; // Network error probability ~1%
}
