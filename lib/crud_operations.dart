import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'students.dart';
import 'package:path/path.dart';



class DBHelper {
  static Database _db;
  static const String Id = 'controlum';
  static const String NAME = 'name';
  static const String SURNAME = 'surname';
  static const String AM = 'am';
  static const String MAIL = 'mail';
  static const String NUM = 'num';
  static const String MATRICULA = 'matricula';
  static const String TABLE = 'Students';
  static const String DB_NAME = 'students09.db';


//creacion de la base de datos

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    else {
      _db = await initDb();
      return _db;
    }
  }

  initDb() async {
    io.Directory appDirectory = await getApplicationDocumentsDirectory();
    print(appDirectory);
    String path = join(appDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }


  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($Id INTEGER PRIMARY KEY, $NAME TEXT, $SURNAME TEXT, $AM TEXT, $MATRICULA TEXT, $MAIL TEXT, $NUM TEXT )");
  }

  Future<List<Student>> getStudents() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [Id, SURNAME, AM, MATRICULA, MAIL, NUM ]);
    List<Student> studentss = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        studentss.add(Student.fromMap(maps[i]));
      }
    }
    return studentss;
  }

//Save or insert
  Future<Student> insert(Student student) async {
    var dbClient = await db;
    student.controlum = await dbClient.insert(TABLE, student.toMap());
    return student;
  }

//Delete
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$Id = ?', whereArgs: [id]);
  }

//Update
  Future<int> update(Student student) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, student.toMap(), where: '$Id = ?',
        whereArgs: [student.controlum]);
  }

  //Modificacion para la matricula
  Future<bool> validateInsert(Student student) async {
    var dbClient = await db;
    var code = student.matricula;
    List<Map> maps = await dbClient
    //CONSULTA SI LA MATRICULA SE ENCUENTRA EN LA BASE
        .rawQuery("select $Id from $TABLE where $MATRICULA = $code");
    if (maps.length == 0) {
      return true;
    }else{
      return false;
    }
  }
  Future<List<Student>>Busqueda(String buscado)async{
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE WHERE $MATRICULA LIKE '$buscado%'");
    List<Student> studentss = [];
    print(maps);
    if(maps.length > 0){
      for(int i = 0; i<maps.length; i++){
        studentss.add(Student.fromMap(maps[i]));
      }
    }
    return studentss;
  }


//Close Database
  Future closedb() async {
    var dbClient = await db;
    dbClient.close();
  }
}