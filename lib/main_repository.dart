import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'phrase_model.dart';

// ignore: public_member_api_docs
class MainRepository {
  Future<List<Phrase>> getHttp() async {
    List<Phrase> phrases;

    try {
      final response1 = await Dio().get('https://type.fit/api/quotes');

      final Iterable l = json.decode(response1.data);
      phrases = List<Phrase>.from(l.map((model) => Phrase.fromJson(model)));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('phrasesOffline', phrases.toString());

      return phrases;
    } on Exception {
      return List.empty();
    }
  }
}
