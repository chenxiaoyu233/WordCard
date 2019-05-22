import 'package:flutter/material.dart';
import 'package:word_card/wordChageNotifier.dart';
import 'wordcard.dart';
import 'package:provider/provider.dart';

class WordList extends StatelessWidget {
  WordList({this.wordlist});
  final String wordlist;

  @override
  Widget build(BuildContext context) {
    return Consumer<WordChangeNotifier> (
      builder: (context, notifier, child) {
        List<Widget> children = List<Widget>();
        if (notifier.data.length > 0) {
          notifier.data[wordlist].forEach((String keyword, Map<String, dynamic> word) {
            String heroTag = 'hero-' + keyword;
            children.add(
              Hero(
                tag: heroTag,
                child: WordCard(
                  word: word,
                  height: 200,
                  width: 300,
                  heroTag: heroTag,
                  margin: EdgeInsets.all(10),
                )
              )
            );
          });
        } else {
          children.add(Text('nothing'));
        }
        return ListView(
          padding: EdgeInsets.all(50),
          children: children
        );
      }
    );
  }
}