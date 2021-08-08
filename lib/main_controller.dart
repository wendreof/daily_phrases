import 'main_repository.dart';
import 'phrase_model.dart';

// ignore: public_member_api_docs
class MainController {
  final _mainRepository = MainRepository();
  Future<List<Phrase>> getHttp2() async => await _mainRepository.getHttp();
}
