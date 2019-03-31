import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app2/data/newsresponse.dart';
import 'package:scoped_model/scoped_model.dart';

class HeadlineModel extends Model{
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<News> _newsList = <News>[];
  List<News> get newList => _newsList;

  void fetchNews() async{
    _isLoading = true;
    notifyListeners();
    //setState(() { _isLoading = true;});
    final response = await http.get('https://newsapi.org/v2/top-headlissnes?sources=techcrunch&apiKey=b69e5b1c8c764dde95bd768664e57115');
    print(response.body);
    var responseJson = json.decode(response.body);
    NewsResponse newsResponse = NewsResponse.fromJson(responseJson);
    _newsList = newsResponse.articles;
    _isLoading = false;
    notifyListeners();
    
  }
  
}