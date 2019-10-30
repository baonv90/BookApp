import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:freebook/article.dart';
import 'package:epub/epub.dart';
import 'bookinfo.dart';

class OnReading extends StatefulWidget {
  final selectIndex;
  OnReading({Key key, this.selectIndex}) : super(key: key);
  
  
  @override
  _OnReadingState createState() => _OnReadingState();
}

class _OnReadingState extends State<OnReading> {

    List<BookCard> list = [];
    Directory directory;

    @override
    void initState() {
      print('Init On Reading');  
      super.initState();
    }
    
   
    Future<void> deleteBook(String id) async  
    {
      List files = await directory.list().toList(); 
      for(int i = 0 ; i < files.length; i++)
      {
        String path = files[i].path;
        if(path.contains("book$id"))
        {
          files[i].delete();
        }
      }
    }

    Future loadReadingBook() async {
      directory = await getApplicationDocumentsDirectory();
      //print(directory);
      if(list != [])
      {
        list.clear();
      }
      
      List files = await directory.list().toList();
      // print(files[1]);
      
      for(int i = 0 ; i < files.length; i++)
      {
        String path = files[i].path;
      
        if(path.contains(".epub") && path.contains("/book"))
        {
          //print(path);
          try {
            File file = files[i];
            EpubBookRef epubBookRef = await EpubReader.openBook(file.readAsBytesSync());
            if(epubBookRef != null)
            {
              var id = path.substring(path.indexOf('/book') + 5, path.indexOf('.epub'));
              var time = await file.lastModified();
              list.add(BookCard(epubBookRef.Title, epubBookRef.Author, id, time));
            }
          }
          catch(e) {
            files[i].delete();
          }      
        }     
      }
      list.sort();
      return list;
    }

   

    String getHeader(int time)
    {
      switch(time) {
        case 0: return "Today";
        case 1: return "Last 7 days";
        case 2: return "Before";
        default: return "Recently";
      }
    }
    
    
    @override
    Widget build(BuildContext context) {
     var topBar = Column(
      
      children: <Widget>[
        SizedBox(height: 30.0,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          
          child: Row (
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Reading", style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, foreground: Paint()..shader = LinearGradient( colors: <Color>[Colors.blue, Colors.teal]).createShader(Rect.fromLTWH(0.0, 0.0, 100.0, 70.0))),),
            Spacer(), 
          ],),),
          Divider(
            height: 1,
            color: Colors.black54,
          ),
        ],
    );
      
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: FutureBuilder(
        future: widget.selectIndex == 4 ? loadReadingBook() : null,
        builder: (context, snapshot) {
        return  Container(
        child: Column(
          
          children: <Widget>[
            topBar,
            Expanded(
              child: Container(
              child : RefreshIndicator(
              displacement: 0,
              backgroundColor: Colors.blue,
              onRefresh: loadReadingBook,
            
              child : ListView.builder(
                itemCount: list.length, 
                padding: EdgeInsets.zero,
 
              
              itemBuilder: (context, index) {
              
              
              var item = list[index];
              var book = new Article( id: item.cover, title: item.title, author: item.author, category: "", description: "description", link: "", );


              bool _time = true;
              if(index > 0) _time = list[index].getSeparatorTime() != list[index - 1].getSeparatorTime();
              
              return StickyHeader(
                header: _time ? Container(
                  height: 25.0,
                  color: Colors.grey[200],
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    getHeader(list[index].getSeparatorTime()),
                    style: const TextStyle(color: Colors.black),
                  ),
                ): Container(),
                content: //list[index],
                  InkWell (
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BookInfo(book: book)));
                    },
                    child: Container( child: Dismissible(
                      direction: DismissDirection.endToStart,
                      key: Key(book.id.toString()),
                      onDismissed: (direction) {
                        setState(() {
                          list.removeAt(index);
                          deleteBook(book.id);
                        });
                        Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text("Deleted!")));
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.delete, color: Colors.white, size: 30,)
                      ),
                      child: Container(
                          child: list[index],
                          color: Colors.transparent,
                        )
                      ),
                    )
                  )
                );                  
              }),
            )
      
    
           ))
         ],    
      )
      );
      },),);}
    
}


class BookCard extends StatelessWidget implements Comparable<BookCard>{
  final String title, author;
  final DateTime time;
  final cover;
  BookCard(this.title, this.author, this.cover, this.time);

  int compareTo(BookCard other) {
    int order = other.time.compareTo(time);
    return order;
  }

  int getSeparatorTime ()
  {
    var now = DateTime.now();
    
    if(now.difference(this.time).inHours <= now.hour)
    {
      return 0;
    }
    else if(now.difference(this.time).inDays < 7) 
    {
      return 1;
    }
    else 
    {
      return 2;
    }
  }

  String getTime ()
  {
    var now = DateTime.now();
    if(now.difference(this.time).inMinutes < 60){
      return now.difference(this.time).inMinutes.toString() + " minute(s) ago";
    }
    else if(now.difference(this.time).inHours < now.hour)
    {
      return  now.difference(this.time).inHours.toString() + " hour(s) ago";
    }
    else if(now.difference(this.time).inDays < 1)
    {
      return "Yesterday";
    }
    else if(now.difference(this.time).inDays < 7) 
    {
      return "Last week";
    }
    else 
    {
      return this.time.day.toString() + '/' + this.time.month.toString() + '/' + this.time.year.toString();
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
    
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
    Row(children: <Widget>[
      
      SizedBox(width: 10),
      Container (
       height: 45,
       width: 45,
       //color: Colors.black12,
       decoration: BoxDecoration(
        // Box decoration takes a gradient
            gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.3, 0.9],
            colors: _getColorGradient(int.parse(this.cover)%8),
        ),),
        child: Center(child: Text(this.title.substring(0,1),style:TextStyle(color: Colors.white, fontSize: 25))),
      ),
      Container(
          width: MediaQuery.of(context).size.width - 60,
          decoration: BoxDecoration(
            color: Colors.transparent,
            // border : Border(bottom: BorderSide(color: Theme.of(context).dividerColor))
          ),
          child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(this.title, maxLines: 1, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                  SizedBox(height: 3,),
                  Text(this.author, style: TextStyle(fontSize: 14.0)),
                  Text("Last read: " + getTime(), style: TextStyle(fontSize: 13.0, color: Colors.black54)
                )          
              ],
          ),
        ),
      ),
    ],
  ),
  Divider(height: 1,)
  
  ]);

  }
}
