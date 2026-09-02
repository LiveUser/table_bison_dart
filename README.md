# Table Bison
A BSON based data storage system. Hecho en Puerto Rico por Radamés Jomuel Valentín Reyes
## This is a rewrite of my Rust library [table_bison](https://crates.io/crates/table_bison)

## Class
- DbTable
An object with a file system path pointing to the folder where all of the table data will be stored.
~~~rs
DbTable{
    tablePath:String,
}
~~~
## Methods
- create_table
Creates the folder that DbTable table_path points to.
- create_record
Creates an object (you may also see it as a row if you come from SQL) and returns its uuid
- view
Returns a Map for the given uuid.
- insert
Inserts data into the object with the specified uuid
- get
Gets the corresponding value for a given a uuid and key.
- remove_record
Deletes the object with the specified uuid
- iterator
Allows to easily index through a table


## Full example
~~~dart
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
~~~