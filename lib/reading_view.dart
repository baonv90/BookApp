import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingViewPage extends StatefulWidget {
  final List chapters;
  final int currentChap;
  final String title;
  final String id;
  final bool openNew;

  ReadingViewPage({Key key, this.chapters, this.currentChap, this.title, this.id, this.openNew}) : super(key: key);

  @override
  _ReadingViewPageState createState() => _ReadingViewPageState();
}

class _ReadingViewPageState extends State<ReadingViewPage> {

String data = "";
int currentChapter;
Color backgroundColor = Colors.white70;
Color textColor = Colors.black;
double textsize = 16.0;
SharedPreferences prefs;
double offset;
ScrollController _controller;


@override
void initState()
{
  super.initState();
  print("init...");
  _controller = ScrollController();
  //initiatePreferences();

}

void didChangeDependencies(){
  super.didChangeDependencies();
  initiatePreferences();
  currentChapter = widget.currentChap;
  getData();


}
void initiatePreferences() async {
  prefs = await SharedPreferences.getInstance();
  if(widget.openNew)
  {
    _resetOffset();
  }
}

_loadOffset() {  
  setState(() {
    this.offset = (prefs.getDouble('currentOffset${widget.id}') ?? 0);
  });
}
_setCounter() {
  setState(() {
    prefs.setInt('currentChap'+ widget.id, this.currentChapter);
  });
}
_resetOffset() async {
  setState(() {      
    prefs.setDouble('currentOffset'+ widget.id, 0);
    this.offset = 0; 
  });
}
_setOffset() async {
  setState(() {       
    prefs.setDouble('currentOffset' + widget.id, _controller.offset);
    print('new offset ...........' + prefs.getDouble('currentOffset'+ widget.id).toString());
  });
}
getData(){
  data = "";
  Timer(Duration(milliseconds: 500), (){
   setState(() {  
      data = widget.chapters[currentChapter]["data"].replaceAll("><a id", "");
      _loadOffset();

      SchedulerBinding.instance.addPostFrameCallback((_) => {
        _controller.animateTo(this.offset, duration: Duration(milliseconds: 100), curve: Cubic(10, 100, 100, 10))
        //print("loading done..." + data.length.toString() + this.offset.toString())
      });
   });
  });
}

// String getTiteElement(String text, int index)
// {

//   String title = "P$index. ";
//   if(text.substring(text.indexOf('<title>')) != null)
//   {
//     title += text.substring(text.indexOf('<title>') + 7, text.indexOf('</title>'));
//   }
  
//   return title;
// }

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
              title: Text(widget.title)),
 
            body: ListView.builder(
            //controller: _menuController,
            shrinkWrap: true,
            itemCount: widget.chapters.length,
            itemBuilder: (context, index) {
              return InkWell (
                onTap: () {
                  setState(() {
                    currentChapter = index;
                    getData();
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.black12)), color: index!= currentChapter ? Colors.transparent: Colors.blue), 
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 12.0, bottom: 12.0),
                    child: Text(widget.chapters[index]["chapter"], style: TextStyle(fontSize: 16),),

                  ),
                )
              );   
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
      //_menuController.animateTo(100, duration: Duration(milliseconds: 100), curve: Cubic(10, 100, 100, 10))

      if(result != -1)
      {
       _resetOffset();
      }
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
              Center( child: 
                Column(children: <Widget>[
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
                            });
                          },
                        ),
                        SizedBox(width: 20.0,),
                        new FlatButton(
                          
                          child: new Text('A+',style: TextStyle(fontSize: 22),),
                          onPressed: () {                  
                            setState(() {
                              this.textsize += 1;
                            });               
                          },
                        ),
                    ],
                  ),
                
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
            ),),],),
        ));
      }
    );
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar( 
          elevation: .5,
          title: Text(widget.title, style: TextStyle(fontSize: 16.0),),
          leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _controller.dispose();
              //_menuController.dispose();
              _setOffset();
              _setCounter();
              Navigator.pop(context, currentChapter);
            },
          ),  
        ),
      
        body:  data != "" ? ListView(
          controller: _controller,
          children: <Widget>[
            Column(
              children: <Widget>[
                Html(data: data, //.replaceAll("<img", "").replaceAll("><a id", ""),
                padding: EdgeInsets.all(30.0),
                backgroundColor: backgroundColor,
                defaultTextStyle: TextStyle(fontFamily: '', fontSize: textsize, color: textColor),)   
              ],
            )
          ],
        ) : Center(child: CircularProgressIndicator( valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), strokeWidth: 2,)),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(icon: Icon(Icons.view_list), onPressed: (){

                _navigateAndDisplaySelection(context);
                // Timer(Duration(milliseconds: 500), (){

                //   //_menuController.animateTo(100, duration: Duration(milliseconds: 100), curve: Cubic(10, 100, 100, 10));

                // });
                // _listChaptersModalBottomSheet(context,book.chapters,chap);
              },),
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  setState(() {
                    if(currentChapter > 0) {
                       currentChapter --;
                       _resetOffset();
                       getData();
                    }
                    //setIndexChapters(1, subChapters);
                    
                    //this.offset = 0;
                    //refreshingPage();
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  setState(() {
                    if(currentChapter < widget.chapters.length) {
                       currentChapter ++;
                       _resetOffset();
                       getData();
                    }
                  });
                },
              ),
              // IconButton(icon: Icon(Icons.bookmark), onPressed: (){
              //   _setOffset();
              //   //print(_scrollController.offset);
              // },),
              IconButton(icon: Icon(Icons.format_size), onPressed: (){
                _settingModalBottomSheet(context, textsize);
              },),
            ],
          ),
        ),
      );

  }

}

