import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class Storage {

  File jsonFile;
  Directory dir;
  String fileName = "myBook.json";
  bool fileExists = false;
  Map<String, dynamic> fileContent;

  Storage() {
    getApplicationDocumentsDirectory().then((Directory directory) {
        this.dir = directory;
        jsonFile = new File(dir.path + "/" + this.fileName);
        this.fileExists = jsonFile.existsSync();

        if(this.fileExists) {    
          this.fileContent = json.decode(jsonFile.readAsStringSync());
          //print('file exist' + this.fileContent.toString());
        }
    });
  }

  Map<String, dynamic> getContent()
  {
    return this.fileContent;
  }

  Map<String, dynamic> init()
  {
    getApplicationDocumentsDirectory().then((Directory directory) {
        this.dir = directory;
        jsonFile = new File(dir.path + "/" + this.fileName);
        this.fileExists = jsonFile.existsSync();

        if(this.fileExists) {       
          this.fileContent = json.decode(jsonFile.readAsStringSync());
          //print('file exist' + this.fileContent.toString());
        }      
    });
    return this.fileContent;
  }

  void createFile(Map<String, dynamic> content, Directory dir, String fileName) {
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content));
  }

  void writeToFile(String _currentId, String _currentChap, String _currentOffset) {
    print("Writing to file!");
    User user = new User(0, _currentChap);



    var _content = user.toJson();
    
    Map<String, dynamic> content = {"id":_currentId, "data": {"chapter": _currentChap, "offset": _currentOffset}};
    //var user = new User.fromJson(content);
    //{{"id":_currentId}, {"chap": _currentChap}};
    if (fileExists) {
      print("File exists");
      Map<String, dynamic> jsonFileContent = json.decode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(_content);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      print("File does not exist!");
      createFile(content, dir, fileName);
    }
    //this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
    print(fileContent);
  }
}


class User {
  final int id;
  final String chapter;

  User(this.id, this.chapter);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        chapter = json['chapter'];

  Map<String, dynamic> toJson() =>
    {
      'name': id,
      'email': chapter,
    };
}


class Address {
  String address, city, state, country, zipcode;

  Address({
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipcode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return new Address(
        address: json['address'],
        city: json['city'],
        state: json['state'],
        country: json['country'],
        zipcode: json['zipcode']);
  }
}


  // get local path of documents directory
//   Future<String> get _localPath async {
//     final directory = await getApplicationDocumentsDirectory();
//     return directory.path;
//   }

//   // get the settings file
//   Future<File> get _localFile async {
//     final path = await _localPath;
//     return new File('$path/$settingsFilename');
//   }

//   // write user setting to file
//   Future<File> writeUserSetting(String setting) async {
//     final file = await _localFile;
//     return file.writeAsString('$setting');
//   }

//     // read the file contents
//   Future<String> getUserSettings() async {
//     String contents;

//   try {
//     final file = await _localFile;

//     // read the file
//     contents = await file.readAsString();

//     } catch(e) {
//      print(e);
//     }

//    return contents;
//   }

//   Future<FileSystemEntity> removeUserSettingsFile() async {

//     final file = await _localFile;
//     return file.delete();
//   }

//   Future<bool> settingsFileExists() async {

//   File settingsFile = await _localFile;

//     if(await settingsFile.exists()) {
//     return true;
//     }

//     return false;
//     }
// }