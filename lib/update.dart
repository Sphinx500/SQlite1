import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'students.dart';
import 'crud_operations.dart';
import 'dart:async';
import 'formulario.dart';



class Update extends StatefulWidget {
  @override
  _myUpdatePageState createState() => new _myUpdatePageState();
}

class _myUpdatePageState extends State<Update> {
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

  final formkey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;
  final _scaffoldkey=GlobalKey<ScaffoldState>();
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

  /* void dataValidate() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      if (isUpdating) {
        Student stu = Student(currentUserId, name);
        dbHelper.update(stu);
        setState(() {
          isUpdating = false;
        });
      } else {
        Student stu = Student(null, name);
        dbHelper.insert(stu);
      }
      cleanData();
      refreshList();
    }
  }*/


  //Student e = Student(curUserId, name);

  void updateData(){
    print("Valor de Opción");
    print(opcion);
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      //NOMBRE
      if (opcion==1) {
        Student stu = Student(currentUserId, valor, surname, am, matricula, mail, num);
        dbHelper.update(stu);
      }
      //APELLIDO PATERNO
      else if (opcion==2) {
        Student stu = Student(currentUserId, name, valor, am, matricula, mail, num);
        dbHelper.update(stu);
      }
      //APELLIDO MATERNO
      else if (opcion==3) {
        Student stu = Student(currentUserId, name, surname, valor, matricula, mail, num);
        dbHelper.update(stu);
      }
      //MATRICULA
      else if (opcion==4) {
        Student stu = Student(currentUserId, name, surname, am, valor, mail, num);
        dbHelper.update(stu);
      }
      //EMAIL
      else if (opcion==5) {
        Student stu = Student(currentUserId, name, surname, am, matricula, valor, num);
        dbHelper.update(stu);
      }
      //PHONE
      else if (opcion==6) {
        Student stu = Student(currentUserId, name, surname, am, matricula, mail, valor);
        dbHelper.update(stu);
      }


      cleanData();
      refreshList();
    }
  }

  void insertData() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      {
        Student stu = Student(null, name, surname, am, matricula, mail, num);
        dbHelper.insert(stu);
      }
      cleanData();
      refreshList();
    }
  }
  //Formulario

  Widget form() {
    return Form(
      key: formkey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            new SizedBox(height: 50.0),
            TextFormField(
              controller: controller1,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: descriptive_text),
              validator: (val) => val.length == 0 ? 'Enter Data' : null,
              onSaved: (val) => valor = val,
            ),
            SizedBox(height: 30,),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.black),
                  ),
                  onPressed: updateData,
                  //child: Text(isUpdating ? 'Update ' : 'Add Data'),
                  child: Text('Update Data'),
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.black),
                  ),
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    cleanData();
                    refreshList();
                  },
                  child: Text("Cancel"),
                ),
              ],
            )
          ],
        ),
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
            label: Text("Nombre"),
          ),
          DataColumn(
            label: Text("A. Paterno"),
          ),
          DataColumn(
            label: Text("A. Materno"),
          ),
          DataColumn(
            label: Text("Matricula"),
          ),
          DataColumn(
            label: Text("E-mail"),
          ),
          DataColumn(
            label: Text("Telefono"),
          ),
          DataColumn(
            label: Text("ELIMINAR"),
          ),
        ],
        rows: Studentss.map((student) =>
            DataRow(cells: [
              //NOMBRE 1
              DataCell(Text(student.name.toString().toUpperCase()), onTap: () {
                setState(() {
                  //isUpdating = true;
                  descriptive_text = "Nombre";
                  currentUserId = student.controlum;
                  name = student.name;
                  surname = student.surname;
                  am = student.am;
                  num =student.num;
                  mail = student.mail;
                  matricula = student.matricula;
                  opcion=1;
                });
                controller1.text = student.name;
              }),
              //APELLIDO PATERNO 2
              DataCell(Text(student.surname.toString().toUpperCase()), onTap: () {
                setState(() {
                  //isUpdating = true;
                  descriptive_text = "Apellido Paterno";
                  currentUserId = student.controlum;
                  name = student.name;
                  surname = student.surname;
                  am = student.am;
                  num =student.num;
                  mail = student.mail;
                  matricula = student.matricula;
                  opcion=2;
                });
                controller2.text= student.surname;
              }),
              //APELLIDO MATERNO 3
              DataCell(Text(student.am.toString().toUpperCase()), onTap: () {
                setState(() {
                  //isUpdating = true;
                  descriptive_text = "Apellido Materno";
                  currentUserId = student.controlum;
                  name = student.name;
                  surname = student.surname;
                  am = student.am;
                  num =student.num;
                  mail = student.mail;
                  matricula = student.matricula;
                  opcion=3;
                });
                controller3.text= student.am;
              }),
              //MATRICULA 4
              DataCell(Text(student.matricula.toString().toUpperCase()), onTap: () {
                setState(() {
                  //isUpdating = true;
                  descriptive_text = "Matricula";
                  currentUserId = student.controlum;
                  name = student.name;
                  surname = student.surname;
                  am = student.am;
                  num =student.num;
                  mail = student.mail;
                  matricula = student.matricula;
                  opcion=4;
                });
                controller4.text = student.matricula;
              }),
              DataCell(Text(student.mail.toString().toUpperCase()), onTap: () {
                setState(() {
                  //isUpdating = true;
                  descriptive_text = "E-mail";
                  currentUserId = student.controlum;
                  name = student.name;
                  surname = student.surname;
                  am = student.am;
                  num =student.num;
                  mail = student.mail;
                  matricula = student.matricula;
                  opcion=5;
                });
                controller5.text = student.mail;
              }),
              DataCell(Text(student.num.toString().toUpperCase()), onTap: () {
                setState(() {
                  //isUpdating = true;
                  descriptive_text = "Telefono";
                  currentUserId = student.controlum;
                  name = student.name;
                  surname = student.surname;
                  am = student.am;
                  num =student.num;
                  mail = student.mail;
                  matricula = student.matricula;
                  opcion=6;
                });
                controller6.text = student.num;
              }),
              DataCell(IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  dbHelper.delete(student.controlum);
                  refreshList();
                  // _alert(context, "Elemento eliminado");
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
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text("No data founded!");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
// TODO: implement build
    return new Scaffold(
      key: _scaffoldkey,
      resizeToAvoidBottomInset: false,   //new line
      appBar: new AppBar(
        title: Text('Actualizar Datos'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            form(),
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
