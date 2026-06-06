// lib/features/setting/presentation/screens/setting_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart'; 
import '../../data/services/setting_service.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryPink = const Color(0xFFFF6492);
    // Lấy SettingService từ Provider 
    final SettingService settingService = Provider.of<SettingService>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Cài đặt', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Trợ giúp', style: TextStyle(color: Colors.black)),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
      ),
      // Bọc toàn bộ trong Column chính
      body: Column(
        children: [
          // Bọc trong Expanded + SingleChildScrollView 
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildMenuItem(
                    context,
                    icon: Icons.person,
                    iconColor: primaryPink,
                    title: 'Thông tin tài khoản',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.profile);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.color_lens,
                    iconColor: primaryPink,
                    title: 'Thay đổi màu chủ đề',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.folder,
                    iconColor: primaryPink,
                    title: 'Quản lý danh mục',
                    onTap: () {Navigator.pushNamed(context, AppRoutes.categoryManagement);},
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.info,
                    iconColor: primaryPink,
                    title: 'Thông tin ứng dụng',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          
          //  nút Đăng xuất bên dưới: Ghim cố định không bao giờ tràn
          Padding(
            padding: const EdgeInsets.only(bottom: 30, left: 40, right: 40, top: 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                onPressed: () async {
                 showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return Dialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.black87, width: 0.5), // Viền mỏng
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Bạn muốn đăng xuất ?',
                                style: TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.w500, 
                                  color: Colors.black
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  // Nút Hủy
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade200,
                                        side: const BorderSide(color: Colors.black, width: 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                      ),
                                      onPressed: () => Navigator.pop(dialogContext), // Đóng popup
                                      child: const Text(
                                        'Hủy', 
                                        style: TextStyle(color: Colors.black, fontSize: 14)
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Nút Đăng xuất (màu hồng)
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryPink,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                      ),
                                      onPressed: () async {
                                        Navigator.pop(dialogContext); // Đóng popup trước
                                        
                                        // Thực hiện đăng xuất Firebase
                                        await settingService.logOut();
                                        
                                        // Về lại màn đăng nhập, xóa sạch lịch sử
                                        if (context.mounted) {
                                          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.auth, (route) => false);
                                        }
                                      },
                                      child: const Text(
                                        'Đăng xuất', 
                                        style: TextStyle(color: Colors.white, fontSize: 14)
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text(
                  'Đăng xuất',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildMenuItem(BuildContext context, {required IconData icon, required Color iconColor, required String title, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100, 
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}