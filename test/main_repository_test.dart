import 'package:daily_phrases/main_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class DioMock extends Mock implements Dio {}

void main() {
  // final dio = DioMock();
  final _mainRepository = MainRepository();

  test('Faz requisição http e retorna frase', () async {
    String response = await _mainRepository.getHttp();
    expect(false, response.isEmpty);
    expect(true, response.length > 10);
    expect(true, response.contains('id'));
    expect(true, response.contains('frase'));
  });
}
