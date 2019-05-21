import 'package:flutter/material.dart';
import 'header.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        WordCardHeader(),
      ],
    );
  }
}
