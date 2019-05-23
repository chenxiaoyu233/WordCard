import 'package:flutter/widgets.dart';
import 'package:word_card/floatcard.dart';
import 'package:flutter/material.dart';
import 'package:word_card/wordpage.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:word_card/wordfinder.dart';
import 'wordChageNotifier.dart';
import 'package:provider/provider.dart';

class WordCard extends StatefulWidget {
  WordCard({
    @required this.key,
    this.width: 300, 
    this.height: 200, 
    this.haveDetailedPage: true, 
    this.needShadow: true, 
    this.heroTag: 'hero-card',
    this.margin: margin_init,
    @required this.word
  }): super(key: key);
  

  final Key key;
  final Map<String, dynamic> word;
  final double width;
  final double height;
  final bool needShadow;
  final bool haveDetailedPage;
  final String heroTag;
  final EdgeInsetsGeometry margin;
  static const EdgeInsetsGeometry margin_init = EdgeInsets.all(0);
  static const opacityCurve = const Interval(0.0, 0.75, curve: Curves.easeOut);

  @override
  _WordCardState createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> with TickerProviderStateMixin{
  AnimationController controller;

  @override
  void initState() { 
    super.initState();
    controller = AnimationController(
      value: widget.word['has-created'] == 1 ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
      vsync: this
    );
    controller.addListener((){
      setState(() { });
    });
    if (widget.word['has-created'] == 0) {
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Provider.of<WordChangeNotifier>(context)
                  .createWordCard(widget.word['keyword'], widget.word['wordlist']);
        }
      });
      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatCard(
      margin: widget.margin,
      needShadow: widget.needShadow,
      height: widget.height * controller.value,
      width: widget.width,
      child: GestureDetector(
        onTap: widget.haveDetailedPage && widget.word != null 
                ? () => _onTap(context) : null,
        onLongPress: widget.haveDetailedPage && widget.word != null ? () {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('你想要移除这个单词吗?'),
              action: SnackBarAction(
                label: '移除',
                onPressed: () {
                  controller.addStatusListener((status) {
                    if (status == AnimationStatus.dismissed) {
                      Provider.of<WordChangeNotifier>(context)
                              .removeWord(widget.word['keyword']);
                    }
                  });
                  controller.reverse();
                },
              ) ,
            )
          );
        } : null,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
              widget.word['picture-url'] != 'none' 
              ? FadeInImage.assetNetwork( 
                  image: widget.word['picture-url'],
                  placeholder: 'images/lake.jpg',
              ) : Image(
                image: AssetImage('images/lake.jpg')
              ) ,
              Container(
                alignment: AlignmentDirectional.bottomStart,
                child: Container(
                  height: 50,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      widget.word == null ? 'Mountain' : widget.word['keyword'],
                      style: TextStyle(
                        inherit: false,
                        fontSize: 15,
                        color: Colors.black,
                      ), 
                    ),
                  ),
                ),
              ),
          ],
        ),
      )
    );
  }

  void _onTap(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondAnimation) {
          timeDilation = 1.0;
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget child) {
              return Opacity(
                opacity: WordCard.opacityCurve.transform(animation.value),
                  child: WordPage(
                    heroTag: widget.heroTag,
                    word: widget.word,
                  ),
              );
            },
          );
        }
      )
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
