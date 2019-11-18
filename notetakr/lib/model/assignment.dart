class Assignment{
  
  Assignment({this.id, this.assignmentName, this.courseId, this.dueDate, this.dueAlert});

  int id;
  String assignmentName;
  String courseId;
  String dueDate;
  String dueAlert;

  Assignment.fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.assignmentName = map['assignmentName'];
    this.courseId = map['courseId'];
    this.dueDate = map['dueDate'];
    this.dueAlert = map['dueAlert'];
  }

  Map<String,dynamic> toMap(){
    return{
      'id': this.id,
      'assignmentName': this.assignmentName,
      'courseId': this.courseId,
      'dueDate': this.dueDate,
      'dueAlert': this.dueAlert,
    };
  }

  @override
  String toString() {
    return 'Assignment(id: $id, assignmentName: $assignmentName, courseId: $courseId, dueDate: $dueDate, dueAlert: $dueAlert)';
  }
}