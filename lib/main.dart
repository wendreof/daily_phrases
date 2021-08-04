import 'dart:math';

import 'package:daily_phrases/main_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frase Diária',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Frase Diária'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _frase = "";
  var _livro = "";
  MainController _mainController = MainController();

  void _atualizaFrase() async {
    _mainController.getHttp().then((response) {
      print('response: $response');
      setState(() {
        _frase = response.isNotEmpty
            ? response.split(",")[1].replaceAll("frase:", "")
            : "Carregando...";
        _livro = response.isNotEmpty
            ? response
                .split(",")[3]
                .replaceAll("livro", "Livro")
                .replaceAll('autor', 'Livro')
            : "Carregando...";
      });
    }).whenComplete(() => _atualizaCor());
  }

  Color _atualizaCor() =>
      Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0);

  @override
  void initState() {
    _atualizaFrase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      color: _atualizaCor(),
                      padding: EdgeInsets.all(32.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                              width: 300,
                              height: 200,
                              child: Center(
                                  child: Text(_frase,
                                      style: TextStyle(fontSize: 20)))),
                          Text(_livro),
                          //Text('Livro'),
                        ],
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _atualizaFrase,
        tooltip: 'Nova Frase',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
