// lib/core/routes/app_routes.dart
import 'package:flutter/material.dart';

// Import chính xác theo cấu trúc của bạn
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/dashboard/presentation/screens/main_screen.dart';
import '../../features/transaction/presentation/screens/add_transaction_screen.dart';

import '../../features/setting/presentation/screens/setting_screen.dart';
import '../../features/setting/presentation/screens/profile_screen.dart';
import '../../features/category/presentation/screens/category_management_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String main = '/main';
  static const String addTransaction = '/add-transaction';
  static const String setting = '/setting';
  static const String profile = '/profile';
  static const String changePassword = '/change-password';
  static const String categoryManagement = '/category-management';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    auth: (context) => const AuthScreen(),
    main: (context) => const MainScreen(),
    addTransaction: (context) => const AddTransactionScreen(),
    setting: (context) => const SettingScreen(),
    profile: (context) => const ProfileScreen(),
    categoryManagement: (context) => const CategoryManagementScreen(),

  };
}