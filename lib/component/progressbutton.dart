import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class ProgressButton extends StatefulWidget {
  ProgressButton({Key key, this.id, this.url, this.parentAction}) : super(key: key);

  final String id;
  final String url;
  // final Directory dir;
  final ValueChanged<String> parentAction;

  @override
  _ProgressButtonState createState() => _ProgressButtonState(this.id, this.url, this.parentAction);
}

class _ProgressButtonState extends State<ProgressButton>
    with TickerProviderStateMixin {
  final String id;
  final String url;
  // final Directory dir;
  final ValueChanged<String> parentAction;
  bool loading;
  var progressString = "";
  _ProgressButtonState (this.id, this.url, this.parentAction);
  int _state = 0;
  Animation _animation;
  AnimationController _controller;
  GlobalKey _globalKey = GlobalKey();

  @override
    void initState() {
      _checkExist();    
      super.initState();  
  }

  _checkExist() async
  {
    
    setState(() {
      _state = 10;        
    });

    var directory = await getApplicationDocumentsDirectory();

    File temp = File(directory.path+'/book' + this.id + '.epub');
    //print('checking...');
    //print(await directory.list().toList());
    if(await temp.exists())
    {
      setState(() {
        this.loading = false;
        //Timer(Duration(milliseconds: 200), () {
          setState(() {
            _state = 2;
            widget.parentAction("Update");
          });
        //});
      }); 
    }
    else {
      setState(() {
        _state = 0;      
      });
    } 
  }
    


  _getData() async {
    setState(() {
      this.loading = true;
    });
    var directory = await getApplicationDocumentsDirectory();
    
      HttpClient client = new HttpClient();
        client.getUrl(Uri.parse(this.url))
          .then((HttpClientRequest request) {
            return request.close();
          })
          .then((HttpClientResponse response) {
            response.pipe(new File(directory.path+'/book' + this.id + '.epub').openWrite());
              print("Download Done : Book" + this.id);

              setState(() {
              this.loading = false;
              Timer(Duration(milliseconds: 1000), () {
                setState(() {                
                  try
                  {
                    _state = 2;
                    print('update parent...');
                    widget.parentAction("Update");
                  }
                  catch(e)
                  {
                    _state = 0;
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Error loading book, please try again'),
                    ));
                  }
                });
              });
            }); 
          });
        
  }        

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.only(
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: PhysicalModel(
              elevation: 5,
              shadowColor: Colors.blue,
              color: Colors.blue,
              borderRadius: BorderRadius.circular(25),
              child: Container(
                key: _globalKey,
                height: 45,
                width: 140,
                child: RaisedButton(
                  animationDuration: Duration(milliseconds: 500),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.all(0),
                  child: setUpButtonChild(),
                  onPressed: () {
                    setState(() {
                      if (_state == 0) {
                        animateButton();
                        _getData(); 
                      }
                      else
                      {
                        widget.parentAction("Read");
                      }
                    });
                  },
                  elevation: 4,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
    );
  }

  setUpButtonChild() {
    if(_state == 10)
    {
      return Text(
        "Verification...",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
    }
   
    if (_state == 0) {
      return Text(
        "Télécharger",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
    } else if (_state == 1) {
      return SizedBox(
        height: 30,
        width: 30,
        child: loading? CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ): Icon(Icons.check, color: Colors.white),
      );
    } 
    else {
      return Text(
        "Lire",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      );
    }
  }

  void animateButton() {
    //double initialWidth = _globalKey.currentContext.size.width;
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _animation = Tween(begin: 0.0, end: 1).animate(_controller)
      ..addListener(() {
        // setState(() {
        //   _width = initialWidth - ((initialWidth - 48) * _animation.value);
        // });
      });
    _controller.forward();
    setState(() {
      _state = 1;
    });
  }
}
