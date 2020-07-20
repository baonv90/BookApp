import 'package:flutter/material.dart';
import 'article.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart'; 
import 'bookinfo.dart';




class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<dynamic> listSuggestions = ["Amour", "Hugo, Victor", "Les fleurs du mal", "Antigone", "Romans", "Pirates", "Paris", "Les miserables", "Verne, Jules"];
  List<dynamic> listDisplay = [];
  
  @override
  void initState() {
    super.initState();
  }
  
  String searchtext = "Suggestions";
  String urlSearch = "https://www.ebooksgratuits.com/opds/feed.php?mode=search&query=";
  bool isLoading = false;
  bool isDisplay = false;
  Xml2Json xml2json = new Xml2Json();
  
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

  getSearchResults(String search) async {
    setState(() {
      isLoading = true;
    });
    var data, rest;
    try {
      http.Response response = await http.get(urlSearch + search);
      if (response.statusCode == 200) {
          
        xml2json.parse(response.body);
        var jsondata = xml2json.toGData();
        data = json.decode(jsondata);

        if(data.toString().contains("entry"))
        { 
          rest = data["feed"]["entry"];
            if(rest.toString()[0] == "{")
            { 
              setState(() {
                listDisplay = [Article.fromJson(rest)];
                isLoading = false;

              });
            }
            else
            {
              setState(() {
                listDisplay = rest.map<Article>((json) => Article.fromJson(json)).toList();
                isLoading = false;
              });
            }
        }
        else
        {
          setState(() {       
            print("no results");
            listDisplay = [];
            isLoading = false;
          });

        }
        searchtext = "Search Results";
        isDisplay = true;

        //
        print(listDisplay);
        //listSuggestions = listDisplay;
      } 
      else {   
        throw Exception('Failed to load books');
      }
    }
    catch(e)
    {
      
      print(e);
     
    } 
     
  }
  
  TextEditingController editingController = TextEditingController();
  void filterSearchResults(String query) {
    print(query);
    if(query.isNotEmpty) {
      setState(() {
        searchtext = "Searching " + query.toString();
        getSearchResults(query);
      });
      return;
    } 
    else {
      setState(() {
        isDisplay = false;  
        searchtext = "Suggestions";             
        // listDisplay = listAuthors.reversed.toList();
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        //resizeToAvoidBottomPadding: ,
        
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: TextField(
                  onChanged: (value) {
                    if(value.isEmpty)
                    {
                      setState(() {        
                       isDisplay = false;  
                       searchtext = "Suggestions";   
                           
                      });          
                    }

                  }, 
                  onSubmitted: (value) {
                    filterSearchResults(value);
                  },
                 
                  controller: editingController,
                  decoration: InputDecoration(
                      hintText: "Book Title, Author ...",
                      prefixIcon: Icon(Icons.search, color: Colors.black26,),
                  )    
                ),
              ),

              Container(
                height: 35.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.black12,
                child: Center(
                  child: Row(
                  children: <Widget>[
                    SizedBox(width: 10,), 
                    Text("$searchtext", style: TextStyle(color: Colors.black87, fontSize: 16),),
                    Spacer(),
                    isDisplay ?
                    IconButton(
                      onPressed: (){
                        setState(() {
                          isDisplay = false;  
                          searchtext = "Suggestions";                      
                        });     
                      },
                      padding: EdgeInsets.only(bottom: 0),
                      icon: Icon(Icons.clear),
                      
                    ): Container()
                  ],
                ),)
              ),
                 
              !isLoading && !isDisplay ? 
              Expanded(
                child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: listSuggestions.length,   
                itemBuilder: (BuildContext context, int index) {
                  return InkWell (
                    onTap: () {
                      setState(() {
                        searchtext = "Searching " + listSuggestions[index];
                        getSearchResults(listSuggestions[index]);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.black12)), color: Colors.white), 
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(listSuggestions[index], textAlign: TextAlign.center, style: TextStyle(color: Colors.blue, fontSize: 15.0),),
                      ),
                    )
                  );
                }),
              ): 
              !isDisplay ? 
                Flexible(
                  // height: MediaQuery.of(context).size.height -170,
                  child:  new Center(
                  child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation(Colors.blue)),
                  ),) : Flexible(
                  // height: MediaQuery.of(context).size.height - 200,
                  child: listDisplay.length != 0 ? ListView.builder(
                  itemCount: listDisplay.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      onTap: () {               
                         Navigator.push(context, MaterialPageRoute(builder: (context) => BookInfo(book: listDisplay[index])));
                      },
                      title: new Text(listDisplay[index].title),
                      subtitle: Text(listDisplay[index].author + ' (' + listDisplay[index].category + ')'),
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
                          colors: _getColorGradient(int.parse(listDisplay[index].id)%8),
                        ),),
                        child: Center(child: Text(listDisplay[index].title.substring(0,1),style:TextStyle(color: Colors.white, fontSize: 25))),
                      )
                    );
                  }): Container(
                    child: Center( child : Text("No results", style: TextStyle(color: Colors.blue, fontSize: 18),)),
                  ),

                )
            ],
          ),
        )
      );
  }
}