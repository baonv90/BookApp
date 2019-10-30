import 'dart:convert';
import 'package:xml2json/xml2json.dart'; 
import 'package:http/http.dart' as http;
import 'package:freebook/article.dart';
class LoadingUrl{
  
  bool isLoading;
  final String url;

  LoadingUrl( this.url );

  List<Article>list=List();
  Xml2Json xml2json = new Xml2Json();
  
  getData() async {
    this.isLoading = true;
    http.Response response = await http.get(this.url);
    if (response.statusCode == 200) {
        
      xml2json.parse(response.body);
      var jsondata = xml2json.toGData();
      var data = json.decode(jsondata);      
      var rest = data["feed"]["entry"] as List;
      //print(rest.first["title"]);  
      list = rest.map<Article>((json) => Article.fromJson(json)).toList();
      this.isLoading = false;   
      print(list);
    } 
    else {
      this.isLoading = true;  
      list = [];
      throw Exception('Failed to load photos');
    }
    return list; 
  }
  

  
}

