import 'dart:convert';

import 'package:daily_phrases/phrase_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainRepository {
  Future<List<Phrase>> getHttp() async {
    List<Phrase> phrases;

    try {
      var response1 = await Dio().get('https://type.fit/api/quotes');

      Iterable l = json.decode(response1.data);
      phrases = List<Phrase>.from(l.map((model) => Phrase.fromJson(model)));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('phrasesOffline', phrases.toString());

      return phrases;
    } catch (e) {
      print('xxx: $e');
      return List.empty();
    }
  }
}
