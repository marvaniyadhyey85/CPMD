import 'package:go_router/go_router.dart';
import 'package:spendwise_app/data/models/transaction_model.dart';
import 'package:spendwise_app/presentation/providers/auth_provider.dart';
import 'package:spendwise_app/presentation/screens/auth/login_screen.dart';
import 'package:spendwise_app/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:spendwise_app/presentation/screens/transactions/transactions_screen.dart';
import 'package:spendwise_app/presentation/screens/analytics/analytics_screen.dart';
import 'package:spendwise_app/presentation/screens/manage/manage_transaction_screen.dart';

class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: authProvider.isAuthenticated ? '/dashboard' : '/login',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final loggedIn = authProvider.isAuthenticated;
        final isLoggingIn = state.matchedLocation == '/login';

        if (!loggedIn && !isLoggingIn) return '/login';
        if (loggedIn && isLoggingIn) return '/dashboard';
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/transactions',
          builder: (context, state) => const TransactionsScreen(),
        ),
        GoRoute(
          path: '/analytics',
          builder: (context, state) => const AnalyticsScreen(),
        ),
        GoRoute(
          path: '/manage',
          builder: (context, state) {
            final tx = state.extra as TransactionModel?;
            return ManageTransactionScreen(initialTransaction: tx);
          },
        ),
      ],
    );
  }
}
