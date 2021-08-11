import '../models/phrase_model.dart';
import '../repositories/main_repository.dart';

// ignore: public_member_api_docs
class MainController {
  final _mainRepository = MainRepository();
  Future<List<Phrase>> getHttp2() async => await _mainRepository.getHttp();
}
