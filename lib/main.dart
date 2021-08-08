import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:snack/snack.dart';

import 'main_controller.dart';
import 'phrase_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Phrase',
      theme: ThemeData(
        primaryColor: Colors.blue,
        primaryColorDark: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Daily Phrase'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title, Key? key}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final bar = SnackBar(content: Text('Available only on web version :('));

  var _phrase = '';
  var _author = '';
  var _cardColor;
  List<Phrase> listpPhrase = List.empty();
  final MainController _mainController = MainController();
  ScreenshotController screenshotController = ScreenshotController();

  void _updatePhrase() async {
    setState(() {
      final w = Random().nextInt(listpPhrase.length);
      _phrase = listpPhrase[w].text.toString();
      _author = listpPhrase[w].author.toString();
    });
    _changeColor();
  }

  void _getList() async {
    await _mainController.getHttp2().then((value) {
      setState(() {
        listpPhrase = value;
      });
    });
    _updatePhrase();
  }

  void _share() async {
    if (kIsWeb) {
      bar.show(context);
    } else {
      await screenshotController
          .capture(delay: const Duration(milliseconds: 10))
          .then((image) async {
        if (image != null) {
          final directory = await getApplicationDocumentsDirectory();
          final imagePath = await File('${directory.path}/image.png').create();
          await imagePath.writeAsBytes(image);

          await Share.shareFiles([imagePath.path]);
        }
      });
    }
  }

  void _changeColor() {
    setState(() {
      _cardColor = Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
          .withOpacity(1.0);
    });
  }

  @override
  void initState() {
    _getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: _share,
          ),
          IconButton(
            icon: Icon(
              Icons.color_lens,
              color: Colors.white,
            ),
            onPressed: _changeColor,
          )
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                listpPhrase.isNotEmpty
                    ? Screenshot(
                        controller: screenshotController,
                        child: Card(
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Container(
                            color: _cardColor,
                            padding: EdgeInsets.all(32.0),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                    width: 300,
                                    height: 200,
                                    child: Center(
                                        child: Text(_phrase,
                                            style: GoogleFonts.playfairDisplay(
                                                fontSize: 20),
                                            textAlign: TextAlign.center))),
                                Text(
                                  _author,
                                  style:
                                      GoogleFonts.playfairDisplay(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _updatePhrase,
        tooltip: 'New Phrase',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
