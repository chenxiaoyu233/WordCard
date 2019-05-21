import 'package:flutter/material.dart';
import 'package:word_card/wordcard.dart';

class WordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Hero(
              tag: 'hero-image',
              child: WordCard(
                width: 1000, // fill the border
                height: 300,
                haveDetailedPage: false,
                needShadow: false,
              ),
            )
          ),
        ],
      ),
    );
  }
}