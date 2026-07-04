import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/transaction/data/services/receipt_ocr_service.dart';
import 'package:app/features/category/data/models/category_model.dart';

void main() {
  group('ReceiptOcrResult', () {
    test('parses Gemini JSON response into usable fields', () {
      const response = '{"amount":125000,"merchant":"Cà phê ABC","date":"2026-07-04","note":"Cafe sáng","categorySuggestion":"food"}';

      final result = ReceiptOcrResult.fromJsonString(response);

      expect(result.amount, 125000);
      expect(result.merchant, 'Cà phê ABC');
      expect(result.date, DateTime(2026, 7, 4));
      expect(result.note, 'Cafe sáng');
      expect(result.categorySuggestion, 'food');
    });

    test('prefers existing categories when suggesting a category', () {
      final service = ReceiptOcrService();
      final categories = [
        CategoryModel(id: '1', userId: 'u1', name: 'Ăn uống', type: 'expense', icon: 'restaurant', colorHex: 'FF0000'),
        CategoryModel(id: '2', userId: 'u1', name: 'Di chuyển', type: 'expense', icon: 'car', colorHex: '00FF00'),
      ];

      final suggestion = service.suggestCategory('Hóa đơn cafe sáng tại Starbucks', categories);

      expect(suggestion, 'Ăn uống');
    });
  });
}
