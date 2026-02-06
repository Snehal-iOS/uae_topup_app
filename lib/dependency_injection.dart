import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core/Shared
import 'data/datasources/mock_http_client.dart';

// User Feature
import 'features/user/data/datasources/user_local_data_source.dart';
import 'features/user/data/repositories/user_repository_impl.dart';
import 'features/user/domain/repositories/user_repository.dart';
import 'features/user/domain/usecases/get_user_usecase.dart';
import 'features/user/domain/usecases/update_user_usecase.dart';
import 'features/user/presentation/bloc/user_bloc.dart';

// Beneficiary Feature
import 'features/beneficiary/data/datasources/beneficiary_local_data_source.dart';
import 'features/beneficiary/data/repositories/beneficiary_repository_impl.dart';
import 'features/beneficiary/domain/repositories/beneficiary_repository.dart';
import 'features/beneficiary/domain/usecases/add_beneficiary_usecase.dart';
import 'features/beneficiary/domain/usecases/delete_beneficiary_usecase.dart';
import 'features/beneficiary/domain/usecases/get_beneficiaries_usecase.dart';
import 'features/beneficiary/domain/usecases/toggle_beneficiary_status_usecase.dart';
import 'features/beneficiary/domain/usecases/update_beneficiary_monthly_amount_usecase.dart';
import 'features/beneficiary/presentation/bloc/beneficiary_bloc.dart';

// Topup Feature
import 'features/topup/data/datasources/topup_local_data_source.dart';
import 'features/topup/data/repositories/topup_repository_impl.dart';
import 'features/topup/domain/repositories/topup_repository.dart';
import 'features/topup/domain/usecases/check_topup_eligibility_usecase.dart';
import 'features/topup/domain/usecases/get_transactions_usecase.dart';
import 'features/topup/domain/usecases/perform_topup_usecase.dart';
import 'features/topup/presentation/bloc/topup_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  getIt.registerLazySingleton<MockHttpClient>(() => MockHttpClient());

  getIt.registerLazySingleton<UserLocalDataSource>(
        () => UserLocalDataSource(getIt()),
  );

  getIt.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(
      httpClient: getIt(),
      localDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => GetUserUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateUserUseCase(getIt()));

  getIt.registerFactory(
        () => UserBloc(
      getUserUseCase: getIt(),
      updateUserUseCase: getIt(),
    ),
  );

  getIt.registerLazySingleton<BeneficiaryLocalDataSource>(
        () => BeneficiaryLocalDataSource(getIt()),
  );

  getIt.registerLazySingleton<BeneficiaryRepository>(
        () => BeneficiaryRepositoryImpl(
      httpClient: getIt(),
      localDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => GetBeneficiariesUseCase(getIt()));
  getIt.registerLazySingleton(() => AddBeneficiaryUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteBeneficiaryUseCase(getIt()));
  getIt.registerLazySingleton(() => ToggleBeneficiaryStatusUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateBeneficiaryMonthlyAmountUseCase(getIt()));

  getIt.registerFactory(
        () => BeneficiaryBloc(
      getBeneficiariesUseCase: getIt(),
      addBeneficiaryUseCase: getIt(),
      deleteBeneficiaryUseCase: getIt(),
      toggleBeneficiaryStatusUseCase: getIt(),
      updateBeneficiaryMonthlyAmountUseCase: getIt(),
    ),
  );

  getIt.registerLazySingleton<TopupLocalDataSource>(
        () => TopupLocalDataSource(getIt()),
  );

  getIt.registerLazySingleton<TopupRepository>(
        () => TopupRepositoryImpl(
      httpClient: getIt(),
      localDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => PerformTopupUseCase(
    topupRepository: getIt(),
    userRepository: getIt(),
    beneficiaryRepository: getIt(),
  ),);
  getIt.registerLazySingleton(() => GetTransactionsUseCase(getIt()));
  getIt.registerLazySingleton(() => CheckTopupEligibilityUseCase(
    userRepository: getIt(),
    beneficiaryRepository: getIt(),
  ),);

  getIt.registerFactory(
        () => TopupBloc(
      performTopupUseCase: getIt(),
      getTransactionsUseCase: getIt(),
      checkTopupEligibilityUseCase: getIt(),
    ),
  );
}
