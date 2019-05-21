import 'package:flutter/material.dart';

class WordCardHeader extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 1500.0,
      floating: true,
      title: Text('say something'),
      flexibleSpace: const FlexibleSpaceBar(
        title: Text('Available seats'),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add_circle),
          tooltip: 'Add new entry',
          onPressed: () { /* ... */ },
        ),
      ]
    );
  }
}