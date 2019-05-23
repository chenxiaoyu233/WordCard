// system library
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:word_card/wordfinder.dart';

// my library
import 'homepage.dart';

// test widget
import 'wordcard.dart';
import 'package:word_card/floatcard.dart';
import 'wordpage.dart';
import 'wordlist.dart';

import 'package:dio/dio.dart';
import 'wordChageNotifier.dart';
import 'package:provider/provider.dart';
import 'addWordFAB.dart';

// entry of the App
void main() => runApp(TheApp());

// entry for the whole app
class TheApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        builder: (context) => WordChangeNotifier(),
        child: HomePage(),
      ),
    );
  }
}

// entry for test new widget
class WidgetTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      color: Colors.white,
    );
  }
}
/*
void main() {
  findWord('football').then((Map<String, dynamic> word){
    runApp(WordPageTest(word: word));
  });
}*/
class WordPageTest extends StatelessWidget {
  WordPageTest({this.word});
  final Map<String, dynamic> word;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WordPage(
        word: word
      ),
      color: Colors.white,
    );
  }
}