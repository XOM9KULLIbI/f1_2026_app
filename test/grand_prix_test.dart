import 'package:flutter_test/flutter_test.dart';
import 'package:f1_2026_app/data/models/grand_prix.dart';
import 'package:f1_2026_app/data/mock/mock_f1_data.dart';

void main() {
  group('GrandPrix Model Tests', () {
    test('Mock data contains 2026 Grand Prix with valid fields', () {
      const list = MockF1Data.grandPrixList;
      expect(list.isNotEmpty, isTrue);
      expect(list.first.id, equals('round-1'));
      expect(list.first.round, equals(1));
      expect(list.first.place, equals('Australia'));
      expect(list.length, equals(23));
    });

    test('Serialization to JSON and deserialization from JSON', () {
      final original = MockF1Data.grandPrixList.first;
      final json = original.toJson();
      final parsed = GrandPrix.fromJson(json);

      expect(parsed.id, equals(original.id));
      expect(parsed.title, equals(original.title));
      expect(parsed.place, equals(original.place));
      expect(parsed.p1Name, equals(original.p1Name));
      expect(parsed, equals(original));
    });
  });
}
