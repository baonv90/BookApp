import 'data.dart';
import 'readingpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Detail extends StatefulWidget {
  
  final Book book;
  
  Detail(this.book);

  @override
  _DetailState createState() {
    return new _DetailState(book);
  }
}

class _DetailState extends State<Detail> {

  Book book;

  _DetailState(Book book){
    this.book = book;
  }

  // Storage setting = new Storage();

  String _getRecentBooksList (String list, String newBook) {

    if(list == null)
    {
      return newBook;
    }
    else {
      if(list.contains(newBook)){
        return list.replaceAll(newBook,'') + newBook;
      }
      else {
        return list + newBook;
      }
    }
  }
  
  _setCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if(prefs.getString('recentBooks').toString() != null)
      {

       prefs.setString('recentBooks',  _getRecentBooksList(prefs.getString('recentBooks'), book.id.toString()));
       print('----- recent ------' + prefs.getString('recentBooks'));
      }

    });
  }


  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      elevation: 0,
      title: Text('Book description', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, fontFamily: 'charter'),),
    
    );

    final topLeft = 
      // color: Colors.white,
      // width: 300,
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
                  child: Container(
                    height: 180,
                  ),
                ),
                // child: Image(
                //   height: 180,
                //   image: AssetImage(book.image),
                //   fit: BoxFit.cover,

                // ),
              ),
            ),
          ),
          // text('${book.title}', color: Colors.black87, size: 18),
          text('${book.chapters} Chapters', color: Colors.black38, size: 15),
          SizedBox(height: 20,),
          // Material(8
          //   elevation: 10.0,
          //   borderRadius: BorderRadius.circular(15.0),
          //   child: MaterialButton(
          //     onPressed: () {
          //       _setCounter();
          //       Navigator.push(context, MaterialPageRoute(builder: (context) => MyGetData(book)));
          //     },
          //     minWidth: 80.0,
          //     child: text('Read now', color: Colors.black, size: 15),
          //   ),
          // )
          
        ],
      
    );
    final topRight = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        text(book.title,
            size: 19, isBold: true, padding: EdgeInsets.only(top: 16.0)),
        text(
          'by ${book.writer}',
          color: Colors.black54,
          size: 14,
          padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
        ),
        text(
          'rating: 8/10 ',
          color: Colors.black54,
          size: 14,
          padding: EdgeInsets.only(top: 0.0, bottom: 4.0),
        ),
        SizedBox(height: 25),
        
        // SizedBox(height: 32.0),
        Material(
          color: Colors.blueAccent,
          elevation: 10.0,
          borderRadius: BorderRadius.circular(15.0),
          child: MaterialButton(
            // color: Colors.blue,
            onPressed: () {
              _setCounter();
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyGetData(book)));
            },
            minWidth: 100.0,
            child: text('Read now', color: Colors.white, size: 17),
          ),
        )
      ],
    );
    
    final topContent = Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Flexible(flex: 3, child: topLeft),
          Flexible(flex: 4, child: topRight),
        ],
      ),
    );
    final bottomContent = Flexible(
      // height: 310.0,
      // color: Colors.white,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          book.description,
          style: TextStyle(fontSize: 17.0, fontFamily: "charter", height: 1.5),
        ),
      ),
    );
    
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: <Widget>[
        topContent,bottomContent],
      ),      
    );
  }
  text(String data,
          {Color color = Colors.black87,
          num size = 14,
          EdgeInsetsGeometry padding = EdgeInsets.zero,
          bool isBold = false}) =>
      Padding(
        padding: padding,
        child: Text(
          data,
          style: TextStyle(
              color: color,
              fontSize: size.toDouble(),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
    );
}

// class Detail extends StatelessWidget {
//   final Book book;

//   Detail(this.book);

//   // Storage setting = new Storage();
//   // _setCounter() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   setState(() {
//   //     //this.chap = (prefs.getInt('currentChap'+book.id.toString()) ?? 0) + 1;
//   //      print('-----' + prefs.getInt('currentChap'+ book.id.toString()).toString());
//   //      prefs.setInt('currentChap'+book.id.toString(), this.chap);
//   //      prefs.setDouble('currentOffset'+book.id.toString(), 0);

//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final appBar = AppBar(
//       elevation: .5,
//       title: Text("Detail"),
//       // actions: <Widget>[
//       //   IconButton(
//       //     icon: Icon(Icons.search),
//       //     onPressed: () {

//       //     },
//       //   )
//       // ],
//     );

//     final topLeft = Column(
//       children: <Widget>[
//         Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Hero(
//             tag: book.title,
//             child: Material(
//               elevation: 10.0,
//               child: Image(
//                 image: AssetImage(book.image),
//                 fit: BoxFit.cover,

//               ),
//             ),
//           ),
//         ),
//         text('${book.chapters} Chapters', color: Colors.black38, size: 14)
        
//       ],
//     );
//     final topRight = Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         text(book.title,
//             size: 16, isBold: true, padding: EdgeInsets.only(top: 16.0)),
//         text(
//           'by ${book.writer}',
//           color: Colors.black54,
//           size: 12,
//           padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
//         ),
        
//         SizedBox(height: 32.0),
//         Material(
//           elevation: 5.0,
//           borderRadius: BorderRadius.circular(20.0),
//           child: MaterialButton(
//             onPressed: () {
//               //print(setting.getContent());
//               //print(book.id);
//               //print(setting.getContent()['as']);
//               //setting.writeToFile(book.id.toString(), "1", "0");
//               //print(setting.fileExists);
              
//               Navigator.push(context, MaterialPageRoute(builder: (context) => MyGetData(book)));
//             },
//             minWidth: 80.0,
//             child: text('Read now', color: Colors.black, size: 14),
//           ),
//         )
//       ],
//     );
    
//     final topContent = Container(
//       color: Theme.of(context).primaryColor,
//       padding: EdgeInsets.only(bottom: 16.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Flexible(flex: 2, child: topLeft),
//           Flexible(flex: 3, child: topRight),
//         ],
//       ),
//     );
//     final bottomContent = Container(
//       height: 280.0,
//       child: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Text(
//           book.description,
//           style: TextStyle(fontSize: 13.0, height: 1.5),
//         ),
//       ),
//     );
    
//     return Scaffold(
//       appBar: appBar,
//       body: Column(
//         children: <Widget>[topContent,bottomContent],
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