import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'article.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:epub/epub.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html/flutter_html.dart';
import 'reading_view.dart';



class BookInfo extends StatefulWidget {
  
  final Article book;
  BookInfo({Key key, this.book}): super(key : key);

  @override
  _DetailState createState() => _DetailState();
  
}

Future<int> heavyWork(int x) async {
  // some heavy work which takes lot of time and you want it to be on a separate isolate
  await Future.delayed(Duration(seconds: 5));
  print("result" + x.toString());
  return x * x;
}


class _DetailState extends State<BookInfo> {

  Article book;
  String url;
  bool loading = true;
  List subChapters = [];
  int currentChap;
  EpubBook epubBook;
  Directory directory;
  File targetFile;
  int _progressButtonState = 0;
  HttpClient client;
  ScrollController _controller;
  SharedPreferences prefs;

  @override
    void initState() {
      super.initState();
      print('init');
      client = new HttpClient();
      book = widget.book;
      _controller = ScrollController();

        
  }

  //@override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _checkExist();
    //compute(heavyWork,100);    
  }

  
  _checkExist() async
  {
    //int res = await compute(coutingLarge, 10000000000000000);
    prefs = await SharedPreferences.getInstance();
    directory = await getApplicationDocumentsDirectory();
    targetFile = File(directory.path+'/book' + book.id + '.epub');
    if(await targetFile.exists())
    {
      setState(() {
        _progressButtonState = 1;
      });
      _loadCounter();
      Timer(Duration(milliseconds: 1000), () {
        setState(() {
          loadTableContents();
          SchedulerBinding.instance.addPostFrameCallback((_) => {
            _controller.animateTo((this.currentChap != null ? (this.currentChap > 5 ? (this.currentChap - 2) * 40 : 0) : 0).toDouble() , curve: Curves.easeIn, duration: Duration (milliseconds: 500))
          });
        });
      });
    }
    else {
      setState(() {
        _progressButtonState = 0;      
      });
    } 
  }

  
  downloadBook() async {
    _progressButtonState = 1;
    url = book.link;
    //print(url);
    client.getUrl(Uri.parse(url))
      .then((HttpClientRequest request) {
        return request.close();
      })
      .then((HttpClientResponse response) {   
        response.pipe(new File(directory.path+'/book' + book.id + '.epub').openWrite()).whenComplete(() {
        print("Download Done : Book" + book.id);
        _progressButtonState = 2;
        loadTableContents();
       
      });
    });
     
  }        

  
  Future<void>loadTableContents() async {
    print("loading table contents"); 
      try {
        epubBook = await EpubReader.readBook(targetFile.readAsBytesSync()); 
        Map<String, EpubTextContentFile> htmlFiles = epubBook.Content.Html;
        int i = 0;
        htmlFiles.values.forEach((EpubTextContentFile htmlFile) {
          subChapters.add({"chapter" : getTiteElement(htmlFile.Content, i), "data": htmlFile.Content});
          i++;
         });
       


        //print(epubBookRef.)
        //print(list);
        // if(list.length >= 1)
        // {
        //   for(int i = 0; i < list.length; i++)
        //   {
        //     if(list[i].SubChapters.length > 0)
        //     {
        //       subChapters.add({'name': list[i].Title, 'subs': list[i].SubChapters});
        //     }
        //     else 
        //     {
        //       subChapters.add({'name': list[i].Title, 'subs':[]});
        //     }       
        //   }
        // }

        setState(() {
          _progressButtonState = 3; 
          this.loading = false;      
        });
        
      }
      catch(e)
      {
        
        print("error loading file..." + e.toString());
        _settingModalBottomSheet(context, 16);
        setState(() {
          _progressButtonState = 0;
        });
      }  
    //}   
  }

  _loadCounter() async {  
    setState(() {
      this.currentChap = (prefs.getInt('currentChap'+ book.id) ?? 0);
    });
  }
  String getTiteElement(String text, int index)
  {

    String title = "P$index. ";
    if(text.substring(text.indexOf('<title>')) != null)
    {
      title += text.substring(text.indexOf('<title>') + 7, text.indexOf('</title>'));
    }
    
    return title;
  }
  

  _navigateAndDisplayPageView(BuildContext context, int index, bool openNew) async {
    final result = await Navigator.push( context, MaterialPageRoute(builder: (context) => ReadingViewPage(chapters: subChapters, currentChap: index, title: book.title, id: book.id, openNew: openNew))
    );
    print("returning from reading view " + result.toString());
    setState(() {
      currentChap = result;
      _controller.animateTo((currentChap * 40).toDouble() , curve: Curves.easeIn, duration: Duration (milliseconds: 500));
      
    });
  }
  Widget progressButton(int state) {
    switch (state) {
      case 0:
        return Text(
          "Telecharger", style: TextStyle(fontSize: 16),
      );
      case 1:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator( valueColor: AlwaysStoppedAnimation<Color>(Colors.white), strokeWidth: 2,)
            ),
            SizedBox(width: 10,),
            Text("Verification...", style: TextStyle(fontSize: 16)),
          ],
      );
      case 2:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[     
            SizedBox(
              width: 25,
              height: 25,
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Done",
              style: TextStyle(fontSize: 16),
            ),
          ],
      );
      case 3:
        return Text(
          "Lire", style: TextStyle(fontSize: 16),
      );
      default:
        return Text(
          "Telecharger",
          style: TextStyle(fontSize: 16),
        );
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
  void _settingModalBottomSheet(context,textsize){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
              )
            ),
            child: Row(
              children: <Widget>[
                SizedBox(width: 10,),
                Icon(Icons.warning, color:Colors.red),
                SizedBox(width: 10,),
                Expanded(child: Text("We have encoutered some technical issue with this content. Please try again later!", style: TextStyle(fontSize: 16),)),
                SizedBox(width: 10,),
              ],
            ),
          );
        }
      );  
    }
  

  @override
  Widget build(BuildContext context) {

    final appBar = AppBar(
      elevation: 0,
      title: Text('Book Description', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
    );
   
    final topLeft =    
      Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Hero(
              tag: book.title,
              child: Material(
                elevation: 10.0,
                child: Card(
                  color: Colors.black38, 
                  child: //cover == null ? 
                  Container(               
                    height: 150,
                    width: 120,
                  )
                )
              ),
            ),
          ),
          text(book.category, color: Colors.white70, size: 10),
          SizedBox(height: 20,),

        ],
      
    );
    final topRight = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        text(book.title,
            size: 19, isBold: true, color: Colors.white, padding: EdgeInsets.only(top: 16.0, right: 5)),
        text(
          book.author,
          color: Colors.white,
          size: 15,
          padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
        ),
        
        SizedBox(height: 20), 
         MaterialButton(
          animationDuration: Duration(milliseconds: 500),
          elevation: 10,
          onPressed: () {
            setState(() {
              if(_progressButtonState == 0) 
              { 
                _progressButtonState = 1; 
                downloadBook();
                
              }
              else if(_progressButtonState == 3)
              {
                _navigateAndDisplayPageView(context, currentChap, false);
              }
            });
          },
          color: _progressButtonState >= 2 ? Colors.blue : Colors.orange,
          minWidth: 160,
          height: 40,
          child: progressButton(_progressButtonState),
          textColor: Colors.white,
        ),   
        //ProgressButton(id: book.id, url: book.link, parentAction: _updateMyTitle,),
      ],
    );
    
    final topContent = Container(
      height: 250,
      decoration: BoxDecoration(
         gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.5, 1],
            colors: _getColorGradient(0)//_getColorGradient(int.parse(book.id)%8),
         ),
      ),
     
      padding: EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Flexible(flex: 3, child: topLeft),
          Flexible(flex: 4, child: topRight),
        ],
      ),
    );

    // final Map<int, Widget> logoWidgets = const <int, Widget>{
    //   0: Text('Description'),
    //   1: Text('Chapters'),
    // };
    // List<Widget> _buildList(int keyIndex) {
    // List<Widget> list = [];
    // if(subChapters[keyIndex]['subs'].length == 0)
    // {
    //   list.add(
    //     Container(
    //       height: 50.0,
    //       padding: EdgeInsets.all(4.0),
    //       decoration:  keyIndex == currentChap ? 
    //       BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.black12)), color: Colors.blue): 
    //       BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.black12)), color: Colors.transparent), 
    //       child: InkWell( 
    //         child: Center( child: Text(subChapters[keyIndex]['name'], style: TextStyle(fontSize: 13.0, height: 1.2), textAlign: TextAlign.center,),),
    //         onTap: () {
    //           setState(() {
    //             currentChap = keyIndex;
    //             //currentSub = null;
    //             //_navigateAndDisplaySelection(context);
                      
    //           });
    //         },   
    //       ),    
    //     )
    //   );
    // }
    // else
    // {
    //   list.add(
    //    SizedBox(height: 10,),
    //   );
    //   list.add(
    //     Text(subChapters[keyIndex]['name'], style: TextStyle(color: Colors.blueGrey, fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
    //   );
    //   list.add(
    //    SizedBox(height: 10,),
    //   );
    //   for (int i = 0; i < subChapters[keyIndex]['subs'].length; i++) {
    //     list.add(
    //       new Row(
    //         children: <Widget>[       
    //           Container(
    //             height: 50.0,
    //             padding: EdgeInsets.all(4.0),
    //             width: MediaQuery.of(context).size.width,
    //             // color: Colors.transparent,
    //             decoration: currentChap == keyIndex ? //&& currentSub == i ? 
    //             BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.black12)), color: Colors.blue):
    //             BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.black12)), color: Colors.transparent), 
    //             child: InkWell( 
    //               child: Center( child: Text(subChapters[keyIndex]['subs'][i].Title, style: TextStyle( fontSize: 13.0, height: 1.2),textAlign: TextAlign.center,),),
    //               onTap: () {
    //                 setState(() {
    //                     currentChap = keyIndex;
    //                     //currentSub = i;
    //                     //_navigateAndDisplaySelection(context);
    //                      //Navigator.push(context, MaterialPageRoute(builder: (context) => MyReadingView(book.id, keyIndex, i)));
    //                     //Navigator.pop(context, widget.chap);             
    //                 });
    //               },   
    //             ),    
    //           )
    //         ],
    //       )
    //     );
    //   }
    // }

    //   return list;
    // }
   
    
   
    final bottomContent = Flexible(
      
      child: this.loading ? SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Html(data: book.description,
                padding: EdgeInsets.all(16.0),
                backgroundColor: Colors.white12,
                defaultTextStyle: TextStyle(fontSize: 14, height: 1.5, wordSpacing: 1.2, fontWeight: FontWeight.normal , color: Colors.black87),)):
  
        ListView.builder(
            controller: _controller,
            shrinkWrap: true,
            itemCount: subChapters.length,
            itemBuilder: (context, index) {
              return  
              InkWell (
                onTap: () {
                  Timer(Duration(milliseconds: 100), () {
                    _navigateAndDisplayPageView(context, index, currentChap != index); 
                    currentChap = index;

                  });
                },
                child: Container(
                  
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.black12)),  color: index!=currentChap ? Colors.transparent: Colors.blue), 
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 12.0, bottom: 12.0),
                    child: Text(getTiteElement(subChapters[index]["data"], index), style: TextStyle(fontSize: 13),),
                  ),
                )
              );
            },
        )     
    );

    return Scaffold(
      appBar: appBar,
      body: Column(
        children: <Widget>[
          topContent,bottomContent],
      ),
    );
  }
  text(String data, {Color color = Colors.black87, num size = 13,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
      bool isBold = false}) => 
      Padding(
        padding: padding,
        child: Text(
          data.length > 60 ? data.substring(0, 57) + "..." : data,
          maxLines: 3,
          style: TextStyle(
              color: color,
              fontSize: size.toDouble(),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
      ),
  );
}

