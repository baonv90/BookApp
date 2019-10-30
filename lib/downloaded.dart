class Downloaded {
  final String id;
  final String title;
  final String author;
  final DateTime time;

Downloaded({this.id, this.title, this.author, this.time});

// factory Downloaded.fromJson(Map<String, dynamic> json) {
    
//     var _id = json['id'].toString();
//     var index =  _id.indexOf('book=');
//     _id = _id.substring(index + 5).replaceAll('}', '');

//     var _title = json['title'].toString().substring(5);
//     _title = _title.replaceAll(new RegExp(r'\\'), r'');


//     if(_title.length >= 80)
//     {
//       _title = _title.substring(0,80) + '...';
//     }
//     else 
//     {
//       _title = _title.substring(0,_title.length-1);
//     }

//     var _author = json['author']['name'].toString();
//     _author = _author.substring(5, _author.length - 1);

//     var _category = json["category"].toString();

//     _category = _category.substring(_category.indexOf("label") + 7, _category.indexOf("}"));
   

//     return new Downloaded(
//       id: _id,
//       title: _title,
//       author: _author,
//       time: DateTime.now(),
     
//     );
//   }

//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'id': id,
//         'title': title,
//         'author': author,
//   };
}