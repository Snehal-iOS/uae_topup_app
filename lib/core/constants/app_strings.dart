class AppStrings {
  static const String appName = 'TopUp UAE';

  static const String navHome = 'Home';
  static const String navManageBeneficiaries = 'Beneficiaries';
  static const String navProfile = 'Profile';
  static const String dashboard = 'Dashboard';

  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String delete = 'Delete';
  static const String retry = 'Retry';
  static const String loading = 'Loading your data...';
  static const String processingTopup = 'Processing top-up...';
  static const String somethingWentWrong = 'Something went wrong';

  static const String monthlyLimitUsed = 'Monthly Limit Used';
  static const String remainingLabel = 'Remaining: ';
  static const String used = 'AED {0} / {1}';
  static const String limitUsed = 'Limit used';

  static const String activeBeneficiaries = 'Active Beneficiaries';
  static const String inactiveBeneficiaries = 'Inactive Beneficiaries';
  static const String manageAllBeneficiaries = 'Manage All Beneficiaries';
  static const String addBeneficiary = 'Add Beneficiary';
  static const String noBeneficiariesYet = 'No beneficiaries yet';
  static const String addBeneficiaryHint = 'Add a beneficiary to start sending top-ups';
  static const String active = 'Active';
  static const String inactive = 'Inactive';
  static const String noActiveBeneficiaries = 'No active beneficiaries';
  static const String activeCountFormat = '({0}/{1})';
  static const String seeAll = 'See All';
  static const String allBeneficiaries = '(All Beneficiaries)';

  // Beneficiary Management
  static const String deleteBeneficiary = 'Delete Beneficiary';
  static const String deleteBeneficiaryConfirm = 'Are you sure you want to permanently delete {0}? This action cannot be undone.';
  static const String activateBeneficiary = 'Activate Beneficiary';
  static const String deactivateBeneficiary = 'Deactivate Beneficiary';
  static const String activate = 'Activate';
  static const String deactivate = 'Deactivate';
  static const String activateConfirm = 'Are you sure you want to activate {0}?';
  static const String deactivateConfirm = 'Are you sure you want to deactivate {0}?';

  static const String addNewBeneficiaryTitle = 'Add New Beneficiary';
  static const String nickname = 'Nickname';
  static const String nicknameHintPlaceholder = "e.g., Mom's Phone";
  static const String uaePhoneNumber = 'UAE Phone Number';
  static const String phonePlaceholder = '5X XXX XXXX';
  static const String phoneVerifyInfo = 'Ensure the number is active for successful top-ups.';
  static const String transactionLimitsTitle = 'TRANSACTION LIMITS';
  static const String transactionLimitsDescription = 'A max monthly top-up limit (AED 500 unverified / AED 1,000 verified) applies per beneficiary.';
  static const String saveBeneficiary = 'Save Beneficiary';
  static const String nicknameCounter = '{0}/{1}';

  static const String topUpTransactionTitle = 'Top-up Transaction';
  static const String selectAmount = 'Select Amount';
  static const String currencyAed = 'Currency: AED';
  static const String remainingForThisMonth = 'Remaining for this month';
  static const String confirmTopup = 'Confirm Top-up';
  static const String beneficiaryLabelShort = 'Beneficiary';
  static const String phoneNumberLabel = 'Phone Number';
  static const String topupAmountLabel = 'Top-up Amount';
  static const String serviceFee = 'Service Fee';
  static const String totalAed = 'Total Spent';
  static const String totalAmount = 'Total Amount';
  static const String topupSuccessful = 'Top-up successful! AED {0} sent to {1}';
  static const String topUpSuccessfulTitle = 'Top-up Successful!';
  static const String transactionCompletedSuccessfully = 'Transaction completed successfully';
  static const String amountToppedUp = 'Amount Topped Up';
  static const String serviceFeePaid = 'Service Fee Paid';
  static const String totalPaid = 'Total Paid';
  static const String monthlyLimitNotice = 'Monthly Limit Notice';
  static const String remainingLimitForBeneficiary = 'Your remaining limit for this beneficiary is now ';
  static const String backToDashboard = 'Back to Dashboard';
  static const String downloadReceipt = 'Download Receipt';
  static const String downloadReceiptComingSoon = 'Download receipt coming soon';
  static const String aed = 'AED';
  static const String aedFormat = 'AED {0}';
  static const String amountNotSelected = '--';

  static const String beneficiaryAddedSuccessfully = 'Beneficiary added successfully';
  static const String beneficiaryAddedInactive = 'Beneficiary added as inactive (5 active limit reached). Activate it from Manage Beneficiaries.';
  static const String beneficiaryRemoved = 'Beneficiary removed';
  static const String beneficiaryActivated = 'Beneficiary activated successfully';
  static const String beneficiaryDeactivated = 'Beneficiary deactivated successfully';
  static const String dataRefreshed = 'Data refreshed';
  static const String failedToLoadData = 'Failed to load data: {0}';
  static const String failedToRefresh = 'Failed to refresh: {0}';
  static const String failedToRemoveBeneficiary = 'Failed to remove beneficiary: {0}';

  // Validation Messages
  static const String pleaseEnterNickname = 'Please enter a nickname';
  static const String nicknameMaxLength = 'Nickname must be 20 characters or less';
  static const String pleaseEnterPhoneNumber = 'Please enter a phone number';
  static const String pleaseEnterValidUAENumber = 'Please enter a valid UAE phone number';

  static const String nicknameRequired = 'Nickname is required';
  static const String nicknameMaxLengthError = 'Nickname must be 20 characters or less';
  static const String invalidPhoneFormat = 'Invalid UAE phone number format';
  static const String duplicatePhoneNumber = 'Beneficiary with this phone number already exists';
  static const String topupAmountMustBePositive = 'Top-up amount must be positive';
  static const String beneficiaryNotFound = 'Beneficiary not found';
  static const String cannotActivateMaxReached = 'Cannot activate: Maximum 5 active beneficiaries allowed. Please deactivate another beneficiary first.';
  static const String networkError = 'Network error: Connection timeout';
  static const String unknownEndpoint = 'Unknown endpoint: {0}';
  static const String failedToPerformTopup = 'Failed to perform top-up: {0}';
  static const String insufficientBalanceFormat = 'Insufficient balance. Required: AED {0}, Available: AED {1}';
  static const String limitExceededFormat = '{0} limit exceeded. Limit: AED {1}, Current: AED {2}';

  // format strings with placeholders
  static String format(String template, List<Object> args) {
    String result = template;
    for (int i = 0; i < args.length; i++) {
      result = result.replaceAll('{$i}', args[i].toString());
    }
    return result;
  }
}
