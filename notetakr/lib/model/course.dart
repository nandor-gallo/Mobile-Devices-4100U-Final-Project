class Course {
  Course({
    this.id,
    this.courseName,
    this.courseCode,
    this.courseDays,
    this.courseTime,
    this.courseDesc,
    this.courseType,
  });

  int id;
  String courseName;
  String courseCode;
  String courseTime;
  String courseDays;
  String courseDesc;
  String courseType;

  Course.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.courseName = map['courseName'];
    this.courseName = map['courseCode'];
    this.courseTime = map['courseTime'];
    this.courseDays = map['courseDays'];
    this.courseDesc = map['courseDesc'];
    this.courseType = map['courseType'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'courseName': this.courseName,
      'courseCode': this.courseCode,
      'courseDays': this.courseDays,
      'courseTime': this.courseTime,
      'courseDesc': this.courseDesc,
      'courseType': this.courseType,
    };
  }

  @override
  String toString() {
    return 'Course(id: $id, courseName: $courseName, courseCode: $courseCode, courseDays: $courseDays, courseTime: $courseTime, courseDesc: $courseDesc, courseType: $courseType)';
  }
}
