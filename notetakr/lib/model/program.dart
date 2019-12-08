// To parse this JSON data, do
//
//     final program = programFromJson(jsonString);

import 'dart:convert';

Program programFromJson(String str) => Program.fromJson(json.decode(str));

String programToJson(Program data) => json.encode(data.toJson());

class Program {
  Programs programs;

  Program({
    this.programs,
  });

  factory Program.fromJson(Map<String, dynamic> json) => Program(
        programs: Programs.fromJson(json["programs"]),
      );

  Map<String, dynamic> toJson() => {
        "programs": programs.toJson(),
      };
}

class Programs {
  String title;
  String description;
  List<ProgramElement> program;

  Programs({
    this.title,
    this.description,
    this.program,
  });

  factory Programs.fromJson(Map<String, dynamic> json) => Programs(
        title: json["title"],
        description: json["description"],
        program: List<ProgramElement>.from(
            json["program"].map((x) => ProgramElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "program": List<dynamic>.from(program.map((x) => x.toJson())),
      };
}

class ProgramElement {
  Faculty faculty;
  String title;
  String link;
  List<ProgramType> programType;
  String summary;

  ProgramElement({
    this.faculty,
    this.title,
    this.link,
    this.programType,
    this.summary,
  });

  factory ProgramElement.fromJson(Map<String, dynamic> json) => ProgramElement(
        faculty: facultyValues.map[json["faculty"]],
        title: json["title"],
        link: json["link"],
        programType: List<ProgramType>.from(
            json["program_type"].map((x) => programTypeValues.map[x])),
        summary: json["summary"],
      );

  Map<String, dynamic> toJson() => {
        "faculty": facultyValues.reverse[faculty],
        "title": title,
        "link": link,
        "program_type": List<dynamic>.from(
            programType.map((x) => programTypeValues.reverse[x])),
        "summary": summary,
      };
}

enum Faculty {
  FACULTY_OF_BUSINESS_AND_INFORMATION_TECHNOLOGY,
  FACULTY_OF_EDUCATION,
  FACULTY_OF_ENERGY_SYSTEMS_AND_NUCLEAR_SCIENCE,
  FACULTY_OF_ENGINEERING_AND_APPLIED_SCIENCE,
  FACULTY_OF_HEALTH_SCIENCES,
  FACULTY_OF_SCIENCE,
  FACULTY_OF_SOCIAL_SCIENCE_AND_HUMANITIES
}

final facultyValues = EnumValues({
  "Faculty of Business and Information Technology":
      Faculty.FACULTY_OF_BUSINESS_AND_INFORMATION_TECHNOLOGY,
  "Faculty of Education": Faculty.FACULTY_OF_EDUCATION,
  "Faculty of Energy Systems and Nuclear Science":
      Faculty.FACULTY_OF_ENERGY_SYSTEMS_AND_NUCLEAR_SCIENCE,
  "Faculty of Engineering and Applied Science":
      Faculty.FACULTY_OF_ENGINEERING_AND_APPLIED_SCIENCE,
  "Faculty of Health Sciences": Faculty.FACULTY_OF_HEALTH_SCIENCES,
  "Faculty of Science": Faculty.FACULTY_OF_SCIENCE,
  "Faculty of Social Science and Humanities":
      Faculty.FACULTY_OF_SOCIAL_SCIENCE_AND_HUMANITIES
});

enum ProgramType {
  UNDERGRADUATE,
  GRADUATE,
  CO_OP_OR_INTERNSHIP,
  PATHWAYS_DIPLOMA_TO_DEGREE,
  ONLINE,
  PROFESSIONAL
}

final programTypeValues = EnumValues({
  "Co-op or Internship": ProgramType.CO_OP_OR_INTERNSHIP,
  "Graduate": ProgramType.GRADUATE,
  "Online": ProgramType.ONLINE,
  "Pathways Diploma-to-Degree": ProgramType.PATHWAYS_DIPLOMA_TO_DEGREE,
  "Professional": ProgramType.PROFESSIONAL,
  "Undergraduate": ProgramType.UNDERGRADUATE
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
