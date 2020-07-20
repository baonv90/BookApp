import 'dart:async';
import 'package:flutter/material.dart';
import 'home.dart';
import 'explore.dart';
import 'author.dart';
import 'search.dart';
import 'onReading.dart';



void main() => runApp(SplashScreen());

class SplashScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {

@override
  void initState() {
    super.initState();
    loadData();
  }

loadData() async {
  return new Future.delayed(Duration(seconds: 1, milliseconds: 500), onDoneLoading);
}

onDoneLoading() async {
  runApp(MyBookApp(index: 0,));
}


@override
Widget build(BuildContext context) {
    return Container(
     
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('res/main.jpg'),
          fit: BoxFit.fitHeight
        ) ,
      ),
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        
        children: <Widget>[
          SizedBox(height: 10,),
          Center(
            child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
          ),),
          // SizedBox(height: 10,),
          Container(
            color: Colors.transparent,
            height: 30,
        
            child: Text("Van Bao Nguyen - LBXtudio, eBook Gratuit 1.0.0", style: TextStyle(fontSize: 13), textDirection: TextDirection.ltr, maxLines: 2,),
          ),
        ],
      ),
    );
  }
}

class MyInheritedWidget extends InheritedWidget {

  final int selectedIndex;
  MyInheritedWidget({
    Key key,
    @required this.selectedIndex,
    @required Widget child,
  }) : super(key: key, child: child);
 
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
  static MyInheritedWidget of (BuildContext context) => context.inheritFromWidgetOfExactType(MyInheritedWidget); 
}

class MyBookApp extends StatefulWidget{
  final int index;
  MyBookApp({Key key, this.index}) : super(key: key);
  @override
  _MyBookAppState createState() => _MyBookAppState();
}

class _MyBookAppState extends State<MyBookApp> {
    MaterialColor white = const MaterialColor(
    0xFFFFFFFF,
    const <int, Color>{
      50: const Color(0xFFFFFFFF),
      100: const Color(0xFFFFFFFF),
      200: const Color(0xFFFFFFFF),
      300: const Color(0xFFFFFFFF),
      400: const Color(0xFFFFFFFF),
      500: const Color(0xFFFFFFFF),
      600: const Color(0xFFFFFFFF),
      700: const Color(0xFFFFFFFF),
      800: const Color(0xFFFFFFFF),
      900: const Color(0xFFFFFFFF),
    },
  );
  int _selectedIndex;
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      _selectedIndex = widget.index;

    }
  final pageController = PageController();
  void onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  
  // List<Widget> _pageOptions = [Home(), Author(), Search(), OnReading()];
  Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.red, Colors.blue],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 100.0, 70.0));


  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
   
    Widget apps = MaterialApp(
      title: 'FreeBook',
      theme: ThemeData(      
        primarySwatch: white,
        backgroundColor: Colors.blue,
        canvasColor: Colors.white,
        // canvasColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        
        body: new Stack(
        //index: _selectedIndex,
        children: <Widget>[ 
          new Offstage(
            offstage: _selectedIndex != 0,
            child: Home(),
          ),
          new Offstage(
            offstage: _selectedIndex != 1,
            child: Explore(),
          ),
          
          new Offstage(
            offstage: _selectedIndex != 2,
            child: Author(),
          ),
          new Offstage(
            offstage: _selectedIndex != 3,
            child: Search(),
          ),
          new Offstage(
            offstage: _selectedIndex != 4,
            child: OnReading(selectIndex: _selectedIndex,),
          )
        ],
      ),
        
      bottomNavigationBar: new BottomNavigationBar(items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.star, color: Colors.blueGrey,), title: Text('Featured', style: TextStyle(fontWeight: FontWeight.bold,foreground: Paint()..shader = linearGradient),)),
            BottomNavigationBarItem(icon: Icon(Icons.explore, color: Colors.blueGrey,), title: Text('Explore', style: TextStyle(fontWeight: FontWeight.bold,foreground: Paint()..shader = linearGradient),)),
            BottomNavigationBarItem(icon: Icon(Icons.people, color: Colors.blueGrey), title: Text('Author', style: TextStyle(fontWeight: FontWeight.bold,foreground: Paint()..shader = linearGradient))),
            BottomNavigationBarItem(icon: Icon(Icons.search, color: Colors.blueGrey), title: Text('Search', style: TextStyle(fontWeight: FontWeight.bold,foreground: Paint()..shader = linearGradient))),
            BottomNavigationBarItem(icon: Icon(Icons.collections_bookmark, color: Colors.blueGrey), title: Text('Reading', style: TextStyle(fontWeight: FontWeight.bold,foreground: Paint()..shader = linearGradient)))
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),  
      ),
      //onGenerateRoute: (settings) => generateRoute(settings),
    );

    return MyInheritedWidget(
      selectedIndex: _selectedIndex,
      child: apps,
    );
  }
}

