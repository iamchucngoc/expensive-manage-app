// lib/features/setting/presentation/screens/setting_screen.dart

import 'package:flutter/material.dart';

import '../widgets/logout_button.dart';
import '../widgets/profile_card.dart';
import '../widgets/setting_section.dart';
import '../widgets/setting_tile.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      body: SafeArea(
        child: Column(
          children: [

            /// HEADER
            Container(
              height: 70,
              width: double.infinity,
              color: Colors.black,

              alignment: Alignment.centerLeft,

              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),

              child: const Text(
                "MoneyNote",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [

                    /// PROFILE
                    const ProfileCard(),

                    const SizedBox(height: 24),

                    /// ACCOUNT
                    SettingSection(
                      title: "Tài khoản",

                      children: [
                        SettingTile(
                          icon: Icons.person_outline,
                          title: "Thông tin cá nhân",
                          onTap: () {},
                        ),

                        SettingTile(
                          icon: Icons.shield_outlined,
                          title: "Đổi mật khẩu",
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// FINANCE
                    SettingSection(
                      title: "Quản lý tài chính",

                      children: [
                        SettingTile(
                          icon: Icons.account_balance_wallet_outlined,
                          title: "Ngân sách",
                          onTap: () {},
                        ),

                        SettingTile(
                          icon: Icons.local_offer_outlined,
                          title: "Danh mục chi tiêu",
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    /// LOGOUT
                    LogoutButton(
                      onTap: () {

                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}