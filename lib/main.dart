import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'core/routes/app_routes.dart';

import 'features/transaction/data/services/transaction_service.dart';
import 'features/category/data/services/category_service.dart';
import 'features/auth/services/auth_service.dart';
import 'features/setting/data/services/setting_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider là nơi cung cấp toàn bộ các Services cho toàn app
    return MultiProvider(
      providers: [
        // Cung cấp TransactionService
        Provider<TransactionService>(
          create: (_) => TransactionService(),
        ),
        Provider<CategoryService>(
          create: (_) => CategoryService(),
        ),
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<SettingService>(
          create: (_) => SettingService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Money Note',
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,

        // Về theme, chúng ta sẽ add AppTheme.lightTheme vào đây sau khi code xong tính năng nhé
      ),
    );
  }
}
