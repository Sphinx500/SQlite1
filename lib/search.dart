import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'students.dart';
import 'crud_operations.dart';

class busca extends StatefulWidget {
  @override
  _MySearch createState() => new _MySearch();
}

class _MySearch extends State<busca> {
  Future<List<Student>> Studentss;
  TextEditingController controller_bus = TextEditingController();

  String name;
  String surname;
  String am;
  String matricula;
  String mail;
  String num;

  int currentUserId;
  var bdHelper;
  bool isUpdating;
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    bdHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = bdHelper.Busqueda(controller_bus.text);
    });
  }

  void cleanData() {
    controller_bus.text = "";
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
          DataColumn(label: Text("Delete")
          ),
        ],
        rows: Studentss.map(
                (student) =>
                DataRow(cells: [
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
                      bdHelper.delete(student.controlum);
                      refreshList();
                    },
                  )),
                ])
        ).toList(),
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: isUpdating ? TextField(
          autofocus: true,
          controller: controller_bus,
          onChanged: (text){
            refreshList();
          },
        ):Text("Busqueda por nombre"),
        leading: IconButton(
          icon: Icon(isUpdating ? Icons.done: Icons.search),
          onPressed: (){
            print("Is typing" + isUpdating.toString());
            setState(() {
              isUpdating =!isUpdating;
              controller_bus.text = "";
            });
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
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
}