import 'package:dio/dio.dart';

class MainRepository{
  Future<String> getHttp() async {
    try {
      var response =
          await Dio().get('http://allugofrases.herokuapp.com/frases/random');
      var x = response.data;
      print(response.data);
      return response.data.toString();
    } catch (e) {
      return "";
    }
  }
}