class Course{
  
  Course({this.id, this.courseName, this.courseCode});
  
  int id;
  String courseName;
  String courseCode;

  Course.fromMap(Map<String,dynamic> map){
    this.id = map['id'];
    this.courseName = map['courseName'];
    this.courseName = map['courseCode'];
  }

  Map<String,dynamic> toMap(){
    return{
      'id': this.id,
      'courseName': this.courseName,
      'courseCode': this.courseCode,
    };
  }

  @override
  String toString() {
    return 'Course(id: $id, courseName: $courseName, courseCode: $courseCode)';
  } 
}