import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:word_card/wordChageNotifier.dart';
import 'package:provider/provider.dart';

class AddWordFAB extends StatefulWidget {
  AddWordFAB({this.at});
  final String at;
  @override
  _AddWordFABState createState() => _AddWordFABState();
}

class _AddWordFABState extends State<AddWordFAB> with TickerProviderStateMixin{
  AnimationController controller;
  String keyword = '';

  @override
  void initState() { 
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this
    );
    controller.addListener((){
      setState(() { });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material( 
      shadowColor: Colors.black,
      shape: StadiumBorder(),
      color: Colors.deepPurple,
      elevation: 8,
      child: Container(
        alignment: AlignmentDirectional.centerEnd,
        child: _child(),
        color: Colors.transparent,
        width: 60 + (290 - 60) * controller.value,
        height: 60,
      )
    );
  }

  Widget _child() {
    if (controller.value < 0.5) {
      return Opacity(
        opacity: (0.5 - controller.value) * 2.0,
        child: Container(
          color: Colors.transparent,
          width: 60,
          height: 60,
          child: InkWell(
            customBorder: CircleBorder(),
            onTap: (){
              keyword = '';
              controller.forward();
            },
            child: Icon(
              Icons.add,
              color: Colors.white
            )
          )
        )
      );
    } else {
      return Opacity(
        opacity: (controller.value - 0.5) * 2.0,
        child: Row(
          children: <Widget>[
            Flexible(
              child: Container(
                padding: EdgeInsets.only(left: 25),
                child: TextField(
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    icon: Icon( 
                      Icons.translate,
                      color: Colors.green
                    ),
                    labelText: "请在这里输入单词",
                    labelStyle: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  onChanged: (s) {
                    keyword = s;
                  },
                ),
              )
            ),
            Container(
              color: Colors.transparent,
              width: 60,
              height: 60,
              child: InkWell(
                customBorder: CircleBorder(),
                onTap: (){
                  controller.reverse();
                  if (keyword != '') {
                    print(keyword);
                    Provider.of<WordChangeNotifier>(context)
                            .insertWord(keyword, widget.at);
                  }
                },
                child: Icon(
                  Icons.check,
                  color: Colors.white
                )
              )
            )
          ],
        )
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}