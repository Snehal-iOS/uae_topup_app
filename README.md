# UAE Mobile Top-up App

A production-ready Flutter application for managing mobile phone top-up beneficiaries and transactions in the UAE. Built with Clean Architecture, comprehensive testing (116 tests), and modern Flutter best practices.

---

## 🌟 Key Highlights

- ✨ **Clean Architecture**: Separation of concerns with domain, data, and presentation layers
- 🧪 **116 Comprehensive Tests**: Unit tests, widget tests, and BLoC tests with 100% critical path coverage
- 🎯 **SOLID Principles**: Maintainable, testable, and scalable codebase
- 📱 **BLoC Pattern**: Robust state management with flutter_bloc
- 💾 **Offline First**: Local caching with automatic fallback
- 🔒 **Business Rules**: Comprehensive validation and limit enforcement
- 🚀 **Production Ready**: Error handling, logging, and user-friendly UI
- 📊 **Feature-Based Structure**: Organized by features (user, beneficiary, topup)

---

## Features

### 🎯 Core Functionality

| Feature | Description | Status |
|---------|-------------|--------|
| **User Management** | View balance, verification status, monthly limit tracking | ✅ Complete |
| **Beneficiary Management** | Add, remove, activate/deactivate beneficiaries (max 5 active) | ✅ Complete |
| **Top-up Operations** | 7 predefined amounts (AED 5-100) with AED 3 service charge | ✅ Complete |
| **Transaction History** | Local storage with monthly/beneficiary filtering | ✅ Complete |
| **Offline Support** | Data caching with SharedPreferences | ✅ Complete |
| **Form Validation** | UAE phone numbers, nickname length, duplicate checks | ✅ Complete |
| **Business Rules** | Monthly limits (per-beneficiary & total), balance validation | ✅ Complete |

### 📱 User Management
- ✅ Real-time balance display with currency formatting
- ✅ Verification status indicator (visual badge)
- ✅ Monthly top-up usage tracking (all beneficiaries combined)
- ✅ Progress indicators showing remaining monthly allowance
- ✅ Automatic monthly limit reset (1st of each month)

### 👥 Beneficiary Management
- ✅ Add up to 5 active beneficiaries simultaneously
- ✅ UAE phone number validation
  - Format 1: `+971XXXXXXXXX` (13 digits)
  - Format 2: `05XXXXXXXX` (10 digits)
- ✅ Nickname requirements (max 20 characters)
- ✅ Duplicate phone number prevention
- ✅ Remove beneficiaries with confirmation dialog
- ✅ Activate/deactivate beneficiaries (toggle status)
- ✅ Auto-inactive assignment when 5 active exist
- ✅ Per-beneficiary monthly limit tracking

### 💳 Top-up Operations
- ✅ **7 Predefined amounts**: AED 5, 10, 20, 30, 50, 75, 100
- ✅ **Service charge**: Fixed AED 3 per transaction
- ✅ **Real-time validation**:
  - Sufficient balance check
  - Beneficiary monthly limit (AED 500 unverified / AED 1,000 verified)
  - Total monthly limit (AED 3,000 across all beneficiaries)
- ✅ Confirmation dialog with transaction summary
- ✅ Success receipt with transaction details
- ✅ Failed transaction handling with clear error messages

### 🔒 Business Rules Enforcement

| Rule | Unverified Users | Verified Users |
|------|------------------|----------------|
| **Max Active Beneficiaries** | 5 | 5 |
| **Per-Beneficiary Monthly Limit** | AED 500 | AED 1,000 |
| **Total Monthly Limit (all beneficiaries)** | AED 3,000 | AED 3,000 |
| **Service Charge** | AED 3/transaction | AED 3/transaction |
| **Charge Counting** | Not counted toward limits | Not counted toward limits |

### 📊 Additional Features
- ✅ Pull-to-refresh for data sync
- ✅ Offline caching with automatic fallback
- ✅ Transaction history persistence
- ✅ Error handling with user-friendly messages
- ✅ Loading states for all async operations
- ✅ Responsive UI with Material Design 3

## Architecture

This app follows **Clean Architecture** and **SOLID** principles with a **feature-based structure**. Each feature contains its own domain, data, and presentation layers, ensuring separation of concerns and maintainability.

### Project Structure

```
lib/
├── core/                              # Shared utilities and components
│   ├── constants/                     # App-wide constants
│   │   ├── app_constants.dart         # Business rules, limits
│   │   ├── app_strings.dart           # UI text strings
│   │   ├── app_text_styles.dart       # Typography
│   │   ├── color_palette.dart         # Color schemes
│   │   └── shared_prefs_keys.dart     # Storage keys
│   ├── errors/
│   │   └── custom_exception.dart      # Custom exception classes
│   ├── theme/
│   │   ├── app_theme.dart             # Material theme configuration
│   │   └── theme_cubit.dart           # Theme state management
│   ├── utils/
│   │   ├── app_logger.dart            # Logging utility
│   │   ├── display_formatters.dart    # Currency, date formatting
│   │   ├── error_helper.dart          # Error message extraction
│   │   ├── progress_color.dart        # Progress bar colors
│   │   └── snackbar_helper.dart       # Snackbar utilities
│   └── widgets/                       # Reusable widgets
│       ├── app_bar_style.dart
│       ├── common_dialog.dart
│       └── common_icon_button.dart
│
├── data/                              # Shared data layer
│   └── datasources/
│       └── mock_http_client.dart      # Mock HTTP for development
│
├── features/                          # Feature modules
│   │
│   ├── user/                          # User feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── user_local_data_source.dart
│   │   │   └── repositories/
│   │   │       └── user_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── user_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_user_usecase.dart
│   │   │       └── update_user_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── user_bloc.dart
│   │       │   ├── user_event.dart
│   │       │   └── user_state.dart
│   │       ├── screens/
│   │       │   └── profile_screen.dart
│   │       └── widgets/
│   │           └── user_info_card.dart
│   │
│   ├── beneficiary/                   # Beneficiary feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── beneficiary_local_data_source.dart
│   │   │   └── repositories/
│   │   │       └── beneficiary_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── beneficiary.dart
│   │   │   ├── repositories/
│   │   │   │   └── beneficiary_repository.dart
│   │   │   └── usecases/
│   │   │       ├── add_beneficiary_usecase.dart
│   │   │       ├── delete_beneficiary_usecase.dart
│   │   │       ├── get_beneficiaries_usecase.dart
│   │   │       ├── toggle_beneficiary_status_usecase.dart
│   │   │       └── update_beneficiary_monthly_amount_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── beneficiary_bloc.dart
│   │       │   ├── beneficiary_event.dart
│   │       │   └── beneficiary_state.dart
│   │       ├── screens/
│   │       │   ├── add_beneficiary_screen.dart
│   │       │   └── manage_beneficiaries_screen.dart
│   │       └── widgets/
│   │           ├── beneficiary_avatar.dart
│   │           ├── beneficiary_card.dart
│   │           └── status_badge.dart
│   │
│   └── topup/                         # Top-up feature
│       ├── data/
│       │   ├── datasources/
│       │   │   └── topup_local_data_source.dart
│       │   └── repositories/
│       │       └── topup_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── topup_option.dart
│       │   │   └── topup_transaction.dart
│       │   ├── repositories/
│       │   │   └── topup_repository.dart
│       │   ├── usecases/
│       │   │   ├── check_topup_eligibility_usecase.dart
│       │   │   ├── get_transactions_usecase.dart
│       │   │   └── perform_topup_usecase.dart
│       │   └── topup_eligibility.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── topup_bloc.dart
│           │   ├── topup_event.dart
│           │   └── topup_state.dart
│           ├── screens/
│           │   ├── home_screen.dart
│           │   ├── topup_success_screen.dart
│           │   └── topup_transaction_screen.dart
│           └── widgets/
│               ├── empty_state_card.dart
│               └── label_value_row.dart
│
├── screens/
│   └── main_bottom_navigation_bar_screen.dart  # Main navigation
│
├── dependency_injection.dart          # Service locator setup (get_it)
└── main.dart                          # App entry point
```

### Test Structure

```
test/
├── core/
│   ├── errors/
│   │   └── custom_exception_test.dart
│   └── utils/
│       ├── display_formatters_test.dart
│       └── error_helper_test.dart
│
└── features/
    ├── user/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── user_local_data_source_test.dart
    │   │   └── repositories/
    │   │       └── user_repository_impl_test.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── user_test.dart
    │   │   └── usecases/
    │   │       ├── get_user_usecase_test.dart
    │   │       └── update_user_usecase_test.dart
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── user_bloc_test.dart
    │       │   └── user_event_test.dart
    │       └── widgets/
    │           └── user_info_card_test.dart
    │
    ├── beneficiary/
    │   ├── data/
    │   │   └── datasources/
    │   │       └── beneficiary_local_data_source_test.dart
    │   ├── domain/
    │   │   └── usecases/
    │   │       ├── add_beneficiary_usecase_test.dart
    │   │       ├── delete_beneficiary_usecase_test.dart
    │   │       ├── get_beneficiaries_usecase_test.dart
    │   │       └── toggle_beneficiary_status_usecase_test.dart
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── beneficiary_bloc_test.dart
    │       │   └── beneficiary_event_test.dart
    │       └── widgets/
    │           └── beneficiary_card_test.dart
    │
    └── topup/
        ├── data/
        │   └── datasources/
        │       └── topup_local_data_source_test.dart
        ├── domain/
        │   ├── entities/
        │   │   └── topup_option_test.dart
        │   └── usecases/
        │       ├── check_topup_eligibility_usecase_test.dart
        │       ├── get_transactions_usecase_test.dart
        │       └── perform_topup_usecase_test.dart
        └── presentation/
            └── bloc/
                ├── topup_bloc_test.dart
                └── topup_event_test.dart
```

### Key Design Patterns

- **🏗️ Clean Architecture**: Three-layer separation (Domain, Data, Presentation)
- **📦 Feature-Based Structure**: Each feature is self-contained with all layers
- **🔄 BLoC Pattern**: State management with flutter_bloc
- **🗂️ Repository Pattern**: Abstract data sources from business logic
- **💉 Dependency Injection**: Service locator pattern with get_it
- **🧩 SOLID Principles**:
  - Single Responsibility: Each class has one purpose
  - Open/Closed: Extensible without modification
  - Liskov Substitution: Interfaces over implementations
  - Interface Segregation: Focused repository interfaces
  - Dependency Inversion: Depend on abstractions (repositories, not implementations)

## Tech Stack

### Core
- **Flutter SDK**: 3.32.4 (Stable)
- **Dart SDK**: 3.8.1
- **Minimum SDK**: 3.8.1

### Dependencies
- **State Management**: flutter_bloc ^8.1.3
- **Dependency Injection**: get_it ^7.6.4
- **Local Storage**: shared_preferences ^2.2.2
- **HTTP Client**: http ^1.1.0
- **UI/Assets**:
  - flutter_svg ^2.0.9 (SVG support)
  - google_fonts ^5.1.0 (Custom fonts)
  - cached_network_image ^3.3.1 (Image caching)
- **Utilities**:
  - equatable ^2.0.5 (Value equality)
  - intl ^0.18.1 (Internationalization)
  - uuid ^4.2.1 (Unique IDs)

### Dev Dependencies
- **Testing**:
  - mockito ^5.4.4 (Mocking)
  - bloc_test ^9.1.5 (BLoC testing)
  - build_runner ^2.4.6 (Code generation)
- **Code Quality**: flutter_lints ^3.0.0

## Quick Start

### Prerequisites

- **Flutter SDK**: 3.32.4 or higher (tested on 3.32.4)
- **Dart SDK**: 3.8.1 or higher
- **IDE**: Android Studio, VS Code, or IntelliJ with Flutter/Dart plugins
- **Platform**: iOS Simulator, Android Emulator, or Physical Device

### Installation & Setup

**1. Clone the repository**
```bash
git clone <repository-url>
cd uae_topup_app
```

**2. Verify Flutter installation**
```bash
flutter doctor -v
```
Ensure all checks pass for your target platform (iOS/Android).

**3. Install dependencies**
```bash
flutter pub get
```

**4. Generate mock files for testing**
```bash
dart run build_runner build --delete-conflicting-outputs
```
This generates mock files needed for tests (*.mocks.dart files).

**5. Run tests to verify setup**
```bash
flutter test
```
You should see all 116 tests pass.

**6. Run the app**

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run on first available device
flutter run

# Run in release mode (better performance)
flutter run --release

# Run with specific Flutter path (if needed)
export PATH="$PATH:/path/to/flutter/bin"
flutter run
```

### Troubleshooting

**Issue: Build runner fails**
```bash
# Clean and rebuild
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

**Issue: Tests fail to run**
```bash
# Ensure mocks are generated
dart run build_runner build
# Then run tests
flutter test
```

**Issue: Flutter command not found**
```bash
# Add Flutter to PATH (macOS/Linux)
export PATH="$PATH:/Users/your-username/flutter/bin"

# Or add permanently to ~/.zshrc or ~/.bash_profile
echo 'export PATH="$PATH:/Users/your-username/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

## Running Tests

### Run all tests
```bash
flutter test
```

### Run tests with coverage
```bash
flutter test --coverage
```

### Run specific test file
```bash
flutter test test/features/topup/domain/usecases/perform_topup_usecase_test.dart
```

### View coverage report
```bash
# Install lcov (macOS)
brew install lcov

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html
```

## Project Structure

### Domain Layer

**Entities**
- `User`: User account with balance and verification status
- `Beneficiary`: Top-up recipient with monthly tracking
- `TopupTransaction`: Transaction records
- `TopupOption`: Available top-up amounts

**Use Cases**
- `GetUserUseCase`: Fetch and reset user monthly limits
- `GetBeneficiariesUseCase`: Fetch and reset beneficiary limits
- `AddBeneficiaryUseCase`: Add new beneficiary with validation
- `PerformTopupUseCase`: Execute top-up with all validations
- `GetTransactionsUseCase`: Retrieve transaction history with filtering

### Data Layer

**Data Sources**
- `MockHttpClient`: Simulates HTTP API with realistic delays and errors
- `LocalDataSource`: SharedPreferences caching for offline support and transaction history

**Repository Implementation**
- `TopupRepositoryImpl`: Implements repository with caching fallback

### Presentation Layer

**BLoC**
- `UserBloc`, `BeneficiaryBloc`, `TopupBloc`: State management per feature
- Events/states per bloc (e.g. LoadBeneficiaries, PerformTopup, success/error states)

**Screens**
- `HomeScreen`: Dashboard with user info, active beneficiaries, Add Beneficiary button
- `AddBeneficiaryScreen`: Full-screen form for adding beneficiaries
- `ManageBeneficiariesScreen`: Active/inactive beneficiaries with toggle and delete
- `TopUpTransactionScreen`: Amount selection, summary, confirm top-up
- Top-up success: Bottom sheet with receipt and “Back to Dashboard”
- `ProfileScreen`: User profile and theme toggle

**Widgets**
- `UserInfoCard`: User balance, verification, monthly limits and progress
- `BeneficiaryCard`: Beneficiary row with limit progress; switch/delete on Manage screen
- Add Beneficiary: Dashed-outline button opening AddBeneficiaryScreen

## Assumptions Made

1. **Monthly Reset Logic**
   - Monthly limits reset on the 1st day of each month
   - Reset happens automatically when data is fetched
   - Previous month's usage is cleared

2. **Phone Number Validation**
   - Accepts UAE format: +971XXXXXXXXX (13 digits total)
   - Also accepts: 05XXXXXXXX (10 digits total)
   - Other formats are rejected

3. **Mock Backend**
   - HTTP client simulates network delays (300-1000ms)
   - 5% chance of random network errors for testing
   - Data persists in local cache between sessions

4. **User Verification**
   - Verification status comes from backend (not editable in app)
   - Affects per-beneficiary monthly limits
   - Hardcoded in mock data (can be changed for testing)

5. **Transaction Charges & Limit Calculation**
   - Fixed AED 3 charge per transaction
   - Total cost = Top-up amount + AED 3 fee
   - Fee deducted from user balance but NOT counted toward monthly limits
   - Monthly limits apply only to the top-up amount sent to beneficiaries
   - Example: AED 50 top-up costs AED 53, but only AED 50 counts toward limits

6. **Data Persistence**
   - User and beneficiary data cached locally
   - Cache used as fallback when network fails
   - Transaction history stored locally for audit trail
   - Transactions tracked by month and beneficiary for limit enforcement

7. **Money Handling**
   - Amounts stored as double type representing AED
   - All predefined amounts are whole numbers (5, 10, 20, 30, 50, 75, 100)
   - Service charge is AED 3.00 (whole number)
   - This minimizes floating-point precision issues
   - For production with arbitrary amounts, recommend:
     * Using integer representation (fils: 1 AED = 100 fils)
     * Or using a Decimal/Money type library for financial precision

8. **UI/UX Decisions**
   - Pull-to-refresh for manual data reload
   - Expandable beneficiary cards to reduce clutter
   - Inline validation with helpful error messages
   - Confirmation dialogs for destructive actions

## Testing Strategy

The app includes **116 comprehensive tests** covering all critical functionality:

### Test Breakdown

**📊 Test Coverage Summary:**
- **Unit Tests**: 21 test files (~106 individual tests)
  - Core utilities (display formatters, error helpers)
  - Custom exceptions
  - Domain entities (User, TopupOption)
  - Use cases (9 files covering all business logic)
  - Data sources (local data caching)
  - Repositories (data layer implementation)
  - BLoC events (validation and equality)

- **Widget Tests**: 5 test files (~10 individual tests)
  - UserInfoCard widget
  - BeneficiaryCard widget
  - UserBloc widget tests
  - BeneficiaryBloc widget tests
  - TopupBloc widget tests

- **Integration Tests**: 0 files (can be added for E2E flows)

### Critical Test Scenarios Covered

**1. Top-up Use Case Tests** (`perform_topup_usecase_test.dart`)
- ✅ Successful top-up for verified users
- ✅ Validation: Zero amount rejection
- ✅ Validation: Negative amount rejection
- ✅ Insufficient balance detection
- ✅ Beneficiary monthly limit enforcement
- ✅ Total monthly limit enforcement
- ✅ Correct limit calculation for unverified users
- ✅ Balance deduction (amount + charge)
- ✅ Beneficiary monthly amount updates
- ✅ Latest data fetching from repositories

**2. Beneficiary Management Tests** (`add_beneficiary_usecase_test.dart`)
- ✅ Phone number validation (UAE formats)
- ✅ Nickname length validation (20 char limit)
- ✅ Duplicate phone number detection
- ✅ Maximum beneficiary limit (5 active)
- ✅ Auto-inactive when 5 already exist
- ✅ Toggle beneficiary status

**3. BLoC State Management Tests**
- ✅ All event handlers tested
- ✅ Success and error state transitions
- ✅ Loading states
- ✅ Error message propagation

**4. Data Layer Tests**
- ✅ Local caching functionality
- ✅ Cache retrieval and fallback
- ✅ Transaction history storage
- ✅ Monthly data filtering

### Understanding Test Output

When running tests, you may see error logs and stack traces - **this is expected behavior**! These are from tests that verify error handling works correctly:

```bash
❌ ERROR: Failed to perform top-up
   Error: Invalid amount
   Stack: [stack trace...]
```

This appears when testing error scenarios like `should throw ValidationException when amount is zero`. The test intentionally triggers an error to verify your app handles it properly.

**All 116 tests pass successfully** ✅

### Running Tests

```bash
# Run all tests
flutter test

# Run with verbose output
flutter test --verbose

# Run specific test suite
flutter test test/features/topup/domain/usecases/

# Generate coverage
flutter test --coverage
```

### Test Execution

All tests use:
- **Mockito** for mocking dependencies
- **bloc_test** for clean BLoC testing
- **flutter_test** for widget testing
- **build_runner** for generating mocks

Tests verify:
- ✅ Business logic validation
- ✅ Error handling and recovery
- ✅ State management correctness
- ✅ Edge cases and boundary conditions
- ✅ Data persistence and caching

## API Integration

The app uses a mock HTTP client that can easily be replaced with a real HTTP client:

### To integrate with real API:

1. Replace `MockHttpClient` in `lib/data/datasources/mock_http_client.dart` with actual HTTP implementation
2. Update endpoint URLs in `TopupRepositoryImpl`
3. Add authentication headers if required
4. Update error handling for specific API error codes

### Expected API Endpoints:

```
GET    /api/user                      # Get user details
PUT    /api/user                      # Update user
GET    /api/beneficiaries             # Get all beneficiaries
POST   /api/beneficiaries             # Add beneficiary
DELETE /api/beneficiaries/:id         # Remove beneficiary
POST   /api/topup                     # Perform top-up
```

## Performance Optimizations

1. **Efficient List Rendering**
   - Only active beneficiaries shown
   - Expandable cards reduce initial render

2. **Caching Strategy**
   - Local cache for offline support
   - Reduces API calls

3. **State Management**
   - BLoC prevents unnecessary rebuilds
   - Equatable for efficient state comparison

4. **Code Quality**
   - Linting rules enforced
   - Const constructors where possible
   - Immutable data models

## Error Handling

1. **Network Errors**
   - Fallback to cached data
   - User-friendly error messages
   - Retry mechanisms

2. **Validation Errors**
   - Inline form validation
   - Pre-transaction validation
   - Clear error descriptions

3. **Business Logic Errors**
   - Limit exceeded warnings
   - Insufficient balance alerts
   - Duplicate prevention

## Transaction History

The app now includes comprehensive transaction history tracking:

### Features
- All transactions automatically stored in local storage
- Query transactions by month (for limit calculation)
- Query transactions by beneficiary
- Calculate monthly totals for users and individual beneficiaries
- Persistent storage survives app restarts

### Usage
```dart
// Get all transactions
final transactions = await getTransactionsUseCase();

// Get transactions for current month
final monthlyTransactions = await getTransactionsUseCase.getByMonth(DateTime.now());

// Get transactions for specific beneficiary
final beneficiaryTransactions = await getTransactionsUseCase.getByBeneficiary('beneficiary_id');

// Calculate monthly total for beneficiary
final total = await getTransactionsUseCase.getMonthlyTotalForBeneficiary(
  beneficiaryId: 'id',
  month: DateTime.now(),
);
```

### Implementation Details
- Transactions stored in SharedPreferences as JSON
- Each transaction includes: id, beneficiaryId, amount, charge, timestamp, status
- Monthly limits calculated from transaction history
- History provides audit trail for compliance

## Future Enhancements

- [ ] Transaction history UI screen with filtering and sorting
- [ ] Export transactions to CSV/PDF
- [ ] Push notifications for successful top-ups
- [ ] Biometric authentication
- [ ] Multiple payment methods
- [ ] Scheduled top-ups
- [ ] Recurring top-ups
- [ ] Dark mode support
- [ ] Localization (Arabic support)
- [ ] Export transaction reports

## Screenshots

*Add screenshots here after running the app*

## Contributing

1. Fork the repository
2. Create a feature branch
3. Write tests for new features
4. Ensure all tests pass
5. Submit a pull request

## License

MIT License - See LICENSE file for details

## Contact

For questions or issues, please open an issue on GitHub.

---

**Built with ❤️ using Flutter**
