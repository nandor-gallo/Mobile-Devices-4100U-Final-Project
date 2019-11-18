class Note {
  Note(
    {
      this.id,
      this.noteName,
      this.dateCreated,
      this.dateEdited,
      this.courseCode,
      this.noteData
    });

  int id;
  String noteName;
  String dateCreated;
  String dateEdited;
  String courseCode;
  String noteData;

  Note.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.noteName = map['noteName'];
    this.dateCreated = map['dateCreated'];
    this.dateEdited = map['dateEdited'];
    this.courseCode = map['courseCode'];
    this.noteData = map['noteData'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'noteName': this.noteName,
      'dateCreated': this.dateCreated,
      'dateEdited': this.dateEdited,
      'courseCode': this.courseCode,
      'noteData': this.noteData,
    };
  }

  @override
  String toString() {
    return 'Note(id: $id, noteName: $noteName, dateCreated: $dateCreated, dateEdited: $dateEdited, courseCode: $courseCode,noteData: $noteData)';
  }
}
