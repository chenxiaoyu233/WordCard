import 'package:dio/dio.dart';

//library for html parse
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

// Entry
Map<String, dynamic> findWord(String keyword) {
  Future<Document> futureDocument = getDocument(keyword);
  Map<String, dynamic> word = findWordFromDocument(futureDocument);
  getPicture(word, keyword);
  return word;
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

Map<String, dynamic> findWordFromDocument(Future<Document> futureDocument) {
  Map<String, dynamic> word = new Map<String, dynamic>();
  futureDocument.then((Document document) {
    /* find the word itself */
    findKeyWord(document, word);
    /* find the pronunciation */
    findPronunciation(document, word);
    /* find the meanings */
    findMeaning(document, word);
    /* Mark the finial sattus of the word */
    word['status'] = 'success';
  }).catchError((e) {
    word['status'] = 'error';
  });
  return word;
}

// find the keyword from the document
void findKeyWord(Document document, Map<String, dynamic> word) {
  List<Element> list = document.getElementsByClassName('keyword');
  word['keyword'] = list.first.innerHtml;
  /* Debug */
  print(word['keyword']);
}

// find the pronunciation from the document
void findPronunciation(Document document, Map<String, dynamic> word) {
  List<Element> list = document.getElementsByClassName('pronounce');
  for (final tab in list) {
    String kind = tab.innerHtml.substring(0, 1);
    String content = tab.getElementsByClassName('phonetic').first.innerHtml;
    if (kind == '英') {
      word['pronounce-En'] = content;
    } else if (kind == '美') {
      word['pronounce-Am'] = content;
    }
  }
  /* Debug */
  print(word['pronounce-En']);
  print(word['pronounce-Am']);
}

// find the meaning from the document
void findMeaning(Document document, Map<String, dynamic> word) {
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

// get the url for the picture matches the keyword from internet
// @param Map<String, dynamic> word, dic used to store the url (word['picture-url'])
// @param String keyword, keyword used for searching the picture on "www.baidu.com"
void getPicture(Map<String, dynamic> word, String keyword) async {
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