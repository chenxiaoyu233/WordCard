import 'package:flutter/widgets.dart';
import 'package:word_card/floatcard.dart';
import 'package:flutter/material.dart';
import 'package:word_card/wordpage.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class WordCard extends StatelessWidget {
  WordCard({this.width: 300, this.height: 200, this.haveDetailedPage: true, this.needShadow: true});
  final double width;
  final double height;
  final bool needShadow;
  final bool haveDetailedPage;

  @override
  Widget build(BuildContext context) {
    return FloatCard(
      needShadow: needShadow,
      height: height,
      width: width,
      child: GestureDetector(
        onTap: haveDetailedPage ? () => _onTap(context) : null,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
              Image(
                fit: BoxFit.fitWidth,
                image: AssetImage('images/lake.jpg'),
              ),
              Container(
                alignment: AlignmentDirectional.bottomStart,
                child: Container(
                  height: 50,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      'Mountain',
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
                opacity: animation.value,
                child: WordPage(),
              );
            },
          );
        }
      )
    );
  }
}