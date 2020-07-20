import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:xml2json/xml2json.dart'; 
import 'package:http/http.dart' as http;
import 'bookinfo.dart';
import 'article.dart';



class BookFromAuthor extends StatefulWidget {

  
  final String title;
  final String id;
  BookFromAuthor(this.id, this.title);
  @override
  _BookFromAuthorState createState() => _BookFromAuthorState(this.id, this.title);
}

class _BookFromAuthorState extends State<BookFromAuthor>  {
  final String id;
  final String title;
  _BookFromAuthorState(this.id, this.title);

  List<Article> list= [];
  Xml2Json xml2json = new Xml2Json();

  bool isLoading = true;
  
  @override
  void initState() {

    getData();
   
    super.initState();
  }

  getData() async {
    
    setState(() {
        isLoading = true;  
    });
    final response = await http.get('https://www.ebooksgratuits.com/opds/feed.php?mode=author&id=' + this.id);
    //print('https://www.ebooksgratuits.com/opds/feed.php?mode=author&id=' + this.id);
    
    if (response.statusCode == 200) {
      // await new Future.delayed(const Duration(seconds: 1));

        //print(response.statusCode);
     
        xml2json.parse(response.body);
        var jsondata = xml2json.toGData();
        var data = json.decode(jsondata); 

        if(data["feed"]["entry"]!=null)
        {
          var rest = data["feed"]["entry"];// as List;

          if(rest[0] != null)
          {
             setState(() {
              list = rest.map<Article>((json) => Article.fromJson(json)).toList();
              isLoading = false;
            });
          }
          else
          {
            setState(() {
              Article art = Article.fromJson(rest);   
              list.add(art);      
              isLoading = false;
            });
            //print(list[0].id);
          }
        }
        else
        {
          setState(() {
            list = [];
            isLoading = false;   
          });
        }

       // print(list);
    } 
    else {
      throw Exception('Failed to load books');
    }
    
  }
  List<Color> _getColorGradient (int rand)
  {
    switch(rand) {
     case 1: return [const Color(0xffcc2b5e), const Color(0xff753a88)]; break;
     case 2: return [const Color(0xff42275a), const Color(0xff734b6d)]; break;
     case 3: return [const Color(0xff2c3e50), const Color(0xffbdc3c7)]; break;
     case 4: return [const Color(0xff06beb6), const Color(0xff06aab1)]; break;
     case 5: return [const Color(0xff614385), const Color(0xff516395)]; break;
     case 6: return [const Color(0xff000428), const Color(0xff004e92)]; break;
     case 7: return [const Color(0xff4568dc), const Color(0xffb06ab3)]; break;
     case 8: return [const Color(0xff2b5876), const Color(0xff4e4376)]; break;

     default: return [const Color(0xff43cea2), const Color(0xff185a9d)]; break;
    }
    
  }


  getColor (String letter) {
    switch(letter) {
      case 'A' : return Colors.amber;  break; 
      case 'B' : return Colors.blue;  break; 
      case 'C' : return Colors.cyan;  break; 
      case 'D' : return Colors.deepOrange;  break; 
      case 'E' : return Colors.black87;  break; 
      case 'F' : return Colors.blue;  break; 
      case 'G' : return Colors.green;  break; 
      case 'H' : return Colors.blueGrey;  break; 
      case 'I' : return Colors.indigo;  break; 
      case 'J' : return Colors.black38;  break; 
      case 'K' : return Colors.cyanAccent;  break; 
      case 'L' : return Colors.lime; break; 
      case 'M' : return Colors.green;  break; 
      case 'N' : return Colors.black38;  break; 
      case 'O' : return Colors.orange;  break; 
      case 'P' : return Colors.purple;  break; 
      case 'Q' : return Colors.green;  break; 
      case 'R' : return Colors.red;  break; 
      case 'S' : return Colors.greenAccent;  break; 
      case 'T' : return Colors.teal;  break; 
      case 'U' : return Colors.redAccent;  break; 
      case 'V' : return Colors.purpleAccent;  break; 
      case 'W' : return Colors.white24;  break; 
      case 'X' : return Colors.green;  break; 
      case 'Y' : return Colors.yellow;  break; 
      case 'Z' : return Colors.tealAccent;  break; 
      default : return Colors.black38; break;
      
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
        appBar: AppBar(
          title: Text(this.title),
        ),
        body: 
            isLoading
            ? Center(
                child: CircularProgressIndicator(backgroundColor: Colors.blue, valueColor: new AlwaysStoppedAnimation(Colors.black26)),
              )
            : 
            ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    onTap: () {               
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BookInfo(book: list[index])));
                    },
                    title: new Text(list[index].title),
                    subtitle: Text(list[index].category),
                    leading: Container(
                      width: 60,
                      height: 60,
                       decoration: BoxDecoration(
                        // Box decoration takes a gradient
                        gradient: LinearGradient(
                          // Where the linear gradient begins and ends
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          // Add one stop for each color. Stops should increase from 0 to 1
                          stops: [0.3, 0.9],
                          colors: _getColorGradient(int.parse(list[index].id)%8),
                        ),
                      ),
                      child: Center(child: Text(list[index].title.substring(0,1),style:TextStyle(color: Colors.white, fontSize: 25))),
                    )
                  );
        }));
  }
 
}


