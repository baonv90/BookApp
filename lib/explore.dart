import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'webview.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}
class _ExploreState extends State<Explore> {

  bool isLoading = false;
  String data = "";

  @override
  void initState() {
    super.initState();
  }
  // getDataTop(String url) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   print(url);
  //   http.Response response = await http.get(url);
  //   if (response.statusCode == 200) { 
  //     setState(() {
        
  //       data = response.body;

  //       var index1 = data.indexOf("<table");
  //       var index2 = data.indexOf("</table>");
  //       //print(index1.toString() + ' --- ' + index2.toString());
  //       data = data.substring(index1, index2);

  //       var split = data.split("<tr><td>");
  //       print(split[1]);
       
  //       isLoading = false;
  //     });
  //   } 
  //   else {   
  //     throw Exception('Failed to load photos');
  //   }
  //}
  // _launchURL(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  List websites = [
    {"link": "www.didactibook.com", "url": "https://ww12.didactibook.com", "detail" : "Didactibook est un site specialise dans les livres numeriques. Ce site propose actuellement plus de 3500..."},
    {"link": "www.decitre.com", "url":"https://www.decitre.fr/ebook/bonnes-affaires/ebooks-gratuits.html", "detail" : "Propose pres de 3000 ebooks a telecharger gratuitement, principalement au format epub..."},
    {"link": "www.beq.ebooksgratuits.com", "url": "https://www.beq.ebooksgratuits.com", "detail" : "La bibliotheque electronique du Quebec"},
    {"link": "www.bibebook.com", "url":"https://www.bibebook.com", "detail" : "Bibebook est un site specialise dans les livres numeriques. Ce site propose actuellement plus de 1600..."},
    {"link": "www.livre.fnac.com", "url":"https://livre.fnac.com/n286016/Petit-prix-et-bons-plans-ebooks/Tous-les-Ebooks-gratuits", "detail" : "Dans le section dediee aux livres numeriques, le site de la Fnac propose 500 ebooks a telecharger gratuitement..."},
    {"link": "www.cultura.com", "url":"https://www.cultura.com/ebook/ebook-gratuits-17/voir-tous-les-gratuits.html", "detail" : "Cultura propose actuellement plus de 3000 ebooks a telecharger gratuitement..."},
    {"link": "www.download.library1.org", "url":"https://www.download.library1.org", "detail" : "Des ebooks a telecharger gratuitement sont trouves sur ce site..."},

  ];

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
     
        body:  Container(
          child: SingleChildScrollView(
          scrollDirection: Axis.vertical,      
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
            SizedBox(height: 25,),
            Image(image: AssetImage('res/reading.jpg')),
            Padding(padding: EdgeInsets.all(10), child: Text("BOOK INTERNET BROWSER", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, foreground: Paint()..shader = LinearGradient( colors: <Color>[Colors.green, Colors.black]).createShader(Rect.fromLTWH(0.0, 0.0, 100.0, 70.0))),),),
            Padding(padding: EdgeInsets.all(10), child: Text("Explore thousands of epub books on the internet, download and read on your app", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, foreground: Paint()..shader = LinearGradient( colors: <Color>[Colors.blue, Colors.teal]).createShader(Rect.fromLTWH(0.0, 0.0, 100.0, 70.0))),),),
            Container(
            child: Center(child: MaterialButton(
              child: Text("Open Browser", style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewPage(url: "https://opds.tienluong.info",))); //"http://opds.tienluong.info"
              },
              elevation: 10,
              color: Colors.blue,
              ),),),
            SizedBox(height: 15,),
            Container(
              height: 35,
              width: MediaQuery.of(context).size.width,
              child: Center(child: Text("Top websites", style: TextStyle(fontSize: 16),),),
              color: Colors.black12,
            ),
            SizedBox(height: 15,),
            Container(
            height: 5 * 75.toDouble(),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(0),
              itemCount: websites.length,
              itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 75,
                // color: Colors.red,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewPage(url: websites[index]["url"],)));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                      height: 25,

                        child: Text(websites[index]["link"], style: TextStyle(fontSize: 16, color: Colors.blue),),),
                      SizedBox(height: 45,
                        child: Text(websites[index]["detail"], maxLines: 2, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.black),),),

                      // Spacer(),
                      Divider(height: 0,)
                    ],
                  ),
                ));
              }
            )
            
          ),
        ])))
    );
  } 
}
