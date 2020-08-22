import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite1/search.dart';
import 'package:sqlite1/update.dart';
import 'students.dart';
import 'crud_operations.dart';
import 'dart:async';
import 'formulario.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.purple,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<homePage> {
  //Variable referentes al manejo de la BD
  Future<List<Student>> Studentss;
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();

  String name;
  String surname;
  String am;
  String matricula;
  String mail;
  String num;

  String valor;
  int currentUserId;
  int opcion;

  String descriptive_text = "Student Name";

  var dbHelper;
  bool isUpdating;

  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  //select
  void refreshList() {
    setState(() {
      Studentss = dbHelper.getStudents();
    });
  }

  void cleanData() {
    controller1.text = "";
    controller2.text = "";
    controller3.text = "";
    controller4.text = "";
    controller5.text = "";
    controller6.text = "";
  }

  void dataValidate() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      if (isUpdating) {
        Student stu =
            Student(currentUserId, name, surname, am, matricula, mail, num);
        dbHelper.update(stu);
        setState(() {
          isUpdating = false;
        });
      } else {
        Student stu = Student(null, name, surname, am, matricula, mail, num);
        dbHelper.insert(stu);
      }
      cleanData();
      refreshList();
    }
  }

  Widget menu() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Text(
              "MENU",
              style: TextStyle(color: Colors.white, fontSize: 25),
              textAlign: TextAlign.center,
            ),
            decoration: BoxDecoration(color: Colors.purple),
          ),
          ListTile(
            leading: Icon(Icons.pages),
            title: Text('FORMULARIO'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => formulario()));
            },
          ),
          ListTile(
            leading: Icon(Icons.pages),
            title: Text('ACTUALIZAR DATOS'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Update()));
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('BUSQUEDA'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => busca()));
            },
          ),
          ListTile(
            leading: Icon(Icons.update),
            title: Text('ACTUALIZAR TABLA'),
            onTap: () {
              refreshList();
            },
          ),
      ListTile(
        leading: Icon(Icons.close),
        title: Text('CERRAR MENÚ'),
        onTap: () {
          Navigator.pop(context);
        },
      )
        ],
      ),
    );
  }

  //Mostrar datos
  SingleChildScrollView dataTable(List<Student> Studentss) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text("Control"),
          ),
          DataColumn(
            label: Text("Name"),
          ),
          DataColumn(
            label: Text("Surname1"),
          ),
          DataColumn(
            label: Text("Surname2"),
          ),
          DataColumn(
            label: Text("Student ID"),
          ),
          DataColumn(
            label: Text("Mail"),
          ),
          DataColumn(
            label: Text("Numero"),
          ),
          DataColumn(label: Text("Delete")),
        ],
        rows: Studentss.map((student) => DataRow(cells: [
              DataCell(Text(student.controlum.toString())),
              DataCell(Text(student.name.toString().toUpperCase())),
              DataCell(Text(student.surname.toString().toUpperCase())),
              DataCell(Text(student.am.toString().toUpperCase())),
              DataCell(Text(student.matricula.toString().toUpperCase())),
              DataCell(Text(student.mail.toString().toUpperCase())),
              DataCell(Text(student.num.toString().toUpperCase())),
              DataCell(IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  dbHelper.delete(student.controlum);
                  refreshList();
                  _alert(context, "Elemento eliminado");
                },
              )),
            ])).toList(),
      ),
    );
  }

  Widget list() {
    return Expanded(
      child: FutureBuilder(
        future: Studentss,
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text("Not data founded");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  final formkey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: _scaffoldkey,
      drawer: menu(),
      appBar: new AppBar(
        title: Text("Basic SQL operations"),
        backgroundColor: Colors.deepPurple,
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            list(),
          ],
        ),
      ),
    );
  }

  _alert(BuildContext, String texto) {
    final snackbar = SnackBar(
      content: new Text(texto),
      backgroundColor: Colors.purple,
    );
    _scaffoldkey.currentState.showSnackBar(snackbar);
  }
}
