// lib/features/report/data/services/ai_advisor_service.dart
import 'package:google_generative_ai/google_generative_ai.dart';

class AiAdvisorService {
  static const String _apiKey = ''; 

  Future<String> getAdvice({
    required double income,
    required double expense,
    required List<MapEntry<String, Map<String, dynamic>>> sortedCategories,
  }) async {
    if (_apiKey.isEmpty) {
      return "🌸 Xin chào! Ứng dụng chưa được cấu hình API Key từ Google AI Studio nên mình chưa thể phân tích số liệu được.";
    }

    try {
      final model = GenerativeModel(model: 'gemini-3.1-flash-lite', apiKey: _apiKey); 
      
      String catSummary = sortedCategories
          .map((e) => "- ${e.key}: ${e.value['amount'].toStringAsFixed(0)} đ")
          .join('\n');

      // Thiết lập Prompt - Ra lệnh cho AI đóng vai và ép văn phong
      final prompt = '''
        Bạn là một chuyên gia cố vấn tài chính cá nhân thông minh, thân thiện và cực kỳ tâm lý.
        Dưới đây là báo cáo tài chính tháng này của tôi:
        - Tổng tiền thu vào (Thu nhập): ${income.toStringAsFixed(0)} đ
        - Tổng tiền chi ra (Chi tiêu): ${expense.toStringAsFixed(0)} đ
        - Chi tiết các hạng mục đã chi tiêu:
        $catSummary
        
        Nhiệm vụ của bạn:
        1. Nhận xét ngắn gọn xem tôi đang quản lý tiền tốt hay chưa (Thu có bù nổi Chi không).
        2. Nhìn vào danh mục tôi tiêu nhiều tiền nhất, đưa ra 1 lời khuyên thực tế, thông minh để tôi tiết kiệm hơn vào tháng sau.
        3. Yêu cầu văn phong: Trẻ trung, chuyên nghiệp, ngắn gọn dưới 90 từ, sử dụng các icon cảm xúc dễ thương (như ✨, 🌸, 💸, 📑), gọi tôi là "bạn" và xưng "mình". KHÔNG sử dụng các định dạng markdown dấu sao phức tạp (như **, ###).
      ''';

      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Hệ thống AI đang bận xử lý số liệu một chút, bạn thử lại sau nhé! 💤';
    } catch (e) {
      return 'Kết nối với trợ lý AI thất bại.\nLỗi: $e';
    }
  }
}