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

  // Ghi chú: Đăng nhập Google sẽ cần cài thêm package google_sign_in. 
  // Tạm thời chúng ta hoàn thiện luồng Email/Pass trước.
}