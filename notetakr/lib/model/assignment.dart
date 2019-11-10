class Assignment{
  
  Assignment({this.id, this.name, this.courseId, this.dueDate, this.dueAlert});

  int id;
  String name;
  String courseId;
  String dueDate;
  String dueAlert;

  Assignment.fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.name = map['name'];
    this.courseId = map['courseId'];
    this.dueDate = map['dueDate'];
    this.dueDate = map['id'];
  }

  Map<String,dynamic> toMap(){
    return{
      'id': this.id,
      'name': this.name,
      'courseId': this.courseId,
      'dueDate': this.dueDate,
      'dueAlert': this.dueAlert,
    };
  }

  @override
  String toString() {
    return 'Assignment(id: $id, name: $name, courseId: $courseId, dueDate: $dueDate, dueAlert: $dueAlert)';
  }
}