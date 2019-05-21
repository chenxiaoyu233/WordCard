import 'package:flutter/widgets.dart';
import 'package:word_card/floatcard.dart';
import 'package:flutter/material.dart';
import 'package:word_card/wordpage.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class MyCliper extends CustomClipper<RRect> {
  MyCliper({this.radius});
  final Radius radius;
  @override
  RRect getClip(Size size) {
    // TODO: implement getClip
    return RRect.fromLTRBR(0, 0, size.width * 0.5, size.height * 0.5, radius);
  }
  @override
  bool shouldReclip(CustomClipper<RRect> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

class WordCard extends StatelessWidget {
  WordCard({
    this.width: 300, 
    this.height: 200, 
    this.haveDetailedPage: true, 
    this.needShadow: true, 
    this.heroTag: 'hero-card',
    this.margin: margin_init
  });

  final double width;
  final double height;
  final bool needShadow;
  final bool haveDetailedPage;
  final String heroTag;
  final EdgeInsetsGeometry margin;
  static const EdgeInsetsGeometry margin_init = EdgeInsets.all(0);
  static const opacityCurve = const Interval(0.0, 0.75, curve: Curves.easeOut);

  @override
  Widget build(BuildContext context) {
    return FloatCard(
      margin: margin,
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
                opacity: opacityCurve.transform(animation.value),
                  child: WordPage(
                    heroTag: heroTag,
                  ),
              );
            },
          );
        }
      )
    );
  }
}