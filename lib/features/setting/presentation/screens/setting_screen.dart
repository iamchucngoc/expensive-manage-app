// lib/features/setting/presentation/screens/setting_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart'; 
import '../../data/services/setting_service.dart';
import 'theme_setup_screen.dart';
import 'app_info_screen.dart'; 

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  void _showHelpDialog(BuildContext context, Color primaryColor) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('ʕ•́ᴥ•̀ʔっ♡', style: TextStyle(fontSize: 40, color: primaryColor)),
                const SizedBox(height: 16),
                const Text('Trợ giúp', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text('Nếu bạn cần trợ giúp hãy liên hệ SĐT:\n039645369', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Text('Người quản lý ứng dụng sẽ hỗ trợ bạn nhiệt tình nhé! 🌸', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), elevation: 0),
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Đã hiểu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final SettingService settingService = Provider.of<SettingService>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white, 
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 60), 
                const Text('Cài đặt', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                GestureDetector(
                  onTap: () => _showHelpDialog(context, primaryColor),
                  child: const Text('Trợ giúp', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500)),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildMenuItem(context, icon: Icons.person, iconColor: primaryColor, title: 'Thông tin tài khoản', onTap: () => Navigator.pushNamed(context, AppRoutes.profile)),
                  _buildMenuItem(context, icon: Icons.color_lens, iconColor: primaryColor, title: 'Thay đổi màu chủ đề', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ThemeSetupScreen()))),
                  _buildMenuItem(context, icon: Icons.folder, iconColor: primaryColor, title: 'Quản lý danh mục', onTap: () => Navigator.pushNamed(context, AppRoutes.categoryManagement)),
                  _buildMenuItem(context, icon: Icons.info, iconColor: primaryColor, title: 'Thông tin ứng dụng', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AppInfoScreen()))),
                ],
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(bottom: 30, left: 40, right: 40, top: 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), elevation: 0),
                onPressed: () async {
                 showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return Dialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.black87, width: 0.5), borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Bạn muốn đăng xuất ?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(child: OutlinedButton(style: OutlinedButton.styleFrom(backgroundColor: Colors.grey.shade200, side: const BorderSide(color: Colors.black, width: 1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), padding: const EdgeInsets.symmetric(vertical: 10)), onPressed: () => Navigator.pop(dialogContext), child: const Text('Hủy', style: TextStyle(color: Colors.black, fontSize: 14)))),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: primaryColor, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), padding: const EdgeInsets.symmetric(vertical: 10)),
                                      onPressed: () async {
                                        Navigator.pop(dialogContext);
                                        await settingService.logOut();
                                        if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, AppRoutes.auth, (route) => false);
                                      },
                                      child: const Text('Đăng xuất', style: TextStyle(color: Colors.white, fontSize: 14)),
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
                child: const Text('Đăng xuất', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
      child: ListTile(leading: Icon(icon, color: iconColor), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)), trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey), onTap: onTap),
    );
  }
}