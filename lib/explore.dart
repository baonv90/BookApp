import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:freebook/article.dart';
// import 'package:freebook/downloaded.dart';
// import 'package:freebook/mostread.dart';
// import 'dart:convert';
// import 'package:xml2json/xml2json.dart'; 
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
// import 'package:freebook/bookinfo.dart';
// import 'package:freebook/bookfromauthor.dart';
import 'package:webview_flutter/webview_flutter.dart';


class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  
  String url = "http://opds.tienluong.info";
  Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController _myController;

  final Set<String> _favorites = Set<String>();


  bool isLoading = false;
  String data = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getDataTop();

  }
  getDataTop(String url) async {
    setState(() {
      isLoading = true;
    });
    print(url);
    http.Response response = await http.get(url);
    if (response.statusCode == 200) { 
      setState(() {
        
        data = response.body;

        var index1 = data.indexOf("<table");
        var index2 = data.indexOf("</table>");
        //print(index1.toString() + ' --- ' + index2.toString());
        data = data.substring(index1, index2);

        var split = data.split("<tr><td>");
        print(split[1]);
       
        isLoading = false;
      });
    } 
    else {   
      throw Exception('Failed to load photos');
    }
  }
  // _launchURL(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[  
          NavigationControls(_controller.future),
          Menu(_controller.future, () => _favorites),
          IconButton(icon: Icon(Icons.open_in_browser), onPressed: () {
            setState(() {
              url = "http://www.opds.tienluong.info";  
                          
            });
            _myController.evaluateJavascript("document.addEventListener('click')");

            // getDataTop("http://opds.tienluong.info/index.php?query=book&mode=search");
            //_launchURL(url);
          },)
        ],
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,

        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
          _myController = webViewController;
        },
        onPageFinished: (String url) {
          injectTouchListener();
          //_myController.evaluateJavascript("console.log(document.documentElement.innerHTML);");

        },
        javascriptChannels: <JavascriptChannel> [
          
           JavascriptChannel(name: 'Log', onMessageReceived: (JavascriptMessage msg) { print(msg.message); }),
           //_toasterJavascriptChannel(context),
        ].toSet() ,
      ),
      floatingActionButton: _bookmarkButton(),

      // !isLoading ? 
      // Html(
      //   data: data.toString(),
      //   padding: EdgeInsets.all(26.0),
      //   backgroundColor: Colors.white,
      //   defaultTextStyle: TextStyle(fontFamily: 'Charter', fontSize: 16, color: Colors.black),)
      // :Center(
      //   child: CircularProgressIndicator(backgroundColor: Colors.white, valueColor: new AlwaysStoppedAnimation(Colors.black26)),
      // )
    );
  }
  Future<void> injectTouchListener() async {
    final WebViewController controller = await _controller.future;
    controller.evaluateJavascript("document.addEventListener('touchstart', (event) => { Log.postMessage(String(event)); }, true);");
  }
  _bookmarkButton() {
    return FutureBuilder<WebViewController>(
      future: _controller.future,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        if (controller.hasData) {
          return FloatingActionButton(
            onPressed: () async {
              var url = await controller.data.currentUrl();
              _favorites.add(url);
              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('Saved $url for later reading.')),
              );
            },
            child: Icon(Icons.favorite),
          );
        }
        return Container();
      },
    );
  }
  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}


class Menu extends StatelessWidget {
  Menu(this._webViewControllerFuture, this.favoritesAccessor);
  final Future<WebViewController> _webViewControllerFuture;
  // TODO(efortuna): Come up with a more elegant solution for an accessor to this than a callback.
  final Function favoritesAccessor;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        if (!controller.hasData) return Container();
        return PopupMenuButton<String>(
          onSelected: (String value) async {
            if (value == 'Email link') {
              var url = await controller.data.currentUrl();
              await launch(
                  'mailto:?subject=Check out this cool Wikipedia page&body=$url');
            } else {
              var newUrl = await Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return FavoritesPage(favoritesAccessor());
              }));
              Scaffold.of(context).removeCurrentSnackBar();
              if (newUrl != null) controller.data.loadUrl(newUrl);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                const PopupMenuItem<String>(
                  value: 'Email link',
                  child: Text('Email link'),
                ),
                const PopupMenuItem<String>(
                  value: 'See Favorites',
                  child: Text('See Favorites'),
                ),
              ],
        );
      },
    );
  }
}

class FavoritesPage extends StatelessWidget {
  FavoritesPage(this.favorites);
  final Set<String> favorites;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite pages')),
      body: ListView(
          children: favorites
              .map((url) => ListTile(
                  title: Text(url), onTap: () => Navigator.pop(context, url)))
              .toList()),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () => navigate(context, controller, goBack: true),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () => navigate(context, controller, goBack: false),
            ),
          ],
        );
      },
    );
  }

  navigate(BuildContext context, WebViewController controller,
      {bool goBack: false}) async {
    bool canNavigate =
        goBack ? await controller.canGoBack() : await controller.canGoForward();
    if (canNavigate) {
      goBack ? controller.goBack() : controller.goForward();
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
            content: Text("No ${goBack ? 'back' : 'forward'} history item")),
      );
    }
  }
}