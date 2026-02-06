class AppConstants {
  AppConstants._();

  static const int maxActiveBeneficiaries = 5;
  static const int maxNicknameLength = 20;

  static const int uaePhoneLengthWithCountryCode = 13;
  static const int uaePhoneLengthWithLeadingZero = 10;
  static const int uaePhoneDigitsCount = 9;
  static const String uaeMobileFirstDigit = '5'; // UAE standards

  // Monthly Limits
  static const double monthlyLimitVerified = 1000.0; // for Verified users
  static const double monthlyLimitUnverified = 500.0; // for Unverified users
  static const double totalMonthlyLimit = 3000.0; // overall monthly topup limit
  static const double topupServiceCharge = 3.0; // fixed service charge per transaction

  static const List<double> topupPresetAmounts = [
    5.0,
    10.0,
    20.0,
    30.0,
    50.0,
    75.0,
    100.0,
  ];

  static const double progressGreenThreshold = 0.5; // less than or equal to 50%
  static const double progressAmberThreshold = 0.8; // less than or equal to 80%

  static const int minNetworkDelayMs = 300;
  static const int maxNetworkDelayMs = 1000;
  static const int networkErrorProbability = 100;
}
