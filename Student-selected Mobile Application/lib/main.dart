import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendwise_app/core/theme/app_theme.dart';
import 'package:spendwise_app/presentation/providers/auth_provider.dart';
import 'package:spendwise_app/presentation/providers/expense_provider.dart';
import 'package:spendwise_app/presentation/providers/filter_provider.dart';
import 'package:spendwise_app/presentation/providers/theme_provider.dart';
import 'package:spendwise_app/presentation/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SpendWiseApp());
}

class SpendWiseApp extends StatelessWidget {
  const SpendWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
      ],
      child: Consumer2<AuthProvider, ThemeProvider>(
        builder: (context, authProvider, themeProvider, _) {
          final router = AppRouter.createRouter(authProvider);

          return MaterialApp.router(
            title: 'SpendWise',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
