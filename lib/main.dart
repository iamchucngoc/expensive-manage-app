// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

import 'firebase_options.dart';
import 'core/routes/app_routes.dart';

import 'core/theme_provider.dart';
import 'core/theme/app_theme.dart';

import 'features/transaction/data/services/transaction_service.dart';
import 'features/category/data/services/category_service.dart';
import 'features/auth/services/auth_service.dart';
import 'features/setting/data/services/setting_service.dart';
import 'features/budget/data/services/budget_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  final prefs = await SharedPreferences.getInstance();
  int? colorValue = prefs.getInt('primary_color');
  

  Color initialColor = colorValue != null ? Color(colorValue) : const Color(0xFFFF6492);

  runApp(MyApp(initialColor: initialColor));
}

class MyApp extends StatelessWidget {
  final Color initialColor; 
  
  const MyApp({super.key, required this.initialColor});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(initialColor),
        ),
        
        Provider<TransactionService>(create: (_) => TransactionService()),
        Provider<CategoryService>(create: (_) => CategoryService()),
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<SettingService>(create: (_) => SettingService()),
        Provider<BudgetService>(create: (_) => BudgetService()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Money Note',
            themeMode: ThemeMode.light,
            theme: AppTheme.getLightTheme(themeProvider.primaryColor),
            darkTheme: AppTheme.getDarkTheme(themeProvider.primaryColor),
            
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}