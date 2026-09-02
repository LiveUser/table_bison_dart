import 'dart:io';
import 'dart:typed_data';
import 'package:bson/bson.dart';

class DbTable{
  DbTable({
    required this.tablePath,
  });
  final String tablePath;
  void createTable(){
    Directory table = Directory(tablePath);
    if(!table.existsSync()){
      table.createSync(recursive: true);
    }
  }
  int createRecord(){
    int uuid = 0;
    do{
      uuid += 1;
    }while(File("$tablePath/$uuid.bson").existsSync());
    File newRecord = File("$tablePath/$uuid.bson");
    newRecord.createSync(recursive: true);
    BsonBinary bson = BsonCodec.serialize(Map<String,dynamic>.from({}));
    newRecord.writeAsBytesSync(bson.byteList);
    return uuid;
  }
  Map<String,dynamic> view(int uuid){
    File record = File("$tablePath/$uuid.bson");
    Uint8List bytes = record.readAsBytesSync();
    try{
      Map<String,dynamic> parsedBSON = BsonCodec.deserialize(BsonBinary.from(bytes));
      parsedBSON.addAll({
        "uuid": uuid,
      });
      return parsedBSON;
    }catch(error){
      return {};
    }
  }
  void insert(int uuid, String key, dynamic value){
    Map<String,dynamic> record = view(uuid);
    record.addAll({
      key: value,
    });
    File recordFile = File("$tablePath/$uuid.bson");
    BsonBinary bson = BsonCodec.serialize(record);
    recordFile.writeAsBytesSync(bson.byteList);
  }
  dynamic get(int uuid, String key){
    return view(uuid)[key];
  }
  void removeRecord(int uuid){
    File record = File("$tablePath/$uuid.bson");
    record.deleteSync();
  }
  void iterator(Function(Map<String,dynamic>) onRecord){
    Directory table = Directory(tablePath);
    List<FileSystemEntity> folderContents = table.listSync();
    for(int i = 0; i < folderContents.length; i++){
      try{
        if(folderContents[i] is File && folderContents[i].path.endsWith(".bson")){
          File record = folderContents[i] as File;
          //Parse and insert the uuid
          String uuidAsString = record.path.substring(record.path.lastIndexOf("/|\\"),record.path.lastIndexOf(".bson"));
          int uuid = int.parse(uuidAsString);
          Map<String,dynamic> parsedBSON = view(uuid);
          onRecord(parsedBSON);
        }
      }catch(err){
        //Ignore corrupted files
      }
    }
  }
}