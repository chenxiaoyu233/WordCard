import 'dart:io';
import 'package:dio/dio.dart';

//library for html parse
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

// Entry
Future<Map<String, dynamic> > findWord(String keyword) async {
  Map<String, dynamic> word = Map<String, dynamic>();
  word['keyword'] = '';
  return getDocument(keyword).then((Document document) {
    /* find the word itself */
    findKeyWord(document, word);
    print(word['keyword']);
    /* find the pronunciation */
    findPronunciation(document, word);
    /* find the chinese meanings */
    findChineseMeaning(document, word);
    /* find the english meanings */
    findEnglishMeaning(document, word);
  }).then((_) {
    return getPictureURL(word, keyword).then((_){
      return word;
    });
  });
}

// get document from internet
// @param: String keyword, access the youdao dictionary using keyword
// @ret Future<Document>, the document represent the web page
Future<Document> getDocument(String keyword) async {
  var dio = Dio();
  Response rsp = await dio.get(
    "https://www.youdao.com/w/eng/" + keyword +"/",
    options: Options(responseType: ResponseType.json)
  );
  var document = parse(rsp.data);
  return document;
}

// find the keyword from the document
void findKeyWord(Document document, Map<String, dynamic> word) {
  List<Element> list = document.getElementsByClassName('keyword');
  if (list.length > 0) {
    word['keyword'] = list.first.innerHtml;
  }
  /* Debug */
  print(word['keyword']);
}

// find the pronunciation from the document
void findPronunciation(Document document, Map<String, dynamic> word) {
  List<Element> list = document.getElementsByClassName('pronounce');
  for (final tab in list) {
    String kind = tab.innerHtml.substring(0, 1);
    List<Element> elem = tab.getElementsByClassName('phonetic');
    if (elem.length > 0) {
      String content = elem.first.innerHtml;
      if (kind == '英') {
        word['pronounce-En'] = content;
      } else if (kind == '美') {
        word['pronounce-Am'] = content;
      }
    }
  }
  /* Debug */
  print(word['pronounce-En']);
  print(word['pronounce-Am']);
}

// find the meaning from the document
void findChineseMeaning(Document document, Map<String, dynamic> word) {
  if (document.getElementsByClassName('trans-container').length > 0) {
    List<Element> list = document.getElementsByClassName('trans-container')
                                .first
                                .getElementsByTagName('li');
    List<String> meanings = new List<String>();
    for (final li in list) {
      meanings.add(li.innerHtml);
      /* Debug */
      print(li.innerHtml);
    }
    word['meaning-list'] = meanings;
  }
}

void findEnglishMeaning(Document document, Map<String, dynamic> word) {
  List<Element> list = document.querySelectorAll('.trans-container .wordGroup .search-js');
  if (!(word['meaning-list'] is List<String>)) {
    word['meaning-list'] = new List<String>();
  }
  for (final e in list) {
    word['meaning-list'].add(e.innerHtml);
    print(e.innerHtml);
  }
}

// get the url for the picture matches the keyword from internet
// @param Map<String, dynamic> word, dic used to store the url (word['picture-url'])
// @param String keyword, keyword used for searching the picture on "www.baidu.com"
Future<void> getPictureURL(Map<String, dynamic> word, String keyword) async {
  var dio = Dio(
    BaseOptions(
      connectTimeout: 1000,
      receiveTimeout: 1000,
      headers: {
        /* fake the user agent */
        HttpHeaders.userAgentHeader: 'dio',
      }
    )
  );
  Response rsp = await dio.get(
    "http://www.baike.com/wiki/" + keyword,
    options: Options(responseType: ResponseType.json)
  );
  //print(rsp.data);
  RegExp exp = RegExp(r'(<div\s*style\s*=\s*"margin:0\s*auto;\s*display:none;\s*">\s*<img\s*src\s*=\s*"[^\"]*"\s*/?>)'); 
  Match matches = exp.firstMatch(rsp.data);
  if (matches != null && matches.groupCount > 0) {
    String tagString = matches.group(0);
    exp = RegExp(r'(http:)?//[^\"]*');
    matches = exp.firstMatch(tagString);
    if (matches != null && matches.groupCount > 0) {
      if (matches.group(0).substring(0,7) == 'http://') {
        word['picture-url'] = matches.group(0);
        /* Debug */
        print(word['picture-url']);
      } else if (matches.group(0).substring(0,2) == '//') {
        word['picture-url'] = 'http:' + matches.group(0);
        /* Debug */
        print(word['picture-url']);
      }
    }
  }
  /*
  Document document = parse(rsp.data);
  List<Element> list = document.getElementsByClassName('torpedo-thumb-link');
  for (final tag in list) {
    word['picture-url'] = tag.getElementsByTagName('img').first.attributes['src'];
    print(tag.toString());
    break;
  }
  /* Debug */
  print(word['picture-url']);
  */
}
/* could not use, because www.baidu.com will have 403
Future<void> getPictureURL(Map<String, dynamic> word, String keyword) async {
  var dio = Dio();
  Response rsp = await dio.get(
    "http://image.baidu.com/search/index?tn=baiduimage&word=" + keyword,
    options: Options(responseType: ResponseType.json)
  );
  RegExp exp = RegExp(r'\"thumbURL\":\"([^\"]*)\"');
  Match matches = exp.firstMatch(rsp.data);
  word['picture-url'] = matches.group(0);
  exp = RegExp(r'http[^\"]*');
  matches = exp.firstMatch(word['picture-url']);
  word['picture-url'] = matches.group(0);
  /* Debug */
  print(word['picture-url']);
}
*/

// could not work, because of 403 of baidu :(
Future<void> downLoadPicture(Map<String, dynamic> word) async {
  print('downloading');
  var dio = Dio(
    BaseOptions(
      connectTimeout: 1000,
      receiveTimeout: 1000,
      headers: {
        /* fake the user agent */
        HttpHeaders.userAgentHeader: 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:23.0) Gecko/20100101 Firefox/23.0',
      }
    )
  );
  try {
    Response rsp = await dio.get(
      word['picture-url'],
      options: Options(responseType: ResponseType.plain)
    );
    print(rsp.data);
  } catch (e) {
    print(e);
  }
}