import 'package:flutter/material.dart';
import 'package:word_card/wordcard.dart';

class WordPage extends StatelessWidget {
  WordPage({this.heroTag: 'hero-card'});
  final String heroTag;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Hero(
              tag: heroTag,
              child: WordCard(
                width: 1000, // fill the border
                height: 300,
                haveDetailedPage: false,
                needShadow: false,
              ),
            )
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(40),
              children: <Widget>[
              ],
            )
          ),
        ],
      ),
    );
  }
}