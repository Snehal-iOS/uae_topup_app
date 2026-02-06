import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/beneficiary/presentation/bloc/beneficiary_bloc.dart';
import 'features/beneficiary/presentation/bloc/beneficiary_event.dart';
import 'features/topup/presentation/bloc/topup_bloc.dart';
import 'features/user/presentation/bloc/user_bloc.dart';
import 'features/user/presentation/bloc/user_event.dart';
import 'dependency_injection.dart';
import 'screens/main_bottom_navigation_bar_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => getIt<UserBloc>()..add(const LoadUser()),
                ),
                BlocProvider(
                  create: (context) => getIt<BeneficiaryBloc>()
                    ..add(const LoadBeneficiaries()),
                ),
                BlocProvider(
                  create: (context) => getIt<TopupBloc>(),
                ),
              ],
              child: const MainBottomNavigationBarScreen(),
            ),
          );
        },
      ),
    );
  }
}
