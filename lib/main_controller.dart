import 'package:daily_phrases/main_repository.dart';

class MainController {
  MainRepository _mainRepository = MainRepository();

  Future<String> getHttp() async => _mainRepository.getHttp();
}
