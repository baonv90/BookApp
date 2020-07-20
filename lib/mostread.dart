import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:xml2json/xml2json.dart'; 
// import 'package:http/http.dart' as http;
import 'bookinfo.dart';
import 'article.dart';
// import 'downloaded.dart';



class MostRead extends StatefulWidget {

  final List<Article> list;
  // final List<Downloaded> download;
  final String title;
  MostRead(this.title, this.list);
  @override
  _MostReadState createState() => _MostReadState(this.title, this.list);
}

class _MostReadState extends State<MostRead> with AutomaticKeepAliveClientMixin {

  final String title;
  final List<Article> list;
  _MostReadState(this.title, this.list);

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

  // bool checkDownloaded(String id) {
  //   bool result = false;
  //   for(int i = 0; i < widget.download.length ; i++)
  //   {
  //     if(id == widget.download[i].id)
  //     {
  //       result = true;
  //     }
  //   }
  //   return result;
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(this.title),
        ),
        body: 
            ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    onTap: () {
                      setState(() {     
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BookInfo(book: list[index])));
                      });       
                    },
                    title: new Text(list[index].title),
                    subtitle: Text(list[index].author + ' (' + list[index].category + ')'),
                    leading: Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                    // Box decoration takes a gradient
                      gradient: LinearGradient(
                        // Where the linear gradient begins and ends
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        // Add one stop for each color. Stops should increase from 0 to 1
                        stops: [0.3, 0.9],
                        colors: _getColorGradient(int.parse(list[index].id)%8),
                      ),),
                      child: Center(child: Text(list[index].title.substring(0,1),style:TextStyle(color: Colors.white, fontSize: 25))),
                    )
                  );
        }));
  }
  @override
  bool get wantKeepAlive => true;
}


