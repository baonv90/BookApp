import 'package:flutter/material.dart';
import 'dart:convert';
import 'bookfromauthor.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:http/http.dart' as http;


class Author extends StatefulWidget {
  @override
  _AuthorState createState() => _AuthorState();
}

class _AuthorState extends State<Author> {
  List listAuthors = List();
  List listDisplay = List();

  bool isLoading = true;
  
  @override
  void initState() {
    getAuthorList();
    super.initState();
  }

  getAuthorList() async {
    setState(() {
        isLoading = true;
    });
    final response = await http.get('http://opds.tienluong.info/ios/ebooksgratuit/get_authors.php');

    if (response.statusCode == 200) {
      if (mounted){
        setState(() {
          listAuthors = json.decode(response.body) as List;
          
          //listAuthors = listAuthors.reversed.toList();
          isLoading = false;
          listDisplay = listAuthors.reversed.toList();
        });
     }
    } 
    else {
      throw Exception('Failed to load file');
    }
    
  }
  TextEditingController editingController = TextEditingController();
  void filterSearchResults(String query) {
    print(query);
    if(query.isNotEmpty) {
      listDisplay = [];
      listAuthors.forEach((item) {
        if(item["name"].toLowerCase().contains(query)) {
          listDisplay.add(item);      
        }
      });
      setState(() {
        //listAuthors = searchList;
        print(listDisplay);
      });
      return;
    } 
    else {
      setState(() {
        listDisplay = listAuthors.reversed.toList();
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          //color: Colors.red,
          child: Column(
            children: <Widget>[
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: TextField(
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      hintText: "Author",
                      prefixIcon: Icon(Icons.search, color: Colors.black26,),
                  )    
                ),
              ),
              Expanded(
                child:  isLoading ? Center(
                child: CircularProgressIndicator(backgroundColor: Colors.blue, valueColor: new AlwaysStoppedAnimation(Colors.black26)),
              ): 
              ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: listDisplay.length,  
              itemBuilder: (context, index) {

              bool _time = true;
              if(index > 0) _time = listDisplay[index]["name"].substring(0,1) != listDisplay[index - 1]["name"].substring(0,1);
              
              return StickyHeader(
                header: _time ? Container(
                  height: 25.0,
                  color: Colors.grey[200],
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    listDisplay[index]["name"].substring(0,1),
                    style: const TextStyle(color: Colors.black),
                  ),
                ): Container(),
                content: 
                  InkWell (
                    onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BookFromAuthor(listDisplay[index]["author_id"], listDisplay[index]["name"])));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.black12)), color: Colors.transparent), 
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0, top: 12.0, bottom: 12.0),
                        child: Text(listDisplay[index]["name"], style: TextStyle(fontSize: 16),),
                      ),
                    ),
                  )
              );}))
            ],
          ),
        )
      );
  }
}