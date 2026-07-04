// lib/features/report/data/services/ai_advisor_service.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiAdvisorService {

  static String get _apiKey {
    try {
      return dotenv.env['AI_ADVISOR_API_KEY'] ?? '';
    } catch (e) {
      debugPrint('🔹 [AI] Error reading dotenv: $e');
      return '';
    }
  }
  static String get _modelName {
    return dotenv.env['GEMINI_MODEL'] ?? 'gemini-3.1-flash-lite';
  }

  Future<String> getAdvice({
    required double income,
    required double expense,
    required List<MapEntry<String, Map<String, dynamic>>> sortedCategories,
  }) async {
    if (_apiKey.isEmpty) {
      return "🌸 Xin chào! Ứng dụng chưa được cấu hình API Key từ Google AI Studio nên mình chưa thể phân tích số liệu được.";
    }

    debugPrint('🔹 [AI] Starting getAdvice...');
    debugPrint('🔹 [AI] API Key loaded: ${_apiKey.substring(0, 10)}...');

    final balance = income - expense;
    final savingsRate = income > 0 ? ((balance / income) * 100) : 0;
    final topCategory = sortedCategories.isNotEmpty ? sortedCategories.first : null;
    final topCategoryName = topCategory?.key ?? 'Chưa xác định';
    final topCategoryAmount = topCategory != null ? (topCategory.value['amount'] as double) : 0.0;
    final topCategoryShare = expense > 0 ? (topCategoryAmount / expense * 100) : 0;

    final categorySummary = sortedCategories
        .map((e) {
          final amount = e.value['amount'] as double;
          final share = expense > 0 ? (amount / expense * 100) : 0;
          return '- ${e.key}: ${amount.toStringAsFixed(0)} đ (${share.toStringAsFixed(0)}%)';
        })
        .join('\n');

    try {
      final model = GenerativeModel(model: _modelName, apiKey: _apiKey);
      debugPrint('🔹 [AI] Model created: $_modelName');

      final prompt = '''
Bạn là một chuyên gia tư vấn tài chính cá nhân cho người Việt Nam. Dưới đây là dữ liệu chi tiêu và thu nhập tháng này. Hãy phân tích chuyên sâu và trả lời hoàn toàn bằng tiếng Việt.

Dữ liệu tháng:
- Tổng thu nhập: ${income.toStringAsFixed(0)} đ
- Tổng chi tiêu: ${expense.toStringAsFixed(0)} đ
- Số dư cuối tháng: ${balance.toStringAsFixed(0)} đ
- Tỷ lệ tiết kiệm: ${savingsRate.toStringAsFixed(0)}%
- Mục chi tiêu lớn nhất: $topCategoryName với ${topCategoryAmount.toStringAsFixed(0)} đ (${topCategoryShare.toStringAsFixed(0)}% tổng chi)
- Chi tiết chi tiêu:
$categorySummary

Yêu cầu:
1. Đánh giá rõ tình hình tài chính: đang tiết kiệm, cân bằng hay đang chi tiêu quá tay. Nêu rõ số dư và tỷ lệ tiết kiệm.
2. Chỉ ra rủi ro chính trong cách chi tiêu hiện tại và giải thích vì sao nó đáng lo.
3. Dự đoán nếu giữ tốc độ chi tiêu này thì khả năng vượt quá ngân sách trong tháng như thế nào.
4. Đưa ra 3 khuyến nghị cụ thể: một cho quản lý tổng ngân sách, một cho tối ưu mục chi tiêu lớn nhất, và một cho thói quen chi tiêu.
5. Trả lời bằng tiếng Việt, giọng chuyên nghiệp và thân thiện, câu ngắn gọn, rõ ràng. Dùng emoji như ✨, 💸, 📑 để làm tăng cảm giác chuyên nghiệp.
6. Không dùng markdown, không dùng tiếng Anh, không trả lời chung chung.

Trả lời:
''';
      debugPrint('🔹 [AI] Prompt prepared, calling generateContent...');

      final response = await model
          .generateContent([Content.text(prompt)])
          .timeout(const Duration(seconds: 10), onTimeout: () {
            debugPrint('🔹 [AI] ⏱️ TIMEOUT: Request took too long (10s)');
            throw TimeoutException('Yêu cầu đến AI quá lâu. Vui lòng thử lại sau.');
          });
      
      debugPrint('🔹 [AI] ✅ Response received successfully');
      return response.text ?? 'Hệ thống AI đang bận xử lý số liệu một chút, bạn thử lại sau nhé! 💤';
    } on TimeoutException catch (e) {
      debugPrint('🔹 [AI] ❌ TimeoutException: ${e.message}');
      return 'AI phản hồi chậm (quá 10 giây).\n${e.message}';
    } catch (e) {
      debugPrint('🔹 [AI] ❌ Error: $e');
      return 'Kết nối với trợ lý AI thất bại.\nLỗi: $e';
    }
  }
}