class UserModel {
  final String uid;
  final String email;
  final String themeColor;

  UserModel({
    required this.uid,
    required this.email,
    required this.themeColor,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      themeColor: map['themeColor'] ?? '#FF6492',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'themeColor': themeColor,
    };
  }
}