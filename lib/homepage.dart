import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:word_card/wordChageNotifier.dart';
import 'package:word_card/wordlist.dart';
import 'header.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget{
  @override 
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  List tabs = ['Beginner', 'Intermediate', 'Advanced'];

  @override
  void initState() { 
    super.initState();
    _tabController = new TabController(
      initialIndex: 0,
      length: tabs.length,
      vsync: this
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))
          )
        ),
        margin: EdgeInsets.only(top: 40),
        child: TabBarView(
          controller: _tabController,
          children: tabs.map((e) {
            return Center(
              child: WordList(wordlist: e),
            );
          }).toList()
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      bottomNavigationBar: BottomAppBar(
        //shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        color: Colors.blueGrey,
        child: Container(
          height: 20,
          padding: EdgeInsets.only(right: 90),
          child: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white54,
            controller: _tabController,
            tabs: tabs.map((e) => Tab(text: e)).toList()
          ),
        ),
      ),
    );
  }
}
