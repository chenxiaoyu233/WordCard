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

// entry of the App
//void main() => runApp(WordCard());

void main() {
  Future<Map<String, dynamic> > futureWord =  findWord('China');
  futureWord .then((Map<String, dynamic> word) {
    runApp(TheApp(word: word));
  });
}

// entry for the whole app
class TheApp extends StatelessWidget {
  TheApp({this.word});
  final Map<String, dynamic> word;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: Image.network('http://a4.att.hudong.com/83/66/20200000013920144721665253228_s.jpg')
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center (
          child: Hero(
            tag: 'hero-card',
            child: WordCard(
              word: word,
            )
          )
        ),
      )
    );
  }
}