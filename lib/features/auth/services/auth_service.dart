// lib/features/auth/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Lấy user hiện tại
  User? get currentUser => _auth.currentUser;

  // Đăng nhập bằng Email/Password
  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Đăng ký tài khoản mới
  Future<UserCredential> signUpWithEmailPassword(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  // Đăng xuất
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'Không tìm thấy tài khoản với email này.';
      }
      throw 'Có lỗi xảy ra: ${e.message}';
    }
  }
}