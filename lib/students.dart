class Student{
  int controlum;
  String name;
  String surname;
  String mail;
  String num;
  String am;
  String matricula;
  Student(this.controlum, this.name, this.surname, this.am,this.matricula, this.mail, this.num);
  Map<String,dynamic>toMap(){
    var map = <String,dynamic>{
      'controlum':controlum,
      'name':name,
      'surname':surname,
      'am':am,
      'matricula':matricula,
      'mail':mail,
      'num':num


    };
    return map;
  }
  Student.fromMap(Map<String,dynamic> map){
    controlum=map['controlum'];
    name=map['name'];
    surname=map['surname'];
    am=map['am'];
    matricula=map['matricula'];
    mail=map['mail'];
    num=map['num'];


  }
}