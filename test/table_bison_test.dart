import 'package:table_bison/table_bison.dart';
import 'package:test/test.dart';

void main() {
  test('Basic Test', () {
    DbTable dbTable = DbTable(tablePath: "./inventory");
    dbTable.createTable();
    int uuid = dbTable.createRecord();
    dbTable.insert(uuid, "item", "eggs");
    dbTable.insert(uuid, "price", 3.58);
    double price = dbTable.get(uuid, "price");
    print("Eggs price is \$$price");
    print(dbTable.view(uuid));
    dbTable.iterator((record){
      print(record);
    });
    dbTable.removeRecord(uuid);
  });
}
