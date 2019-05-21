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
  findWord('six');
}

// entry for the whole app
class WordCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(), 
      theme: ThemeData(
        backgroundColor: Colors.white
      ),
    );
  }
}