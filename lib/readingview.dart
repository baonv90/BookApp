import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter_html/flutter_html.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
import 'package:epub/epub.dart';
import 'package:shared_preferences/shared_preferences.dart';




class MyReadingView extends StatefulWidget {

  final String id;
  final int currentChap;
  final EpubBook epubBook;
  final List subChapters;
  final int currentSub;

  MyReadingView(this.id, this.epubBook, this.subChapters, this.currentChap, this.currentSub);

  @override
  _MyGetDataState createState() {
    return new _MyGetDataState(this.id, this.epubBook, this.subChapters, this.currentChap, this.currentSub);
  }   
}

class _MyGetDataState extends State<MyReadingView> with SingleTickerProviderStateMixin {
 
  final String id;

  final int currentChap;

  final int currentSub;

  String data = "";

  String title = "";

  List subChapters;

  EpubBook epubBook;

  ScrollController _scrollController;
  _MyGetDataState(this.id, this.epubBook, this.subChapters, this.currentChap, this.currentSub);

  

  // Future<void> loadTableContents(String id) async {
  //   subChapters = [];
  //   // final directory = await getApplicationDocumentsDirectory();
  //   // var path = directory.path + '/book$id.epub';
  //   // File targetFile = new File(path);
  //   // EpubBook epubBook;
  //   // epubBook = await EpubReader.readBook(targetFile.readAsBytesSync());

  //    if(epubBook.Chapters.length >= 1)
  //     {
  //       for(int i = 0; i < epubBook.Chapters.length; i++)
  //       {
  //           if(epubBook.Chapters[i].SubChapters.length > 0)
  //           {
  //             subChapters.add({'name': epubBook.Chapters[i].Title, 'subs': epubBook.Chapters[i].SubChapters});
  //           }
  //           else 
  //           {
  //             subChapters.add({'name': epubBook.Chapters[i].Title, 'subs':[]});
  //           }       
  //       }
  //     }
      
  // }
  
  Future<void> loadBook(String id, int currentChap, int currentSub) async {
    // final directory = await getApplicationDocumentsDirectory();
    // var path = directory.path + '/book$id.epub';
    // File targetFile = new File(path);

    // print("Init Book$id");

    // epubBook = await EpubReader.readBook(targetFile.readAsBytesSync());
    title = epubBook.Title;
    //print(epubBook.Chapters[1]);

     if(currentChap != null)
    {
      if(currentSub != null)
      { 
        data = epubBook.Chapters[currentChap].SubChapters[currentSub].HtmlContent;
      }
      else 
      {
        print("here...");
        //print(epubBook.Chapters);
        // Map<String, EpubTextContentFile> htmlFiles = epubBook.Content.Html;
        // var i = 0;
        // htmlFiles.values.forEach((EpubTextContentFile htmlFile) {
         
        //   print(i.toString() + '...' + htmlFile.Content.length.toString());
        //   i++;
        //   data += htmlFile.Content;
        // });
        // print(data.length);
        data = epubBook.Chapters[currentChap].HtmlContent;

        print(data.length);
       
        //print();

      } 
    }
    else 
    {
      if(epubBook.Chapters[0].SubChapters.length != 0)
      {
         data = epubBook.Chapters[0].SubChapters[0].HtmlContent;
         _currentChap = 0;
         _currentSub = 0;
      }
      else 
      {
         data = epubBook.Chapters[0].HtmlContent;
          _currentChap = 0;
      }
    }
    data = data.replaceAll("<img", "");
    data = data.replaceAll("><a id", "");
    //print(data);
  }

  int _currentChap = 0;
  int _currentSub = 0;
  double offset = 0;
  double textsize = 16.0;
  Color backgroundColor = Colors.white70;
  Color textColor = Colors.black;
  bool _saving = false; 


  void loadingPage() {
    
    setState(() {      
        _saving = true;
        //loadTableContents(this.id);
        loadBook(this.id, _currentChap, _currentSub);
    });
    new Future.delayed(new Duration(seconds: 1), () {
      setState(() {
         _saving = false;
      });
      _scrollController.animateTo(this.offset, duration: Duration(milliseconds: 100), curve: Cubic(10, 100, 100, 10));

    });
  }
  void refreshingPage() {
   
    setState(() {          
        _saving = true;
    });
    new Future.delayed(new Duration(seconds: 1), () {
      setState(() {
         _saving = false;
      });

    });
  }


  _loadCounter() async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print("Loading Offset .................................");
      this.offset = (prefs.getDouble('currentOffset'+ this.id) ?? 0);

    });
  }
  _setCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //this.chap = (prefs.getInt('currentChap'+book.id.toString()) ?? 0) + 1;
       print('Updating Reading Data..................................');
       prefs.setInt('currentChap'+this.id, this._currentChap);
       prefs.setInt('currentSub'+this.id, this._currentSub);
       //prefs.setDouble('currentOffset'+this.id, 0);
       //this.offset = 0;
       print(this._currentChap.toString() + "..." + this._currentSub.toString() + "...");
      // print('Updating Reading Data..................................');
    });
  }
  _resetOffset() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {      
       prefs.setDouble('currentOffset'+this.id, 0);
       this.offset = 0; 
    });
  }
  _setOffset() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {       
       prefs.setDouble('currentOffset' + this.id, _scrollController.offset);
       print('new offset ...........' + prefs.getDouble('currentOffset'+ this.id).toString());
    });
  }

  Animation<double> animation;
  AnimationController controller;

  void initState()
  {

    super.initState();
    _currentChap = this.currentChap;
    _currentSub = this.currentSub; 

    print("Initization " + _currentChap.toString() + '  ' + _currentSub.toString());
    _setCounter();
    _loadCounter();

    setState(() {
       loadingPage();
        _scrollController = new ScrollController(initialScrollOffset: 0.0);
        controller = new AnimationController(vsync: this,
            duration: new Duration(seconds: 4));
        Tween tween = new Tween<double>(begin: 10.0, end: 180.0);
        animation = tween.animate(controller);
        controller.forward();
        //_scrollController.animateTo(1000.0, duration: Duration(seconds: 1), curve: Cubic(10, 2, 12, 3));
    });
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
              opacity: 1,
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
          return  Scaffold(
            appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context, -1);
                },
              ), 
              title: Text(title)),
 
            body: ListView.builder(
            shrinkWrap: true,
            itemCount: subChapters.length,
            itemBuilder: (context, index) {
              return Column (children: _buildList(index));   
            },
            
          ),);
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
        this.offset = 0;
        // setSelectedChap(result);
      }
    }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
       
        elevation: .5,
        title: Text(title, style: TextStyle(fontSize: 16.0),),
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            controller.dispose();
            _setOffset();
            Navigator.pop(context, [_currentChap, _currentSub]);
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
                  setIndexChapters(1, subChapters);
                  
                  //this.offset = 0;
                  refreshingPage();
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                setState(() {
                  setIndexChapters(0, subChapters);
                  //this.offset = 0;
                  refreshingPage();
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

  setIndexChapters(int dir, List chapters)
  {
    //print(chapters);
    int _length = chapters.length;
    int _subLength = chapters[_currentChap]['subs'].length;
    print("length $_length");
    print("Sublength $_subLength");

    if(dir == 0)
    {
      if(_subLength == 0)
      {
        if(_currentChap < _length - 1)
        {
          _currentChap = _currentChap + 1;
          if(chapters[_currentChap]['subs'].length == 0)
          {
            _currentSub = null;
          }
          else
          {
            _currentSub = 0;
          }
        }
      
      }
      else
      {
        if(_currentSub < _subLength - 1)
        {
          _currentChap = _currentChap;
          _currentSub = _currentSub + 1;
        }
        else 
        {
          _currentChap = _currentChap + 1;
          if (chapters[_currentChap]['subs'].length == 0)
          {
            _currentSub = null;
          }
          else
          {
             _currentSub = 0;
          }
        }
      }
    }
    else 
    {
      if(_subLength == 0)
      {
        if(_currentChap > 0)
        {
          _currentChap = _currentChap - 1;
          if(chapters[_currentChap]['subs'].length == 0)
          {
            _currentSub = null;
          }
          else
          {
            _currentSub = chapters[_currentChap]['subs'].length - 1;
          }
        }
      
      }
      else
      {
        if(_currentSub > 0)
        {
          _currentChap = _currentChap;
          _currentSub = _currentSub - 1;
        }
        else 
        {
          if(_currentChap > 0)
          {
            _currentChap = _currentChap - 1;
            if(chapters[_currentChap]['subs'].length == 0)
            {
              _currentSub = null;
            }
            else
            {
              _currentSub = _currentSub = chapters[_currentChap]['subs'].length - 1;
            }
          }
        }
      }
    }
    
    _setCounter();
    _resetOffset();
    loadingPage();

  }

  
  List<Widget> _buildList(int keyIndex) {
    List<Widget> list = [];
    if(subChapters[keyIndex]['subs'].length == 0)
    {
      list.add(
        Container(
          height: 50.0,
          decoration: keyIndex == _currentChap ? BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.black12)), color: Colors.blue): 
          BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.black12)), color: Colors.white), 
          child: InkWell( 
            child: Center( child: Text(subChapters[keyIndex]['name'], style: TextStyle(fontSize: 13.0, height: 1.2),textAlign: TextAlign.center,),),
            onTap: () {
              setState(() {
                 _currentChap = keyIndex;
                 _currentSub = null;
                 _setCounter();
                 _resetOffset();
                 loadingPage();
                 Navigator.pop(context);       
              });
            },   
          ),    
        )
      );
    }
    else
    {
      list.add(
       SizedBox(height: 10,),
      );
      list.add(
        Text(subChapters[keyIndex]['name']),
      );
      list.add(
       SizedBox(height: 10,),
      );
      for (int i = 0; i < subChapters[keyIndex]['subs'].length; i++) {
        list.add(
          new Row(
            children: <Widget>[       
              Container(
                height: 50.0,
                padding: EdgeInsets.only(right: 4.0),
                width: MediaQuery.of(context).size.width,
                decoration: _currentChap == keyIndex && _currentSub == i ? BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.black12)), color: Colors.blue):
                BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.black12)), color: Colors.white), 
                child: InkWell( 
                  child: Center( child: Text(subChapters[keyIndex]['subs'][i].Title, style: TextStyle( height: 1.2, fontSize: 13.0), textAlign: TextAlign.center,),),
                  onTap: () {
                    setState(() {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => MyReadingView(1, keyIndex, i)));
                        _currentChap = keyIndex;
                        _currentSub = i;
                         _setCounter();
                         _resetOffset();
                        loadingPage();
                        //loadBook(this.id, _currentChap, _currentSub);
                         Navigator.pop(context);   
                        //Navigator.pop(context, widget.chap);             
                    });
                  },   
                ),    
              )
            ],
          )
        );
      }
    }

    return list;
  }


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
                                //print(textsize);                   
                            });
                          },
                        ),
                        SizedBox(width: 20.0,),
                        new FlatButton(
                          
                          child: new Text('A+',style: TextStyle(fontSize: 22),),
                          onPressed: () {                  
                            setState(() {
                                this.textsize += 1;
                                //print(textsize);                   
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

// class _chapterList extends StatefulWidget {
//   final int _chap, _sub;
//   final bool _isSelected;
//   _chapterList(this._chap, this._sub, this._isSelected);
//   @override
//   __chapterListState createState() => __chapterListState();
// }

// class __chapterListState extends State<_chapterList> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//        height: 40.0,
//        decoration: widget._isSelected ? BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey)), color: Colors.white) 
//        : BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey)), color: Colors.orange) ,
//        child: Center( child: Text('Chapter ' + widget._chap.toString(), style: TextStyle(fontFamily: 'Charter', fontSize: 17.0),),),    
//     );
//   }
// }


