import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:word_card/wordcard.dart';

class WordPage extends StatelessWidget {
  WordPage({this.heroTag: 'hero-card', @required this.word});
  final String heroTag;
  final Map<String, dynamic> word;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))
            )
          ),
          margin: EdgeInsets.fromLTRB(0, 20, 0, 30),
          child: Column(
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
                    height: 200,
                    haveDetailedPage: false,
                    needShadow: false,
                    word: word,
                  ),
                )
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(40),
                  children: _generateInfoList(),      
                )
              ),
            ],
          ),
        )
      )
    );
  }

  List<Widget> _generateInfoList() {
    List<Widget> list = List<Widget>();
    list.add(Text('英式读音: ' + word['pronounce-En']));
    list.add(Text('美式读音: ' + word['pronounce-Am']));
    for (final meaning in word['meaning-list']) {
      list.add(Text('意思: ' + meaning));
    }
    return list;
  }

}