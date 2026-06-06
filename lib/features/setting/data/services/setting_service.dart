// lib/features/setting/data/services/setting_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class SettingService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Hàm Đăng xuất
  Future<void> logOut() async {
    await _auth.signOut();
  }

  // Lấy email user hiện tại
  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  // Logic Đổi mật khẩu
  Future<void> changePassword(String oldPassword, String newPassword) async {
    final user = _auth.currentUser;
    if (user != null && user.email != null) {
      try {
        // 1. Xác thực lại bằng mật khẩu cũ
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword,
        );
        await user.reauthenticateWithCredential(credential);

        // 2. Đổi sang mật khẩu mới
        await user.updatePassword(newPassword);
      } catch (e) {
        // Ném lỗi ra để hiển thị thông báo cho người dùng
        if (e is FirebaseAuthException) {
          if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
            throw Exception('Mật khẩu cũ không chính xác!');
          } else if (e.code == 'weak-password') {
            throw Exception('Mật khẩu mới quá yếu (cần tối thiểu 6 ký tự).');
          }
        }
        throw Exception('Lỗi: Cập nhật thất bại. Vui lòng thử lại sau.');
      }
    }
  }
}