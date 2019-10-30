import 'package:flutter/material.dart';
import 'package:freebook/component/carousel_slider.dart';
import 'package:freebook/component/flutter_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freebook/data.dart';
import 'package:freebook/readingpage.dart';


class MyBooks extends StatefulWidget {
  MyBooks({Key key}) : super(key: key);
  @override
  _MyBooksState createState() => _MyBooksState();
}


class _MyBooksState extends State<MyBooks> {
  
  int currentPage = 0;
  String recent = '';
  double _percent = .5;
  int _selectedIndex = 0;

  
  _setCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    setState(() {
      if(prefs.getString('recentBooks').toString() != null)
      {
        recent =  prefs.getString('recentBooks');
      }
      for(var i = recent.length - 1 ; i >= 0; i-- )
      {
        String percent = (prefs.getInt('currentChap'+recent[i])/books[int.parse(recent[i]) - 1].chapters).toStringAsFixed(2);
        print('book ' + recent[i] + ' **&&** ' + percent);
        cityCards.add(newCard(int.parse(recent[i]), percent));
        listCards.add(newItem(int.parse(recent[i]), percent));

        
      }
      this.currentPage = int.parse(recent[recent.length - 1]) - 1;
      this._percent = cityCards[0].percent;

    });
  }

  CityCard newCard(int id, String percent)
  {
    return CityCard(id, double.parse(percent));
  }
  ListCard newItem(int id, String percent)
  {
    return ListCard(id, double.parse(percent));
  }

  String getPourcentage(double percent)
  {
    return (percent*100).toStringAsFixed(0) + '%';
  }


  void initState()
  {
    super.initState();
    print('init reading page');
    _setCounter();
  }

  List<CityCard> cityCards = [];
  List<ListCard> listCards = [];
    @override
    Widget build(BuildContext context) {
    
    final Widget ListBooks = Scaffold(
     appBar: AppBar(
          title: Text('Reading',style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, fontFamily: 'charter'),),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.view_carousel), color: Colors.black, onPressed: (){
              setState(() {
                this._selectedIndex = 0;               
               });
            },)
          ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: listCards,
      ),
    );
    
    final Widget GridView = Scaffold(
        appBar: AppBar(
          title: Text('Reading', style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, fontFamily: 'charter'),),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.filter_list), color: Colors.black, onPressed: (){
             
              setState(() {
                this._selectedIndex = 1;      
               });
            },)
          ],
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Flexible(
              child: CarouselSlider(
                reverse: false,
                height: 400,
                items: cityCards,
                viewportFraction: .8,
                initialPage: 0,  
                enlargeCenterPage: true,
                onPageChanged: (int index){
                  setState(() {
                    //print('loading book ' + this.recent[recent.length - 1 - index]);
                    this.currentPage = int.parse(this.recent[recent.length - index - 1]) - 1;
                    _percent = cityCards[index].percent;  
                  });  
                },
              ),
            ),
            Container(
              width: 210,
              height: 30,
              color: Colors.transparent,
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: LinearPercentIndicator(
                        width: 160,
                        percent: _percent,
                        lineHeight: 8,
                        progressColor: Colors.orange,
                        animateFromLastPercent: true,
                    ),
                  ),
                  //Spacer(),
                  Text(getPourcentage(this._percent), style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 14.0),),
                ],
              )
             
              

            ),
            
            Text(books[currentPage].title, style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 18.0),),
            Text('Conan Doyle', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16.0),),

          ],
        )
      );
      final List<Widget> options = [GridView, ListBooks];

      return options[_selectedIndex];
    }

}

class CityCard extends StatelessWidget {
  
  final int id;
  
  double percent;

  setPercent(int val, int id) {
    //print(val);
    this.percent = double.parse((val/books[id].chapters).toStringAsFixed(2));
    print(percent);
    //this.percent = val;
  }
  Book book;

  double getPercent() {
    //print('get percent');
    return this.percent;
  }
  
  CityCard(this.id,  this.percent);

  TextStyle txtCardBold = TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.bold);
  TextStyle txtCard = TextStyle(fontSize: 12.0, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    
      return 
        Container(
          padding: EdgeInsets.only(bottom: 25.0), 
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.transparent,
            elevation: 5,
              child: Stack(
                children: <Widget>[
                ClipRRect( 
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Container( 
                    width: 270.0,
                    // height: 380,
                    
                    child: InkWell(
                      onTap: () {
                        print('on view book' + this.id.toString());
                        book = books[id - 1];
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyGetData(book))).then((val){
                          print('data returned' + val.toString());
                          this.setPercent(val, id-1);
                          
                        });
                      },
                      child: Card( color:  Colors.black38,) ,
                      // Image.asset('res/sherlock' + this.id.toString() + '.jpg', fit: BoxFit.cover),
                    )
                          
                  ),),
                  //Text('$percent')
                  ],
                ),
            )
          
      
    );
       
  }
}


class ListCard extends StatelessWidget {
  
  final int id;
  
  double percent;

  setPercent(int val, int id) {
    this.percent = double.parse((val/books[id].chapters).toStringAsFixed(2));
    print(percent);
  }
  Book book;

  Book getBook(){
    return books[this.id - 1];
  }
  double getPercent() {
    //print('get percent');
    return this.percent;
  }
  ListCard(this.id,  this.percent);

  TextStyle txtCardBold = TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.bold);
  TextStyle txtCard = TextStyle(fontSize: 12.0, color: Colors.white);

  @override
  Widget build(BuildContext context) {
      return 
        Container(
          // color: Colors.white,
          decoration: BoxDecoration(
            color: Colors.white,
           
            border: Border(
              bottom: BorderSide(
                color: Colors.black12,
                width: 4.0,
              ),
              top: BorderSide(
                color: Colors.black12,
                width: 4.0,
              ),
              left: BorderSide(
                color: Colors.black12,
                width: 8.0,
              ),
              right: BorderSide(
                color: Colors.black12,
                width: 8.0,
              )
            ),
          ),
         
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(12),
                child: Container(
                  width: 60,
                  height: 80,
                  child: InkWell(
                  onTap: () {
                    print('on view book' + this.id.toString());
                    book = books[id - 1];
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyGetData(book))).then((val){
                      print('data returned' + val.toString());
                      this.setPercent(val, id-1);    
                    });
                  },
                  child:  Card(color:  Colors.black38,)
                  // Image.asset('res/sherlock' + this.id.toString() + '.jpg', fit: BoxFit.cover),
                )
                ),
                
              ),      
              SizedBox(width: 8,),
              Column(
                
                children: <Widget>[
                   Container(
                     width: 150,
                     height: 40,
                     color: Colors.transparent,
                     child: Text(getBook().title, style: TextStyle(fontFamily: 'Charters', fontSize: 16, fontWeight: FontWeight.bold),),
                   ),
                  Container(
                     width: 150,
                     height: 20,
                     color: Colors.transparent,
                     child: Text(getBook().chapters.toString() + ' chapters', style: TextStyle(fontFamily: 'Charters', fontSize: 13),),

                   ),
                  //  Text('Conan Doyle', style: TextStyle(fontFamily: 'Charters', fontSize: 13),),
                ],
              ),
             
              Spacer(),
              Column(
            
                children: <Widget>[
                  LinearPercentIndicator(
                      width: 100,
                      percent: this.percent,
                      progressColor: Colors.orange,
                  ),
                  SizedBox(height: 4,),

                  Text((percent*100).toStringAsFixed(0) + '%', style: TextStyle(fontFamily: 'Charters', fontSize: 14),),
                ],
              ),
              SizedBox(width: 10,)
            ],

          ),

        
          
          // Material(
          //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
          //   color: Colors.transparent,
          //     child: Stack(
          //       children: <Widget>[
          //       ClipRRect( 
          //         borderRadius: BorderRadius.all(Radius.circular(0.0)),
          //         child: Container( 
          //           width: 60.0,                    
          //           child: InkWell(
          //             onTap: () {
          //               print('on view book' + this.id.toString());
          //               book = books[id - 1];
          //               Navigator.push(context, MaterialPageRoute(builder: (context) => MyGetData(book))).then((val){
          //                 print('data returned' + val.toString());
          //                 this.setPercent(val, id-1);
                          
          //               });
          //             },
          //             child:  Image.asset('res/sherlock' + this.id.toString() + '.jpg', fit: BoxFit.cover),
          //           )
                          
          //         ),),
          //         //Text('$percent')
          //         ],
          //       ),
          //   )
          
      
    );
       
  }
}

 // Positioned(
          //     left: 0.0,
          //     bottom: 0.0,
          //     width: 270.0,
          //     height: 40.0,
              
          //     child: Padding(
          //         padding: EdgeInsets.all(20.0),
          //         child: LinearPercentIndicator(
          //           width: 200,
          //           percent: .9,
          //           lineHeight: 8,
          //           progressColor: Colors.orange,
          //           animateFromLastPercent: true,
          //       ),
          //     ),
              
          //     // Container(
          //     //   decoration: BoxDecoration(
          //     //     color: Colors.red,
          //     //   ),
          //     // ),
          //   ),

// class Reading extends StatelessWidget {

 
  

//   Reading();
  
//   List<CityCard> cityCards = [
//     CityCard('res/sherlock1.jpg', 'Las Vegas', 'Feb 2019', .5 , '3229', '2199'),
//     CityCard('res/sherlock2.jpg', 'Athens', 'Mar 2019', .7, '5229', '499'),
//     CityCard('res/sherlock3.jpg', 'Sydney', 'May 2019', .2, '3229', '2599'),
//     CityCard('res/sherlock4.jpg', 'Sydney', 'May 2019', .1, '3229', '2599'),

//   ];
//     @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Reading'),
//         ),
//         body:  Column(
//           children: <Widget>[
//             SizedBox(height: 20,),
//             Flexible(
//               child: CarouselSlider(
//                 reverse: false,
//                 height: 400,
//                 items: cityCards,
//                 viewportFraction: .8,
//                 initialPage: 0,
//                 enlargeCenterPage: true,
//                 onPageChanged: (int index){
//                    this.currentPage = index;
//                    print(currentPage);
//                    //this._percent = 0.1*index;
//                    //print(_percent);
//                 },
//               ),
//             ),
//             Container(
//               width: 190,
//               height: 30,
//               color: Colors.white,
//               child : Padding(
//                 padding: EdgeInsets.all(10.0),
//                 child: LinearPercentIndicator(
//                   width: 170,
//                   percent: _percent,
//                   lineHeight: 8,
//                   progressColor: Colors.orange,
//                   animateFromLastPercent: true,
//                 ),
//               ),
//             ),
//             Text('Sherlock Holmes $currentPage', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 22.0),),
//           ],
//         )
//       );
//     }
//   }

// class CityCard extends StatefulWidget {
//   int id;
//   double percent;
  
//   double getPercent() {
//     //print('get percent');
//     return this.percent;
//   }
  

//   CityCard(this.id, this.percent);
//   @override
//   _CityCardState createState() => _CityCardState(this.id, this.percent);
// }

// class _CityCardState extends State<CityCard> {
  
//   int id;
  
//   double percent;

//   void initState()
//   {
//     super.initState();
//     print('init page');
//     //this.setPercent(val, id)
//   }

//   setPercent(int val, int id) {
//     print(val);
//     this.percent = double.parse((val/books[id].chapters).toStringAsFixed(1));
//     print(percent);
//     //this.percent = val;
//   }
  
//   Book book;

  
  
//   _CityCardState(this.id,  this.percent);



//   TextStyle txtCardBold = TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.bold);
//   TextStyle txtCard = TextStyle(fontSize: 12.0, color: Colors.white);

//   @override
//   Widget build(BuildContext context) {
    
//       return 
//         Container(
//           padding: EdgeInsets.only(bottom: 25.0), 
//           child: Material(
//             borderRadius: BorderRadius.all(Radius.circular(10.0)),
//             color: Colors.transparent,
//             elevation: 5,
//               child: Stack(
//                 children: <Widget>[
//                 ClipRRect( 
//                   borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                   child: Container( 
//                     width: 270.0,
//                     // height: 380,
                    
//                     child: InkWell(
//                       onTap: () {
//                         print('on view book' + this.id.toString());
//                         book = books[id - 1];
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => MyGetData(book))).then((val){
//                           print('data returned' + val.toString());
//                           setState(() {
                                                      
//                             this.percent = 1;                       
//                             //this.setPercent(val, id-1);
//                           });
                          
//                         });
//                       },
//                       child:  Image.asset('res/sherlock' + this.id.toString() + '.jpg', fit: BoxFit.cover),
//                     )
                          
//                   ),),
//                   Text('$percent')
//                   ],
//                 ),
//             )
          

//           // Positioned(
//           //     left: 0.0,
//           //     bottom: 0.0,
//           //     width: 270.0,
//           //     height: 40.0,
              
//           //     child: Padding(
//           //         padding: EdgeInsets.all(20.0),
//           //         child: LinearPercentIndicator(
//           //           width: 200,
//           //           percent: .9,
//           //           lineHeight: 8,
//           //           progressColor: Colors.orange,
//           //           animateFromLastPercent: true,
//           //       ),
//           //     ),
              
//           //     // Container(
//           //     //   decoration: BoxDecoration(
//           //     //     color: Colors.red,
//           //     //   ),
//           //     // ),
//           //   ),
      
//     );
       
//   }
// }  