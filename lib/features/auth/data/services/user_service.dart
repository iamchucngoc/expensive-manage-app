import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  

  final String collection = 'users';

  // Tạo hoặc cập nhật thông tin User
  Future<void> saveUser(UserModel user) async {
    await _db.collection(collection).doc(user.uid).set(
          user.toMap(),
          SetOptions(merge: true),
        );
  }

  // Lấy thông tin User
  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection(collection).doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  // Hàm để gọi khi người dùng đổi màu trong phần Cài đặt
  Future<void> updateThemeColor(String uid, String colorHex) async {
    await _db.collection(collection).doc(uid).update({
      'themeColor': colorHex,
    });
  }
}