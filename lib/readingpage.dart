import 'dart:async';
import 'package:flutter/material.dart';
import 'package:freebook/data.dart';
import 'package:freebook/menu.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';



class MyGetData extends StatefulWidget {

  final Book book;

  MyGetData(this.book);

  @override
  _MyGetDataState createState() {
    return new _MyGetDataState(book);
  }   
}

class _MyGetDataState extends State<MyGetData> with SingleTickerProviderStateMixin {
 
  String data = 'loading...';

  Book book;

  ScrollController _scrollController;


  _MyGetDataState(Book book) 
  {
    this.book = book;
  }



  Future<String> loadLocal(int id, int chap) async {

    print('loading $chap');
    String path = "res/";
    if(id < 5)
    {
      path = path + 'novel/' + id.toString() + '/$chap.htm';
    }
    else 
    {
      path = path + 'shortstories/' + (id - 4).toString() + '/$chap.htm';;
    }
    
    data = await rootBundle.loadString(path); //.then((onValue) => (data = onValue)); 
    var index = data.indexOf("<a name=\"Chapter");
    
    if(index != -1)
    {

      data = data.substring(index);
      var _index  = data.indexOf('<p>');
      data = data.substring(_index);
    }
    return data;
   
  }
  void setSelectedChap(index) {
    setState(() {   
      this.chap = index;
      loadingPage();
    });
   
  }


  int chap = 1; 
  double offset = 0;
  double textsize = 16.0;
  Color backgroundColor = Colors.white70;
  Color textColor = Colors.black;
  
  

  bool _saving = false; 
  void loadingPage() {
    _setCounter();
    setState(() {      
        _saving = true;
        loadLocal(book.id, this.chap);
        //print(setting.getContent());        
    });
    new Future.delayed(new Duration(seconds: 1), () {
      setState(() {
         _saving = false;
      });
      _scrollController.animateTo(this.offset, duration: Duration(milliseconds: 100), curve: Cubic(10, 100, 100, 10));

    });
  }
  _loadCounter() async {
    print('loading counter');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print('****' + prefs.getInt('currentChap'+ book.id.toString()).toString());
      print('oooooo' + prefs.getDouble('currentOffset'+ book.id.toString()).toString());
      this.chap = (prefs.getInt('currentChap'+ book.id.toString()) ?? 1);
      this.offset = (prefs.getDouble('currentOffset'+ book.id.toString()) ?? 0);
      loadingPage();
    });
  }
  _setCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //this.chap = (prefs.getInt('currentChap'+book.id.toString()) ?? 0) + 1;
       print('-----' + prefs.getInt('currentChap'+ book.id.toString()).toString());
       prefs.setInt('currentChap'+book.id.toString(), this.chap);
       prefs.setDouble('currentOffset'+book.id.toString(), 0);

    });
  }
  _setOffset() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //this.chap = (prefs.getInt('currentChap'+book.id.toString()) ?? 0) + 1;
       
       prefs.setDouble('currentOffset'+book.id.toString(), _scrollController.offset);
       print('oooooo' + prefs.getDouble('currentOffset'+ book.id.toString()).toString());


    });
  }

  Animation<double> animation;
  AnimationController controller;
  void initState()
  {
    super.initState();
    _loadCounter();
    _scrollController = new ScrollController(initialScrollOffset: 0.0);
    controller = new AnimationController(vsync: this,
        duration: new Duration(seconds: 4));
    Tween tween = new Tween<double>(begin: 10.0, end: 180.0);
    animation = tween.animate(controller);
    controller.forward();
    //_scrollController.animateTo(1000.0, duration: Duration(seconds: 1), curve: Cubic(10, 2, 12, 3));
  }
  
  @override
  void dispose() {
    print('dispose: $this');
    
    super.dispose();
   
    

  }
  
  List<Widget> _buildForm(BuildContext context) {
    Form form = new Form(
       
        child: ListView(
          
          controller: _scrollController,
          children: <Widget>[
            Column(
              
              children: <Widget>[
                
                Html(data: data,
                padding: EdgeInsets.all(26.0),
                backgroundColor: backgroundColor,
                defaultTextStyle: TextStyle(fontFamily: 'Charter', fontSize: textsize, color: textColor),)
              ],
            )
          ],
        ),

      );
      
      var l = new List<Widget>();
      l.add(form);
      if (_saving) {
        var modal = new Stack(
          children: [
            new Opacity(
              opacity: .95,
              child: const ModalBarrier(dismissible: false, color: Colors.white),
            ),
            // Text('loading'),
            new Center(
              
              child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation(Colors.black26)),
            ),
          ],
        );
        l.add(modal);
      }
      return l;
      
      
  }

  _navigateAndDisplaySelection(BuildContext context) async
    {
      final result = await Navigator.push(context, PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return  MenuList(chap, book.title, book.chapters);
        },
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
          return SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: new SlideTransition(
              position: new Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(0.0, 1.0),
              ).animate(secondaryAnimation),
              child: child,
            ),
          );
        },
      ));
      if(result != -1)
      {
        //print('&&&&&' + result.toString());
        this.offset = 0;
        setSelectedChap(result);
      }
      //print(result.toString());
      // Scaffold.of(context)
      // ..removeCurrentSnackBar()
      // ..showSnackBar(SnackBar(content: Text("$result")));

    }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
       
        elevation: .5,
        title: Text('Chapter ' + '$chap', style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),),
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            _setOffset();
            Navigator.pop(context, this.chap);
          },
        ),  
      ),
     
      body: Stack(
        children: _buildForm(context),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(icon: Icon(Icons.view_list), onPressed: (){

              _navigateAndDisplaySelection(context);

              // _listChaptersModalBottomSheet(context,book.chapters,chap);
            },),
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                setState(() {
                  if(chap > 1)
                  {
                    chap = chap - 1;
                  }
                  this.offset = 0;
                  loadingPage();
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                setState(() {
                  chap = chap + 1;
                  this.offset = 0;
                  loadingPage();
                });
              },
            ),
            // IconButton(icon: Icon(Icons.bookmark), onPressed: (){
            //   _setOffset();
            //   //print(_scrollController.offset);
            // },),
            IconButton(icon: Icon(Icons.format_size), onPressed: (){
               _settingModalBottomSheet(context,textsize);
            },),
          ],
        ),
      ),
    );
  }

  

  List<_chapterList> list = [];
  bool _setSelected(index, chap)
  {
    return index == chap ? false: true;
  }

  void _listChaptersModalBottomSheet(context,chapters,chap) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column( children: new List.generate(chapters, (index) => new _chapterList(index + 1, _setSelected(index + 1, chap))))),
        );
        // return ListView(           
        //     padding: EdgeInsets.all(16.0),
        //     children: new List.generate(chapters, (index) => new _chapterList(index + 1, _setSelected(index + 1, chap))),
        // );  
      }
    );
  }

 

//  }
void _settingModalBottomSheet(context,textsize){

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          
          color: Colors.white,
          child : new Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
              )
            ),
            child: new Wrap(
            children: <Widget>[
              Center(
                child: 
              Column(
                
                children: <Widget>[
                    SizedBox(height: 15.0,),
                    Row(     
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,                
                      children: <Widget>[
                        new Text('Font size:', style: TextStyle(fontFamily: 'Charter', fontSize: 17.0),),
                        SizedBox(width: 20.0,),
                        new FlatButton(
                          child: new Text('A-',style: TextStyle(fontSize: 15),),
                          onPressed: () {
                            setState(() {
                                this.textsize -= 1;
                                print(textsize);                   
                            });
                          },
                        ),
                        SizedBox(width: 20.0,),
                        new FlatButton(
                          
                          child: new Text('A+',style: TextStyle(fontSize: 22),),
                          onPressed: () {                  
                            setState(() {
                                this.textsize += 1;
                                print(textsize);                   
                            });               
                          },
                        ),
                    ],),
                
                  SizedBox(height: 10.0,),
                  Row(
                    
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                  
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          height: 60,
                          width: 80,
                          decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(10.0), border: Border.all()), 
                          child: Center(
                            child: Text('text', style: TextStyle(color: Colors.black),),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            this.textColor = Colors.black;
                            this.backgroundColor = Colors.white70;            
                          });
                        },
                      ),
                      SizedBox(width: 20.0,),
                      InkWell(
                        child: Container(
                          height: 60,
                          width: 80,
                          decoration: BoxDecoration(color: Color.fromRGBO(252, 234, 199, 1), borderRadius: BorderRadius.circular(10.0)),
                          child: Center(
                            child: Text('text', style: TextStyle(color: Colors.black),),
                          ), 
                        ),
                        onTap: () {
                          setState(() {
                            this.textColor = Colors.black;
                            this.backgroundColor = Color.fromRGBO(252, 234, 199, 1);       
                          });
                          
                        },
                      ),
                      SizedBox(width: 20.0,),
                      InkWell(
                        child: Container(
                          height: 60,
                          width: 80,
                          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10.0)), 
                          child: Center(
                            child: Text('text', style: TextStyle(color: Colors.white),),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            this.textColor = Colors.white;
                            this.backgroundColor = Colors.black;       
                          });
                        },
                      ),
                      
                    ],
                  ),
                   SizedBox(height: 40.0,),
            ],
            ),),

           
              
              
            ],
            ),
        ));
      }
    );
}



}

class _chapterList extends StatefulWidget {
  final int _chap;
  final bool _isSelected;
  _chapterList(this._chap, this._isSelected);
  @override
  __chapterListState createState() => __chapterListState();
}

class __chapterListState extends State<_chapterList> {
  @override
  Widget build(BuildContext context) {
    return Container(
       height: 40.0,
      //  padding: EdgeInsets.all(16.0),
       decoration: widget._isSelected ? BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey)), color: Colors.white) 
       : BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey)), color: Colors.orange) ,
       child: Center( child: Text('Chapter ' + widget._chap.toString(), style: TextStyle(fontFamily: 'Charter', fontSize: 17.0),),),    
    );
  }
}



// class MyGetData extends StatelessWidget {
//   final Book book;

//   String data = 'no data';
//   Future<String> loadLocal() async {
//     var response = await rootBundle.loadString('res/1.txt').then((onValue) => (data = onValue)); 
//     print(data); 
//     return data;  
//   }  
//   // var loader = new LocalLoader();

//   MyGetData(this.book);
//   @override
//   Widget build(BuildContext context) {
//     final appBar = AppBar(
//       elevation: .5,
//       title: Text("Books"),
//       actions: <Widget>[
//         IconButton(
//           icon: Icon(Icons.search),
//           onPressed: () {
//             data = 'receiving data';
//           },
//         )
//       ],
//     );

   
//     final bottomContent = Container(
//       height: 280.0,
//       child: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Text(
//           '$data 565',
//           style: TextStyle(fontSize: 13.0, height: 1.5),
//         ),
//       ),
//     );
    
//     return Scaffold(
//       appBar: appBar,
//       body: Column(
//         children: <Widget>[bottomContent],
//       ),      
//     );
//   }
// }


  
/* Map<String, dynamic> _decodeEpub(String uri) {
  try {
    print('decode epub...');
    File targetFile = new File(uri);
    List<int> bytes = targetFile.readAsBytesSync();
    String content = '';
    List<Map> chapters = <Map>[];

    // Opens a book and reads all of its content into the memory
    EpubBook epubBook = EpubReader.readBookSync(bytes);

//    content = epubBook.Content.toString();
    epubBook.Chapters?.forEach((EpubChapter chapter) {
      if (null != chapter) {
        dom.Document doc = parse(chapter.HtmlContent);
        String text = doc.body.text;
        chapters.add({
          'title': chapter.Title,
          'offset': content?.length,
          'length': text?.length
        });
        content += text;
      }

//      dom.Document document = parse(html);
//      dom.Element body = document.body;
//    return hm.convert(body.outerHtml);
//    return body.outerHtml;
//      return body.text;
    });
    return {'content': content, 'chapters': jsonEncode(chapters).toString()};
  } catch (e) {
    print('decode epub failed, e: $e');
    throw e;
  }
}
*/

