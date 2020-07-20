import 'package:flutter/material.dart';
import 'article.dart';
import 'downloaded.dart';
import 'mostread.dart';
import 'dart:convert';
import 'package:xml2json/xml2json.dart'; 
import 'package:http/http.dart' as http;
import 'bookinfo.dart';
import 'bookfromauthor.dart';
import 'dart:async';


class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
    
    String urlTop = "https://www.ebooksgratuits.com/opds/feed.php?mode=rate&page=0";
    String urlRecent = "https://www.ebooksgratuits.com/opds/feed.php?mode=recent&page=0";
    String urlSearch = "https://www.ebooksgratuits.com/opds/feed.php?mode=search&page=0";

    
    List<Article>topList=List();
    List<Article>recentList=List();
    List<Article>searchList=List();
    List<Downloaded>downloadList = List();

    bool isLoadingTop = true;
    bool isLoadingRecent = true;
    bool isLoadingSearch = true;
    bool isLoadingDownloaded = true;
    bool isRefreshing = false;

    Xml2Json xml2json = new Xml2Json();
    
    @override
    void initState() {    
      super.initState();
      getDataTop();
      getDataRecent();
      getDataSearch(); 
      //getDownloadedList(); 
    }
    
    Future<void> _onRefresh() async {
      print('refreshing...');
      topList=[];
      recentList=[];
      searchList=[];

      isRefreshing = true;
      isLoadingTop = true;
      isLoadingRecent = true;
      isLoadingSearch = true;

      setState(() {
        getDataTop();
        getDataRecent();
        getDataSearch(); 
        //getDownloadedList();    
      });
    }
    getDataTop() async {
      setState(() {
        isLoadingTop = true;
      });
      try
      {
        http.Response response = await http.get(urlTop);
      
        if (response.statusCode == 200) {
            
          xml2json.parse(response.body);
          var jsondata = xml2json.toGData();
          var data = json.decode(jsondata);      
          var rest = data["feed"]["entry"] as List;
          
          setState(() {
            topList = rest.map<Article>((json) => Article.fromJson(json)).toList();
            isLoadingTop = false;
          });
        } 
        else {   
          throw Exception('Failed to load photos');
        }
      }
      catch(e) {
        print(e);
      }
    }
    getDataRecent() async {
      setState(() {
        isLoadingRecent = true;
      });
      try
      {
        http.Response response = await http.get(urlRecent);
      
        if (response.statusCode == 200) {
            
          xml2json.parse(response.body);
          var jsondata = xml2json.toGData();
          var data = json.decode(jsondata);      
          var rest = data["feed"]["entry"] as List;
          
          setState(() {
            recentList = rest.map<Article>((json) => Article.fromJson(json)).toList();
            isLoadingRecent = false;
          });
        } 
        else {   
          throw Exception('Failed to load photos');
        }
      }
      catch(e) {
        print(e);
      }
    }
    getDataSearch() async {
      setState(() {
        isLoadingSearch = true;
      });
      try {
        http.Response response = await http.get(urlSearch);
        if (response.statusCode == 200) {
            
          xml2json.parse(response.body);
          var jsondata = xml2json.toGData();
          var data = json.decode(jsondata);      
          var rest = data["feed"]["entry"] as List;
          
          setState(() {
            searchList = rest.map<Article>((json) => Article.fromJson(json)).toList();
            isLoadingSearch = false;
          });
        } 
        else {   
          throw Exception('Failed to load');
        }
      }
      catch(e)
      {
        searchList = null;
      }
    }

    // getDownloadedList() async {
    //   setState(() {
    //     isLoadingDownloaded = true;
    //   });
    //   Directory directory = await getApplicationDocumentsDirectory();
    //   //print("loading directory ...");
    //   List files = await directory.list().toList();
    //   for(int i = 0 ; i < files.length; i++)
    //   {
    //     File file = File(files[i].path);
    //     String path = files[i].path;

    //     if(path.contains("book"))
    //     {
    //       try {
    //         EpubBookRef epubBookRef = await EpubReader.openBook(file.readAsBytesSync());
    //         if(epubBookRef != null)
    //         {
    //           String id = path.substring(path.indexOf('book') + 4, path.indexOf('.epub'));
    //           DateTime time = await file.lastModified();
    //           downloadList.add(Downloaded(id: id, author: epubBookRef.Author, title: epubBookRef.Title, time: time));
    //         }
    //       }
    //       catch(e) {
    //         print(e);
    //         file.delete();
    //       }      
    //     }     
    //   }
    //   isLoadingDownloaded = false;
    //   //downloadList.sort();
    //   print(downloadList);

    // }
    @override
    Widget build(BuildContext context) {
    
    TextStyle txtstyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, fontFamily: 'arial');
    TextStyle seeAll = TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, fontFamily: 'arial');

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

    Shader linearGradient = LinearGradient(
      colors: <Color>[Colors.blue, Colors.teal],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 100.0, 70.0));


    var TopBar = Column(
      children: <Widget>[
        SizedBox(height: 30.0,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          child: Row (
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Featured",  style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, foreground: Paint()..shader = linearGradient),),
            Spacer(),
          ],),),
          Divider(
            color: Colors.black26,
          )
      ],
      
    );
    

    var TopRateBooks = Column(
      children: <Widget>[
        Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row (
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
        Text("Les plus populaires", style: txtstyle),
        Spacer(),
        InkWell(
          onTap: () 
          {               
              Navigator.push(context, MaterialPageRoute(builder: (context) => MostRead("Les plus populaires", topList)));
          },
          child: Text("Voir tout", style: seeAll),
        ),
        
      ],),),

      topList != null ?
      Container(
        height: 130,
        child: isLoadingTop? 
          Center(
                child: CircularProgressIndicator(backgroundColor: Colors.blue, valueColor: new AlwaysStoppedAnimation(Colors.black26)),
          )
          :ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
             return bookCard(topList[index]);
          }),):
          Container( 
            height: 130,
            
            child: Center(child: Text("We have encountered some errors loading this page! \n Please try again later ...", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),)
          )),
      SizedBox(height: 10,),
      Divider
      (
          color: Colors.black26,
      )],
      
    );
    
    var Collections = Column(
      children: <Widget>[
        Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row (
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
        Text("Nos collections", style: txtstyle),
        Spacer(),
       
      ],),),
      Container(
        height: 130,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: collectionCards,
        ),),
      SizedBox(height: 10,),
      Divider
      (
          color: Colors.black26,
      ),
      ],
    );

   
    var recentBooks = Column(
      children: <Widget>[
        Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row (
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
        Text("Dernières mises à jour", style: txtstyle),
        Spacer(),
        InkWell(
          onTap: () 
          {               
              Navigator.push(context, MaterialPageRoute(builder: (context) => MostRead("Dernières mises à jour", recentList)));
          },
          child: Text("Voir tout", style: seeAll),
        ),
      ],),),
      recentList != null ? Container(
        height: 130,
        child: isLoadingRecent? 
          Center(
                child: CircularProgressIndicator(backgroundColor: Colors.blue, valueColor: new AlwaysStoppedAnimation(Colors.black26)),
          )
          :ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
             return bookCard(recentList[index]);
          }))
          : Container( 
            height: 130,
            
            child: Center(child: Text("We have encountered some errors loading this page! \n Please try again later ...", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),)
          )),
      SizedBox(height: 10,),
      Divider
      (
          color: Colors.black26,
      ),
      ],
    );


    var TopSearchBooks = Column(
      children: <Widget>[
        Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row (
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
        Text("Les plus recherchés", style: txtstyle),
        Spacer(),
        InkWell(
          onTap: searchList != null  ? () 
          {               
              Navigator.push(context, MaterialPageRoute(builder: (context) => MostRead("Les plus recherchés", searchList)));
          } : null,
          child: Text("Voir tout", style: seeAll),
        ),
      ],),),
      searchList != null ? 
      Container(
        height: 130,
        child: isLoadingSearch? 
          Center(
                child: CircularProgressIndicator(backgroundColor: Colors.blue, valueColor: new AlwaysStoppedAnimation(Colors.black26)),
          )
          :ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
             return bookCard(searchList[index]);
          }),) : Container( 
            height: 130,
            
            child: Center(child: Text("We have encountered some errors loading this page! \n Please try again later ...", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),)
          )),
      SizedBox(height: 10,)
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: 
      !isLoadingTop ? 
        RefreshIndicator(
          backgroundColor: Colors.blue,
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,      
            child:  Column(
            children: <Widget>[
              TopBar,
              TopRateBooks,
              Collections,
              recentBooks,
              TopSearchBooks,
            ],    
          ),
        )
      ): !isRefreshing ? 
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getColorGradient(5)
          )
      ),
      child : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
              ),
              SizedBox(height: 10,),
              Text("Loading data...", style: TextStyle(fontSize: 16, color: Colors.white),)
            ],
          ),
        ),
      ): 
      SingleChildScrollView(
        scrollDirection: Axis.vertical,      
        child:  Column(
        children: <Widget>[
          TopBar,
          TopRateBooks,
          Collections,
          recentBooks,
          TopSearchBooks,
        ],    
      ),
    )
   );         
  }
}

class bookCard extends StatelessWidget {
  final Article article;
  
  //final String imagePath, bookName, authorName;
  bookCard(this.article);
  TextStyle txtCardBold = TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.bold);
  TextStyle txtCard = TextStyle(fontSize: 12.0, color: Colors.white);

  String _getTitle(String title)
  {
    //title = title.replaceAll(new RegExp("/\'g"), "");
    title = title.replaceAll(new RegExp(r'\\'), r'');


    if(title.length >= 30)
    {
      return title.substring(0,32) + '...';
    }
    else
    {
      return title;
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
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: Stack(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BookInfo(book: article)));
              },
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    // Box decoration takes a gradient
                    gradient: LinearGradient(
                      // Where the linear gradient begins and ends
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      // Add one stop for each color. Stops should increase from 0 to 1
                      stops: [0.3, 0.9],
                      colors: _getColorGradient(int.parse(article.id)%8),
                    ),
                  ),
                  padding: EdgeInsets.all(5),
                  width: 130,
                  height: 120,
                  // color: Color.fromARGB(255, 66, 165, 245),
                  child: new Text(_getTitle(article.title),
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white
                    ),
                  ),
                  alignment: FractionalOffset(0.5, 1),
                ),
              )
            ),],),),
     );
    
  }
}

List<collectionCard> collectionCards = [
  collectionCard('Verne, Jules', 154),
  collectionCard('Hugo, Victor', 66),
  collectionCard('Flaubert, Gustave', 54),
  collectionCard('Voltaire', 158),
  collectionCard('Alain-Fournier', 4),
  collectionCard('Baudelaire, Charles', 14),
  collectionCard('Saint-Exupéry, Antoine de', 130)
];


class collectionCard extends StatelessWidget {
  final String collectionName;
  final int id;
  collectionCard(this.collectionName, this.id);
  TextStyle txtCardBold = TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.bold);
  TextStyle txtCard = TextStyle(fontSize: 12.0, color: Colors.white);

  List<Article>collectionList = List();
 
  List<Color> _getColorGradient (int rand)
  {
    switch(rand) {
     case 1: return [Colors.orange[700], Colors.orange[900]]; break;
     case 2: return [Colors.blue[500], Colors.blue[900]]; break;
     case 3: return [Colors.green[500], Colors.green[900]]; break;
    
     default: return [const Color(0xff43cea2), const Color(0xff185a9d)]; break;
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: Stack(
          children: <Widget>[
            InkWell(
             
              child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => BookFromAuthor(this.id.toString(), collectionName)));
                //Navigator.push(context, MaterialPageRoute(builder: (context) => MostRead("Top Rate Books", collectionList)));
              },
              child: Center(
                child: Card(
                  elevation: 12, 
                  child: Container(
                  
                  // decoration: BoxDecoration(
                  //   // Box decoration takes a gradient
                  //   gradient: LinearGradient(
                  //     // Where the linear gradient begins and ends
                  //     begin: Alignment.centerLeft,
                  //     end: Alignment.centerRight,
                  //     // Add one stop for each color. Stops should increase from 0 to 1
                  //     stops: [0.3, 0.8],
                  //     colors: _getColorGradient(this.id%3),
                  //   ),
                   
                  // ),

                  padding: EdgeInsets.all(5),
                  width: 200,
                  height: 120,
                  // color: Color.fromARGB(255, 66, 165, 245),
                  child: new Text(collectionName,
                    style: TextStyle(
                      fontSize: 19.0,
                      color: Colors.black
                    ), textAlign: TextAlign.center,
                  ),
                  alignment: FractionalOffset(0.5, 0.5),
                ),
              )))),
          ],
        ),
      )
      
     );
    
  }
}