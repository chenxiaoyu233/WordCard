import 'package:flutter/widgets.dart';
import 'package:word_card/floatcard.dart';
import 'package:flutter/material.dart';

class WordCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatCard(
      child: GestureDetector(
        onTap: () {
          /* todo */
        },
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
                    child: Text('Mountain'),
                  ),
                ),
              ),
          ],
        ),
      )
    );
  }
}