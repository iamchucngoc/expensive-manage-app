# 🌸 NoraNote - Personal Finance Tracker with Generative AI

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
![Gemini AI](https://img.shields.io/badge/Gemini_AI-8E75B2?style=for-the-badge&logo=google-bard&logoColor=white)

NoraNote là ứng dụng quản lý tài chính và chi tiêu cá nhân thông minh, được xây dựng trên nền tảng Flutter và tích hợp Trí tuệ nhân tạo (Generative AI) giúp người dùng tối ưu hóa dòng tiền và nhận lời khuyên tài chính cá nhân hóa.

---

## ✨ Tính năng nổi bật (Key Features)

* **Ghi chép giao dịch Realtime:** Thêm, sửa, xóa các khoản thu chi nhanh chóng, dữ liệu được đồng bộ tức thời và lưu trữ bảo mật trên Cloud Database.
* **Bàn phím tùy chỉnh (Custom In-app Keyboard):** Thiết kế bàn phím số riêng biệt tích hợp ngay trong app giúp tối ưu hóa tốc độ và trải nghiệm nhập liệu tiền tệ.
* **Cá nhân hóa giao diện (Dynamic Theme):** Hỗ trợ thay đổi màu sắc chủ đạo toàn hệ thống theo sở thích cá nhân của người dùng.
* **Phân loại danh mục thông minh (Smart Categories):** Hệ thống danh mục thu/chi được tổ chức khoa học (Ăn uống, Di chuyển, Giáo dục, Lương...), hỗ trợ người dùng dễ dàng phân loại và theo dõi dòng tiền đổ vào đâu.
* **Thiết lập hạn mức ngân sách (Budget Management):** Tính năng đặt hạn mức chi tiêu cho từng danh mục theo tháng, tự động tính toán và báo cáo khi chi tiêu sắp vượt ngưỡng an toàn.
* **Báo cáo trực quan (Smart Analytics):** Hệ thống biểu đồ tròn và biểu đồ cột trực quan, phân tích sâu tỷ trọng chi tiêu và xu hướng biến động tài chính theo tuần/tháng.
* **Trợ lý Tài chính AI (Gemini AI Integration):** Tích hợp mô hình AI siêu tốc đóng vai trò cố vấn tâm lý, phân tích trực tiếp số liệu báo cáo thực tế để đưa ra lời khuyên hành động cụ thể, cá nhân hóa cho từng người dùng.

---

## 🛠️ Công nghệ sử dụng (Tech Stack)

* **Frontend Framework:** Flutter (Dart)
* **Backend-as-a-Service:** Firebase (Authentication, Cloud Firestore)
* **AI Engine:** Google Gemini API (gemini-3.1-flash-lite)
* **UI/UX Design:** Figma (Pixel-perfect implementation)

---

## 🚀 Hướng dẫn cài đặt & Chạy local (Installation & Setup)

Để chạy dự án NoraNote ở máy cục bộ, hãy làm theo các bước sau:

### 1. Chuẩn bị môi trường (Prerequisites)
* Đã cài đặt Flutter SDK và cấu hình môi trường Dart mới nhất.
* Đã cấu hình máy ảo Android/iOS hoặc thiết bị thật.

### 2. Clone dự án và cài đặt thư viện
```bash
# Clone repository này về máy
git clone https://github.com/iamchucngoc/expensive-manage-app.git

# Di chuyển vào thư mục dự án
cd expensive-manage-app

# Cài đặt các thư viện package
flutter pub get
```

### 3. Cấu hình Firebase & API Key
* Tải file cấu hình `google-services.json` (Android) hoặc `GoogleService-Info.plist` (iOS) từ dự án Firebase của bạn và bỏ vào đúng thư mục hệ thống.
* Đảm bảo thêm Gemini API Key hợp lệ vào file service để kích hoạt tính năng Trợ lý AI (Không push API key public lên GitHub).

### 4. Chạy ứng dụng
```bash
flutter run
```

---

## 📑 Cấu trúc thư mục dự án (Project Structure)
Dự án được xây dựng theo kiến trúc **Feature-first**, giúp dễ dàng mở rộng và bảo trì:
```text
lib/
│
├── core/                # Cấu hình chung, màu sắc, routes, theme
├── features/            # Các tính năng chính của ứng dụng
│   ├── budget/          # Thiết lập và theo dõi hạn mức ngân sách
│   ├── calendar/        # Lịch giao dịch và tóm tắt theo ngày
│   ├── category/        # Quản lý danh mục thu/chi
│   ├── report/          # Biểu đồ phân tích & Trợ lý AI Gemini
│   ├── setting/         # Cài đặt ứng dụng, tùy chỉnh theme
│   └── transaction/     # Bàn phím custom, thêm/sửa/xóa giao dịch
└── main.dart            # Điểm khởi chạy ứng dụng
```

---
**👨‍💻 Người thực hiện:** Ngô Chúc Ngọc - Sinh viên Lớp 64KTPM2 - Khoa CNTT - Đại học Thủy Lợi.