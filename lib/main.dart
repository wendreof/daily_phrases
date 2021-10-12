import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:snack/snack.dart';

import 'controllers/main_controller.dart';
import 'models/phrase_model.dart';
import 'utils/size_config.dart';
import 'utils/theme_manager.dart';

void main() {
  return runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => ThemeNotifier(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, child) => MaterialApp(
        title: 'Daily Phrase',
        theme: theme.getTheme(),
        home: MyHomePage(title: 'Daily Phrase', theme: theme),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title, required this.theme, Key? key})
      : super(key: key);

  final String title;
  dynamic theme;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final bar = SnackBar(content: Text('Not available on web version :('));

  var _phrase = '';
  var _author = '';
  var _cardColor;
  var _iconTheme = 'light';
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
    ThemeNotifier().getIconTheme().then((value) {
      _iconTheme = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeConfig = SizeConfig(mediaQueryData: MediaQuery.of(context));
    final _card = Card(
      elevation: sizeConfig.dynamicScaleSize(size: 20),
      shape: RoundedRectangleBorder(
        // ignore: lines_longer_than_80_chars
        borderRadius:
            BorderRadius.circular(sizeConfig.dynamicScaleSize(size: 50)),
      ),
      child: Container(
        color: _cardColor,
        padding: EdgeInsets.all(sizeConfig.dynamicScaleSize(size: 15.0)),
        child: Column(
          children: <Widget>[
            SizedBox(
                width: sizeConfig.dynamicScaleSize(size: 300),
                height: sizeConfig.dynamicScaleSize(size: 200),
                child: Center(
                    child: Text(_phrase,
                        style: GoogleFonts.playfairDisplay(
                            fontSize: sizeConfig.dynamicScaleSize(size: 20)),
                        textAlign: TextAlign.center))),
            Text(
              _author,
              style: GoogleFonts.playfairDisplay(
                  fontSize: sizeConfig.dynamicScaleSize(size: 15)),
            ),
          ],
        ),
      ),
    );

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
                _iconTheme == 'dark' ? Icons.wb_sunny : Icons.nightlight,
                color: Colors.white,
              ),
              onPressed: () {
                if (_iconTheme == 'light') {
                  widget.theme.setDarkMode();
                  _iconTheme = 'dark';
                } else if (_iconTheme == 'dark') {
                  widget.theme.setLightMode();
                  _iconTheme = 'light';
                } else {
                  widget.theme.setDarkMode();
                  _iconTheme = 'dark';
                }
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(sizeConfig.dynamicScaleSize(size: 15.0)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  listpPhrase.isNotEmpty
                      ? Screenshot(
                          controller: screenshotController,
                          child: GestureDetector(
                            onTap: _changeColor,
                            child: _card,
                          ),
                        )
                      : CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: _updatePhrase,
        tooltip: 'New Phrase',
        child: Icon(
          Icons.refresh,
          color: Theme.of(context).errorColor,
        ),
      ),
    );
  }
}
