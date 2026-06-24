// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

import 'firebase_options.dart';
import 'core/routes/app_routes.dart';

import 'core/theme_provider.dart';
import 'core/theme/app_theme.dart';

import 'features/transaction/data/services/transaction_service.dart';
import 'features/category/data/services/category_service.dart';
import 'features/auth/data/services/auth_service.dart';
import 'features/setting/data/services/setting_service.dart';
import 'features/budget/data/services/budget_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'features/auth/data/services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('No .env file found: $e');
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  int? colorValue = prefs.getInt('primary_color');
  Color initialColor = colorValue != null ? Color(colorValue) : const Color(0xFFFF6492);


  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    try {

      final userDoc = await UserService().getUser(currentUser.uid);
      
      if (userDoc != null && userDoc.themeColor.isNotEmpty) {

        final String hexColor = userDoc.themeColor.replaceAll('#', '');
        initialColor = Color(int.parse('FF$hexColor', radix: 16));
        
  
        await prefs.setInt('primary_color', initialColor.value);
      }
    } catch (e) {
      debugPrint("Lỗi đồng bộ màu từ Firebase: $e");
    }
  }
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
            title: 'Nora Note',
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