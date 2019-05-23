import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:word_card/wordfinder.dart';

// this class manages all the data sources from database
// and the state of all the wordlist and word
class WordChangeNotifier extends ChangeNotifier {
  WordChangeNotifier() {
    _buildDataBase()
      .then((_) => _buildData())
      .then((_) => notifyListeners());
  }

  // DB relative
  String databasePath;
  Database db;
  final String tableWord = '''
    CREATE TABLE Words (
      word varchar(100) primary key,
      pronounceEn varchar(100),
      pronounceAm varchar(100),
      pictureUrl varchar(10000)
    );
  ''';
  final String tableWordMeaning= '''
    CREATE TABLE WordMeaning (
      word varchar(100) not null,
      meaning varchar (10000) not null,
      primary key (word, meaning),
      foreign key (word) references Words(word) on delete cascade
    );
  ''';
  final String tableWordList = '''
    CREATE TABLE WordList (
      word varchar (100) not null,
      wordlist varchar (100) not null,
      primary key(word, wordlist),
      foreign key (word) references Words(word) on delete cascade
    );
  ''';
  // word relative
  Map<String, Map<String, Map<String, dynamic> > > data;

  /* Open or Build the whole database */
  Future<void> _buildDataBase() async {
    databasePath = await getDatabasesPath();
    print('1');
    databasePath = join(databasePath, 'wordcard.db');
    /* only used in debug */
    await deleteDatabase(databasePath);
    print('2');
    /* only used in debug */
    db = await openDatabase(databasePath, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(tableWord);
        await db.execute(tableWordMeaning);
        await db.execute(tableWordList);
      }
    );
    print('3');
  }

  Future<void> _buildData() async {
    /* init the data */
    data = Map<String, Map<String, Map<String, dynamic> > >();
    /* add three word lists */
    List<String> wordlists = ['Beginner', 'Intermediate', 'Advanced'];
    for (final String wordlist in wordlists) {
      data[wordlist] = Map<String, Map<String, dynamic> >();
    }

    /* add word for each word list */
    for (final String wordlist in wordlists) {
      List<Map> curList = await db.rawQuery('''
        SELECT * FROM WordList
        WHERE wordlist = "$wordlist"
      ''');
    print('4');
      for (final mp in curList) {
        String word = mp['word'];
        data[wordlist][word] = await queryWord(word);
        print('5');
      }
    }
  }

  Future<Map<String, dynamic> > queryWord(String word) async {
    Map<String, dynamic> info = Map<String, dynamic>();
    /* add key word */
    info['keyword'] = word;
    /* add meaning */
    List<Map> meaning = await db.rawQuery('''
      SELECT * FROM WordMeaning
      WHERE word = "$word";
    ''');
    print('6');
    List<String> meaningList = List<String>();
    for (final mp in meaning) 
      meaningList.add(mp['meaning']);
    info['meaning'] = meaningList;
    /* add pronunciation and picture-url */
    List<Map> auxList = await db.rawQuery('''
      SELECT * FROM Words
      WHERE word = "$word";
    ''');
    print('7');
    for (final mp in auxList) {
      info['pronounce-En'] = mp['pronounceEn'];
      info['pronounce-Am'] = mp['pronounceAm'];
      info['picture-url'] = mp['pictureUrl'];
    }
    /* return */
    return info;
  }

  Future<void> insertWord(String keyword, String at) async {
    /* search the word on the internet */
    Map<String, dynamic> word = await findWord(keyword);
    /* add to table Words */
    await db.transaction((db) async {
      await db.rawInsert('''
        INSERT INTO Words(word, pronounceEn, pronounceAm, pictureUrl)
        VALUES ("${word['keyword']}", "${word['pronounce-En']}", "${word['pronounce-Am']}", "${word['picture-url']}");
      ''');
      /* add to table WordList */
      await db.rawInsert('''
        INSERT INTO WordList(word, wordlist)
        VALUES ("${word['keyword']}", "$at");
      ''');
      /* add to table WordMeaning */
      if (word['meaning'] != null && word['meaning'] is List<String>) {
        for (final meaning in word['meaning']) {
          await db.rawInsert('''
            INSERT INTO WordMeaning(word, meaning)
            VALUES ("${word['keyword']}", "$meaning");
          ''');
        }
      }
    });
    /* rebuild data */
    await _buildData();
    /* notify all listeners */
    notifyListeners();
  }
}