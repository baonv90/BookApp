import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MenuList extends StatelessWidget {

  final int selectedChap;
  final String title;
  final int chapters;
  //Book book;
  MenuList(this.selectedChap, this.title, this.chapters);
  
  bool _setSelected(index, chap)
  {
    return index == chap ? false: true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       leading: IconButton(
         icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context, -1);
          },
        ), 
        title: Text(title),
     ),
     body: ListView(
       children: new List.generate(chapters, (index) => new _chapterList(index + 1, _setSelected(index + 1, selectedChap)),
     )),
    );
  }
}

class _chapterList extends StatefulWidget {
  final int chap;
  final bool isSelected;

  //_chapterList(int index, bool setSelected);
  //const _chapterList({Key key, this.isSelected, this.chap}) : super(key:key);
  _chapterList(this.chap, this.isSelected);
  @override
  __chapterListState createState() => __chapterListState();
}

class __chapterListState extends State<_chapterList> {
  @override
  Widget build(BuildContext context) {
    return Container(
       height: 40.0,
       decoration: widget.isSelected ? BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey)), color: Colors.white) 
       : BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey)), color: Colors.orange) ,
       child: InkWell( 
         child: Center( child: Text('Chapter ' + widget.chap.toString(), style: TextStyle(fontFamily: 'Charter', fontSize: 17.0),),),
         onTap: () {
           setState(() {
              Navigator.pop(context, widget.chap);             
           });
         },   
       ),    
    );
  }
}