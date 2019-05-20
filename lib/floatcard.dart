import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FloatCard extends StatelessWidget {

  FloatCard({this.child, this.color: Colors.white, this.height: 200, this.width: 300});

  final Widget child;
  final Color color;
  final double width;
  final double height;
  final BorderRadius borderRadius = BorderRadius.all(Radius.circular(15));

  @override
  Widget build (BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius
        ),
        color: color,
        shadows: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            spreadRadius: 2
          )
        ]
      ),
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: child,
      )
    );
  }
}