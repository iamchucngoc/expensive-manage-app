import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../category/data/models/category_model.dart';

class ReceiptOcrResult {
  final double? amount;
  final String? merchant;
  final DateTime? date;
  final String? note;
  final String? categorySuggestion;

  const ReceiptOcrResult({
    this.amount,
    this.merchant,
    this.date,
    this.note,
    this.categorySuggestion,
  });

  factory ReceiptOcrResult.fromJsonString(String raw) {
    final trimmed = raw.trim();
    final start = trimmed.indexOf('{');
    final end = trimmed.lastIndexOf('}');
    final jsonText = start >= 0 && end > start ? trimmed.substring(start, end + 1) : trimmed;
    final decoded = jsonDecode(jsonText) as Map<String, dynamic>;

    return ReceiptOcrResult(
      amount: decoded['amount'] is num ? (decoded['amount'] as num).toDouble() : null,
      merchant: decoded['merchant']?.toString(),
      date: decoded['date'] != null ? DateTime.tryParse(decoded['date'].toString()) : null,
      note: decoded['note']?.toString(),
      categorySuggestion: decoded['categorySuggestion']?.toString(),
    );
  }
}

class ReceiptOcrService {
  static String get _apiKey {
    try {
      return dotenv.env['AI_ADVISOR_API_KEY'] ?? '';
    } catch (e) {
      debugPrint('🔹 [OCR] Error reading dotenv: $e');
      return '';
    }
  }

  static String get _modelName {
    return dotenv.env['GEMINI_MODEL'] ?? 'gemini-3.1-flash-lite';
  }

  String? suggestCategory(String text, List<CategoryModel> categories) {
    final normalizedText = _normalizeText(text);
    if (normalizedText.isEmpty) return null;

    final matches = <_CategoryMatch>[];

    for (final category in categories) {
      final normalizedName = _normalizeText(category.name);
      final keywords = _getCategoryKeywords(category.name);
      var score = 0;

      if (normalizedText.contains(normalizedName)) {
        score += 100;
      } else if (normalizedName.contains(normalizedText)) {
        score += 80;
      }

      for (final keyword in keywords) {
        if (normalizedText.contains(keyword)) {
          score += 30;
        }
      }

      if (score > 0) {
        matches.add(_CategoryMatch(category.name, score));
      }
    }

    if (matches.isNotEmpty) {
      matches.sort((a, b) => b.score.compareTo(a.score));
      return matches.first.name;
    }

    if (normalizedText.contains('cafe') || normalizedText.contains('coffee') || normalizedText.contains('tea') || normalizedText.contains('drink') || normalizedText.contains('restaurant')) {
      return 'Ăn uống';
    }
    if (normalizedText.contains('taxi') || normalizedText.contains('grab') || normalizedText.contains('bus') || normalizedText.contains('train') || normalizedText.contains('xe') || normalizedText.contains('fuel')) {
      return 'Di chuyển';
    }
    if (normalizedText.contains('shop') || normalizedText.contains('store') || normalizedText.contains('fashion') || normalizedText.contains('clothes') || normalizedText.contains('market')) {
      return 'Mua sắm';
    }
    if (normalizedText.contains('rent') || normalizedText.contains('internet') || normalizedText.contains('electric') || normalizedText.contains('water') || normalizedText.contains('phone') || normalizedText.contains('service') || normalizedText.contains('bill')) {
      return 'Hóa đơn';
    }
    if (normalizedText.contains('doctor') || normalizedText.contains('hospital') || normalizedText.contains('pharmacy') || normalizedText.contains('medicine') || normalizedText.contains('benh')) {
      return 'Sức khỏe';
    }

    return null;
  }

  String? suggestNote(String? note) {
    if (note == null) return null;

    final cleaned = note.trim();
    if (cleaned.isEmpty || cleaned.length < 3) return null;

    final normalized = _normalizeText(cleaned);
    final genericTerms = [
      'payment', 'purchase', 'receipt', 'invoice', 'bill', 'total', 'amount', 'cash', 'card', 'thanh toan', 'giao dich', 'order', 'transaction'
    ];

    if (genericTerms.any((term) => normalized.contains(term))) {
      return null;
    }

    return cleaned;
  }

  Future<ReceiptOcrResult> extractFromBytes(List<int> imageBytes) async {
    final apiKey = _apiKey;
    if (apiKey.isEmpty) {
      throw Exception('Chưa cấu hình AI_ADVISOR_API_KEY');
    }

    final model = GenerativeModel(model: _modelName, apiKey: apiKey);

    final prompt = '''
Bạn là trợ lý OCR tài chính cho ứng dụng quản lý chi tiêu. Hãy đọc ảnh hóa đơn và trả về JSON duy nhất, không thêm text khác.
Yêu cầu:
- amount: số tiền thanh toán
- merchant: tên cửa hàng
- date: YYYY-MM-DD nếu có
- note: ghi chú ngắn
- categorySuggestion: food, transport, shopping, entertainment, bill, health, other

Trả về đúng mẫu JSON:
{"amount":125000,"merchant":"Cà phê ABC","date":"2026-07-04","note":"Cafe sáng","categorySuggestion":"food"}
''';

    final response = await model.generateContent([
      Content.multi([
        TextPart(prompt),
        DataPart('image/jpeg', Uint8List.fromList(imageBytes)),
      ])
    ]);

    final rawText = response.text?.trim() ?? '';
    if (rawText.isEmpty) {
      throw Exception('AI không đọc được nội dung hóa đơn');
    }

    return ReceiptOcrResult.fromJsonString(rawText);
  }

  String _normalizeText(String value) {
    var output = value.toLowerCase();
    output = output.replaceAll(RegExp(r'[^a-z0-9\s]'), '');
    output = output.replaceAll(RegExp(r'\s+'), ' ').trim();
    return output;
  }

  List<String> _getCategoryKeywords(String categoryName) {
    final normalizedName = _normalizeText(categoryName);
    final keywords = <String>[];

    if (normalizedName.contains('an uong') || normalizedName.contains('food') || normalizedName.contains('eat')) {
      keywords.addAll(['cafe', 'coffee', 'tea', 'food', 'restaurant', 'drink', 'milk', 'bakery', 'eat']);
    }
    if (normalizedName.contains('di chuyen') || normalizedName.contains('transport')) {
      keywords.addAll(['taxi', 'grab', 'bus', 'train', 'xe', 'fuel', 'parking', 'ride']);
    }
    if (normalizedName.contains('mua sam') || normalizedName.contains('shopping')) {
      keywords.addAll(['shop', 'store', 'fashion', 'clothes', 'online', 'shopping', 'market']);
    }
    if (normalizedName.contains('hoa don') || normalizedName.contains('bill')) {
      keywords.addAll(['rent', 'internet', 'electric', 'water', 'phone', 'service', 'bill', 'fee']);
    }
    if (normalizedName.contains('suc khoe') || normalizedName.contains('health')) {
      keywords.addAll(['doctor', 'hospital', 'pharmacy', 'medicine', 'benh', 'health']);
    }
    return keywords;
  }
}

class _CategoryMatch {
  final String name;
  final int score;

  const _CategoryMatch(this.name, this.score);
}
