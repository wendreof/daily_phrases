import 'package:daily_phrases/repositories/main_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final _mainRepository = MainRepository();

  test('Http requisition', () async {
    final response = await _mainRepository.getHttp();
    expect(false, response.isEmpty);
    expect(true, response.length > 10);
    // expect(true, response.contains('id'));
    // expect(true, response.contains('frase'));
  });
}
