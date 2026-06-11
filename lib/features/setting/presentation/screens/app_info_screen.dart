// lib/features/setting/presentation/screens/app_info_screen.dart
import 'package:flutter/material.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: primaryColor.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'MoneyNote',
                style: TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new, size: 24, color: Colors.black),
                  ),
                  const Expanded(
                    child: Text(
                      "Thông tin ứng dụng",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 24), 
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // Các ô thông tin 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildInfoRow(Icons.person, "Sinh viên thực hiện", "Ngô Chúc Ngọc", primaryColor),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.badge, "Lớp", "64KTPM2 - ĐH Thủy Lợi", primaryColor),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.book, "Tên đồ án", "Xây dựng ứng dụng quản lý chi tiêu cá nhân MoneyNote", primaryColor),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.school, "Giảng viên hướng dẫn", "ThS. Lê Nguyễn Tuấn Thành", primaryColor),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.calendar_today, "Ngày hoàn thành", "Tháng 06/2026", primaryColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}