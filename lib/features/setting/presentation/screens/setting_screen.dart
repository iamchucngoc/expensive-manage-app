// lib/features/setting/presentation/screens/setting_screen.dart

import 'package:flutter/material.dart';

import '../../../budget/presentation/screens/budget_screen.dart';
import '../../../category/presentation/screens/category_management_screen.dart';

import 'profile_screen.dart';
import 'change_password_screen.dart';

import '../widgets/profile_card.dart';
import '../widgets/setting_section.dart';
import '../widgets/setting_tile.dart';
import '../widgets/logout_button.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [

              /// PROFILE
              const ProfileCard(),

              const SizedBox(height: 20),

              /// TÀI KHOẢN
              SettingSection(
                title: "Tài khoản",

                children: [

                  SettingTile(
                    icon: Icons.person_outline,
                    title: "Thông tin cá nhân",

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ProfileScreen(),
                        ),
                      );
                    },
                  ),

                  SettingTile(
                    icon: Icons.lock_outline,
                    title: "Đổi mật khẩu",

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// TÀI CHÍNH
              SettingSection(
                title: "Quản lý tài chính",

                children: [

                  SettingTile(
                    icon: Icons.account_balance_wallet_outlined,
                    title: "Ngân sách",

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const BudgetScreen(),
                        ),
                      );
                    },
                  ),

                  SettingTile(
                    icon: Icons.sell_outlined,
                    title: "Danh mục chi tiêu",

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const CategoryManagementScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 40),

              const LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}