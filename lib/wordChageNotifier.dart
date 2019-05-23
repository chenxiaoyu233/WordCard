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
      hasCreated boolean DEFAULT false,
      primary key(word, wordlist),
      foreign key (word) references Words(word) on delete cascade
    );
  ''';
  // word relative
  Map<String, Map<String, Map<String, dynamic> > > data;

  /* Open or Build the whole database */
  Future<void> _buildDataBase() async {
    databasePath = await getDatabasesPath();
    databasePath = join(databasePath, 'wordcard.db');
    /* only used in debug */
    //await deleteDatabase(databasePath);
    /* only used in debug */
    db = await openDatabase(databasePath, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(tableWord);
        await db.execute(tableWordMeaning);
        await db.execute(tableWordList);
      }
    );
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
        WHERE wordlist = "$wordlist";
      ''');
      for (final mp in curList) {
        String word = mp['word'];
        data[wordlist][word] = await queryWord(word);
        data[wordlist][word]['has-created'] = mp['hasCreated'];
        data[wordlist][word]['wordlist'] = wordlist;
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
    List<String> meaningList = List<String>();
    for (final mp in meaning) 
      meaningList.add(mp['meaning']);
    info['meaning-list'] = meaningList;
    /* add pronunciation and picture-url */
    List<Map> auxList = await db.rawQuery('''
      SELECT * FROM Words
      WHERE word = "$word";
    ''');
    for (final mp in auxList) {
      info['pronounce-En'] = mp['pronounceEn'];
      info['pronounce-Am'] = mp['pronounceAm'];
      info['picture-url'] = mp['pictureUrl'];
    }
    /* return */
    info = _fixWord(info);
    return info;
  }

  Future<void> insertWord(String keyword, String at) async {
    Map<String, dynamic> word = Map<String, dynamic>();
    /* search the word on the internet */
    word = await findWord(keyword);
    word = _fixWord(word);
    if (word['keyword'] == '') return;
    /* add to table Words */
    await db.transaction((db) async {
      await db.rawInsert('''
        REPLACE INTO Words(word, pronounceEn, pronounceAm, pictureUrl)
        VALUES ("${word['keyword']}", "${word['pronounce-En']}", "${word['pronounce-Am']}", "${word['picture-url']}");
      ''');
      /* add to table WordList */
      await db.rawInsert('''
        REPLACE INTO WordList(word, wordlist)
        VALUES ("${word['keyword']}", "$at");
      ''');
      /* add to table WordMeaning */
      if (word['meaning-list'] != null && word['meaning-list'] is List<String>) {
        for (final meaning in word['meaning-list']) {
          print('add meanin $meaning to the database');
          await db.rawInsert('''
            REPLACE INTO WordMeaning(word, meaning)
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

  /* give the data some initial value to avoid null */
  Map<String, dynamic> _fixWord(Map<String, dynamic> word) {
    Map<String, dynamic> mp = Map<String, dynamic>();
    mp['keyword'] = '';
    mp['meaning-list'] = List<String>();
    mp['pronounce-En'] = 'none';
    mp['pronounce-Am'] = 'none';
    mp['picture-url'] = 'none';
    word.forEach((String str, dynamic content) {
      mp[str] = content;
    });
    return mp;
  }

  /* remove the word from the data base */
  Future<void> removeWord(String keyword) async {
    await db.transaction((db) async {
      await db.rawDelete('''
        DELETE FROM WordMeaning
        WHERE word == "$keyword";
      ''');
      await db.rawDelete('''
        DELETE FROM WordList
        WHERE word == "$keyword";
      ''');
      await db.rawDelete('''
        DELETE FROM Words
        WHERE word == "$keyword";
      ''');
    });
    /* rebuild data */
    await _buildData();
    /* notify all listeners */
    notifyListeners();
  }

  /* mark the word card as created in the database */
  Future<void> createWordCard(String keyword, String at) async {
    await db.transaction((db) async {
      await db.rawUpdate('''
        UPDATE WordList Set hasCreated = true
        WHERE word = "$keyword" and wordlist = "$at";
      ''');
    });
    /* rebuild data */
    await _buildData();
    /* notify all listeners */
    notifyListeners();
  }
}