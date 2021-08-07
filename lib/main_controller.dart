import 'package:daily_phrases/main_repository.dart';
import 'package:daily_phrases/phrase_model.dart';

class MainController {
  MainRepository _mainRepository = MainRepository();
  Future<List<Phrase>> getHttp2() async => await _mainRepository.getHttp();
}
