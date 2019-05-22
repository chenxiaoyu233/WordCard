import 'package:flutter/material.dart';
import 'wordcard.dart';

class WordList extends StatelessWidget {
  Widget _heroWordCard(String heroTag) {
    Map<String, dynamic> word = Map<String, dynamic>();
    word['picture-url'] = 'http://img3.imgtn.bdimg.com/it/u=2878379177,753838150&fm=26&gp=0.jpg';
    word['keyword'] = 'six';
    return Hero (
      tag: heroTag,
      child: WordCard(
        word: word,
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
      ],
    );
  }
}