// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:freebook/component/progressbutton.dart'; 
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:epub/epub.dart';
// import 'package:freebook/readingview.dart';
// import 'downloaded.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_html/flutter_html.dart';


// class BookInfo extends StatefulWidget {
  
//   final Downloaded book;
  
//   BookInfo(this.book);

//   @override
//   _DetailState createState() => _DetailState(this.book);
  
// }

// class _DetailState extends State<BookInfo> {

//   Downloaded book;
//   String url;
//   bool loading = true;
//   List subChapters = [];
//   int currentChap;
//   int currentSub;
//   EpubBook epubBook;
//   EpubBookRef epubBookRef;


//   _DetailState(Downloaded book){
//     this.book = book;
//   }
//   @override
//     void initState() {
//       super.initState();  
//   }

//   Future<void> loadTableContents() async {
//     print("Loading Table Contents .................................");
//     final directory = await getApplicationDocumentsDirectory();
//     var path = directory.path + '/book'+ book.id +'.epub';
//     File targetFile = new File(path);
//     try {
//       print("Accesing file...");
//       epubBookRef = await EpubReader.openBook(targetFile.readAsBytesSync());
//       epubBook = await EpubReader.readBook(targetFile.readAsBytesSync());
//       //cover = null; //epubBookRef.readCover();
//       var list = await epubBookRef.getChapters();
      
//       if(list.length >= 1)
//       {
//         for(int i = 0; i < list.length; i++)
//         {
//             if(list[i].SubChapters.length > 0)
//             {
//               subChapters.add({'name': list[i].Title, 'subs': list[i].SubChapters});
//             }
//             else 
//             {
//               subChapters.add({'name': list[i].Title, 'subs':[]});
//             }       
//         }
//       }
//       this.loading = !this.loading; 
//     }
//     catch(e)
//     {
//       print("error loading file...");
//       print(e);
//     }   
//   }

//   _loadCounter() async {
    
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       this.currentChap = (prefs.getInt('currentChap'+ book.id) ?? null);
//       this.currentSub = (prefs.getInt('currentSub'+ book.id) ?? null);
//       //var offset = (prefs.getDouble('currentOffset'+ book.id) ?? 0);

//     });
//   }
//    _navigateAndDisplaySelection(BuildContext context) async {
//     // Navigator.push returns a Future that will complete after we call
//     // Navigator.pop on the Selection Screen!
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => MyReadingView(book.id, epubBook, subChapters, currentChap, currentSub))
//     );
//     print("returning from reading view " + result.toString());
//     setState(() {
//         currentChap = result[0];
//         currentSub = result[1];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final appBar = AppBar(
//       elevation: 0,
//       title: Text('Description', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),),
    
//     );
//     _updateMyTitle(String text) {
//       if(text == "Update")
//       {
//         setState(() {
//           try {
//             _loadCounter();
//             loadTableContents();
//           }
//           catch (e) {
//             // print("update parenting...");
//             print(e);
//           }
//         });
//       }
//       else 
//       {
//         setState(() {
//           print(this.currentChap.toString() + "..." + this.currentSub.toString() + "...");
//           _navigateAndDisplaySelection(context);

//         });
//       }
//     }
//     List<Color> _getColorGradient (int rand)
//     {
//       switch(rand) {
//       case 1: return [const Color(0xffcc2b5e), const Color(0xff753a88)]; break;
//       case 2: return [const Color(0xff42275a), const Color(0xff734b6d)]; break;
//       case 3: return [const Color(0xff2c3e50), const Color(0xffbdc3c7)]; break;
//       case 4: return [const Color(0xff06beb6), const Color(0xff06aab1)]; break;
//       case 5: return [const Color(0xff614385), const Color(0xff516395)]; break;
//       case 6: return [const Color(0xff000428), const Color(0xff004e92)]; break;
//       case 7: return [const Color(0xff4568dc), const Color(0xffb06ab3)]; break;
//       case 8: return [const Color(0xff2b5876), const Color(0xff4e4376)]; break;

//       default: return [const Color(0xff43cea2), const Color(0xff185a9d)]; break;
      
//       }
      
//     }
//     final topLeft =    
//       Column(
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Hero(
//               tag: book.title,
//               child: Material(
//                 elevation: 10.0,
//                 // child:  FutureBuilder<epub.Image>(
//                 //   future: cover,
//                 //   builder: (context, snapshot) {
//                 //     if (snapshot.hasData) {
//                 //       return Column(
//                 //         children: <Widget>[
//                 //           Widgets.Image.memory(image.encodePng(snapshot.data)),
//                 //         ],
//                 //       );
//                 //     } else if (snapshot.hasError) {
//                 //       return Text("${snapshot.error}");
//                 //     }
//                 //     return Container();
//                 //   },
//                 // ),
//                 child: Card(
//                   color: Colors.black38, 
//                   child: //cover == null ? 
//                   Container(               
//                     height: 150,
//                     width: 120,
//                     //child: Widgets.Image.memory(coverImage),
//                   )//: 
//                   // Container(
//                   //   height: 150,
//                   //   child:  FutureBuilder<epub.Image>(
//                   //   future: cover,
//                   //   builder: (context, snapshot) {
//                   //     if (snapshot.hasData) {
//                   //       return Container(
//                   //         child: Widgets.Image.memory(image.encodePng(snapshot.data)),
//                   //       );
//                   //     } else if (snapshot.hasError) {
//                   //       return Text("${snapshot.error}");
//                   //     }
//                   //     return Container();
//                   //   },
//                   //),
//                   //),
//                 )
//               ),
//             ),
//           ),
//           text(book.category, color: Colors.white70, size: 15),
//           SizedBox(height: 20,),

//         ],
      
//     );
//     final topRight = Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         text(book.title,
//             size: 19, isBold: true, color: Colors.white, padding: EdgeInsets.only(top: 16.0, right: 5)),
//         text(
//           book.author,
//           color: Colors.white,
//           size: 15,
//           padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
//         ),
        
//         SizedBox(height: 20),    
//         ProgressButton(id: book.id, url: book.link, parentAction: _updateMyTitle,),
//       ],
//     );
    
//     final topContent = Container(
//       height: 250,
//       decoration: BoxDecoration(
//          gradient: LinearGradient(
//             // Where the linear gradient begins and ends
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             // Add one stop for each color. Stops should increase from 0 to 1
//             stops: [0.5, 1],
//             colors: _getColorGradient(int.parse(book.id)%8),
//          ),
//       ),
     
//       padding: EdgeInsets.only(bottom: 10.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget> [
//           Flexible(flex: 3, child: topLeft),
//           Flexible(flex: 4, child: topRight),
//         ],
//       ),
//     );

//     final Map<int, Widget> logoWidgets = const <int, Widget>{
//       0: Text('Description'),
//       1: Text('Chapters'),
//     };
//     List<Widget> _buildList(int keyIndex) {
//     List<Widget> list = [];
//     if(subChapters[keyIndex]['subs'].length == 0)
//     {
//       list.add(
//         Container(
//           height: 50.0,
//           padding: EdgeInsets.all(4.0),
//           decoration:  keyIndex == currentChap ? BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.black12)), color: Colors.blue): 
//           BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.black12)), color: Colors.white), 
//           child: InkWell( 
            
//             child: Center( child: Text(subChapters[keyIndex]['name'], style: TextStyle(fontSize: 13.0, height: 1.2), textAlign: TextAlign.center,),),
//             onTap: () {
//               setState(() {
//                 currentChap = keyIndex;
//                 currentSub = null;
//                 _navigateAndDisplaySelection(context);
                      
//               });
//             },   
//           ),    
//         )
//       );
//     }
//     else
//     {
//       list.add(
//        SizedBox(height: 10,),
//       );
//       list.add(
//         Text(subChapters[keyIndex]['name'], style: TextStyle(color: Colors.blueGrey, fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
//       );
//       list.add(
//        SizedBox(height: 10,),
//       );
//       for (int i = 0; i < subChapters[keyIndex]['subs'].length; i++) {
//         list.add(
//           new Row(
//             children: <Widget>[       
//               Container(
//                 height: 50.0,
//                 padding: EdgeInsets.all(4.0),
//                 width: MediaQuery.of(context).size.width,
//                 // color: Colors.transparent,
//                 decoration: currentChap == keyIndex && currentSub == i ? BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.black12)), color: Colors.blue):
//                 BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.black12)), color: Colors.white), 
//                 child: InkWell( 
//                   child: Center( child: Text(subChapters[keyIndex]['subs'][i].Title, style: TextStyle( fontSize: 13.0, height: 1.2),textAlign: TextAlign.center,),),
//                   onTap: () {
                    
//                     setState(() {
                      
//                         currentChap = keyIndex;
//                         currentSub = i;

//                         _navigateAndDisplaySelection(context);
                       
//                          //Navigator.push(context, MaterialPageRoute(builder: (context) => MyReadingView(book.id, keyIndex, i)));
//                         //Navigator.pop(context, widget.chap);             
//                     });
//                   },   
//                 ),    
//               )
//             ],
//           )
//         );
//       }
//     }

//     return list;
//   }
   


//     final bottomContent = Flexible(
//       // height: MediaQuery.of(context).size.height - 350,
//       // color: Colors.white,
//       child: this.loading ? SingleChildScrollView(
//         padding: EdgeInsets.all(4.0),
//         child: Html(data: book.description,
//                 padding: EdgeInsets.all(8.0),
//                 backgroundColor: Colors.white12,
//                 defaultTextStyle: TextStyle(fontSize: 16, height: 1.2, wordSpacing: 1, fontWeight: FontWeight.w100 , color: Colors.black87),)):
              
//         // child:  Text(
//         //   book.description,
//         //   style: TextStyle(fontSize: 16.0, fontFamily: "roboto", height: 1.5),
//         // )): 
//        ListView.builder(
//             shrinkWrap: true,
//             itemCount: subChapters.length,
//             itemBuilder: (context, index) {
//               return Column (children: _buildList(index));   
//             },
//         )     
//     );
    
//     return Scaffold(
//       appBar: appBar,
//       body: Column(
//         children: <Widget>[
//           topContent,bottomContent],
//       ),      
//     );

    
//   }
//   text(String data,
//           {Color color = Colors.black87,
//           num size = 14,
//           EdgeInsetsGeometry padding = EdgeInsets.zero,
//           bool isBold = false}) =>
//       Padding(
//         padding: padding,
//         child: Text(
//           data,
//           style: TextStyle(
//               color: color,
//               fontSize: size.toDouble(),
//               fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
//         ),
//     );
// }

