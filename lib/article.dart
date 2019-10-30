class Article {
  final String id;
  final String title;
  final String author;
  final String category;
  final String description;
  final String link;  

Article({this.id, this.title, this.author, this.category, this.description, this.link});

factory Article.fromJson(Map<String, dynamic> json) {
    
    var _id = json['id'].toString();
    var index =  _id.indexOf('book=');
    _id = _id.substring(index + 5).replaceAll('}', '');
    
    var _title = json['title'].toString().substring(5);
    _title = _title.replaceAll(new RegExp(r'\\'), r'');


    if(_title.length >= 80)
    {
      _title = _title.substring(0,80) + '...';
    }
    else 
    {
      _title = _title.substring(0,_title.length-1);
    }
    
    var _author = json['author']['name'].toString();
    _author = _author.substring(5, _author.length - 1);

    var _category = json["category"].toString();
   
    _category = _category.substring(_category.indexOf("label") + 7, _category.indexOf("}"));
   
    var _description = json["content"].toString();
    _description = _description.substring(_description.indexOf('cdata') + 6, _description.length - 1);
    _description = _description.replaceAll(new RegExp(r'\\'), r'');
    
    var _link = 'https://www.ebooksgratuits.com/newsendbook.php?id='+ _id + '&format=epub';

    return new Article(
      id: _id,
      title: _title,
      author: _author,
      category: _category,
      description: _description,
      link: _link,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'author': author,
        'category': category,
        'description': description,
        'link': link
  };
}