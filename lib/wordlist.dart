import 'package:flutter/material.dart';
import 'wordcard.dart';

class WordList extends StatelessWidget {
  Widget _heroWordCard(String heroTag) {
    return Hero (
      tag: heroTag,
      child: WordCard(
        height: 200,
        width: 300,
        heroTag: heroTag,
        margin: EdgeInsets.all(10),
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(50),
      children: <Widget>[
        _heroWordCard('1'),
        _heroWordCard('2'),
        _heroWordCard('3'),
        _heroWordCard('4'),
        _heroWordCard('5'),
      ],
    );
  }
}