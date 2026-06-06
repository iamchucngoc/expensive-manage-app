// lib/features/setting/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../../data/services/setting_service.dart';
import 'change_password_screen.dart'; // Import giao diện Dialog đổi mật khẩu

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingService settingService = SettingService();
    final String userEmail = settingService.getCurrentUserEmail() ?? "Chưa đăng nhập";
    final Color primaryPink = const Color(0xFFFF6492);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Thông tin tài khoản', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios , color: Colors.black),
          onPressed: () => Navigator.pop(context),
          
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end, 
          children: [
            // Ô hiển thị Email
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.person, color: primaryPink),
                  const SizedBox(width: 16),
                  Text('Email: $userEmail', style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Ô hiển thị Mật khẩu
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock, color: primaryPink),
                  const SizedBox(width: 16),
                  const Text('Mật khẩu: ********', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Nút Đổi mật khẩu
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              onPressed: () {
                // Hiển thị Popup Đổi mật khẩu
                showDialog(
                  context: context,
                  barrierDismissible: true, // Cho phép chạm ra ngoài để đóng
                  builder: (context) => const ChangePasswordDialog(),
                );
              },
              child: const Text(
                'Đổi mật khẩu',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}