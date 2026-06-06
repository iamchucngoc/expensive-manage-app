// lib/features/setting/presentation/screens/change_password_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/services/setting_service.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  final Color primaryPink = const Color(0xFFFF6492);

  void _handleSave() async {
    final oldPass = _oldPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirmPass = _confirmPasswordController.text.trim();

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      _showError('Vui lòng điền đầy đủ thông tin');
      return;
    }

    if (newPass != confirmPass) {
      _showError('Mật khẩu xác nhận không khớp');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final settingService = Provider.of<SettingService>(context, listen: false);
      await settingService.changePassword(oldPass, newPass);
      
      if (mounted) {
        // Tắt popup đổi mật khẩu
        Navigator.pop(context); 
        // Lùi về màn hình Setting (Tắt luôn trang Thông tin tài khoản)
        Navigator.pop(context); 
        // Hiển thị Popup thành công giống Figma
        _showCustomSuccessDialog(context);
      }
    } catch (e) {
      _showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Hàm hiển thị Popup báo lỗi (dùng tạm SnackBar cho nhanh gọn)
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

 
  // HÀM TẠO POPUP THÀNH CÔNG 
  void _showCustomSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) { //  dialogContext
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (dialogContext.mounted) {
            Navigator.pop(dialogContext);
          }
        });

        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black87, width: 1), 
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: const Icon(Icons.check, color: Colors.black, size: 24),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Đổi mật khẩu thành công',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
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
    final dialogBackgroundColor = const Color(0xFF9098A3); // Màu xám xanh

    return Dialog(
      backgroundColor: dialogBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // Sử dụng Stack để đặt nút X màu đỏ đè lên trên cùng
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField('Mật khẩu cũ:', _oldPasswordController),
                const SizedBox(height: 16),
                _buildTextField('Mật khẩu mới:', _newPasswordController),
                const SizedBox(height: 16),
                _buildTextField('Xác nhận mật khẩu mới:', _confirmPasswordController),
                const SizedBox(height: 24),
                
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _isLoading ? null : _handleSave,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20, height: 20, 
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Lưu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Nút X màu đỏ góc trên bên phải
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.red, size: 28),
              onPressed: () => Navigator.pop(context), // Đóng popup
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black54, width: 0.5), // Thêm viền mỏng giống thiết kế
      ),
      child: TextField(
        controller: controller,
        obscureText: true,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }
}