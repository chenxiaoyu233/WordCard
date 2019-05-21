// system library
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

// my library
import 'homepage.dart';

// test widget
import 'wordcard.dart';
import 'package:word_card/floatcard.dart';
import 'wordpage.dart';

// entry of the App
void main() => runApp(TestWidget());

// entry for the whole app
/*
class WordCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
*/


// entry for testing some widget
class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Hero(
            tag: 'hero-image',
            child: WordCard(
              width: 300,
              height: 200,
            )
          )
        ),
      ),
      theme: ThemeData(
        backgroundColor: Colors.white
      ),
    );
  }
}
