import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notetakr/model/assignment.dart';
import 'package:notetakr/model/assignment_model.dart';
import 'app_localizations.dart';


/*
Page to display graphs from the assignments 
Uses a dataframe to display all the assignments. 
Dependencies: 
Assignment class from package Model 
Assignment_Model class from package Model 
*/ 

class AssignmentChartsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AssignmentChartState();
  }
}

class AssignmentChartState extends State<AssignmentChartsPage> {
  final _model = AssignmentModel();
  List<Assignment> my_list;
  List<Assignment> selected_list;

  /// Create one series with sample hard coded data.
  List<charts.Series<AssignmentSeries, int>> _createSampleData(
      List<AssignmentSeries> data) {
    return [
      new charts.Series<AssignmentSeries, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (AssignmentSeries asign, _) => asign.series_id,
        measureFn: (AssignmentSeries asign, _) => asign.count,
        data: data,
      )
    ];
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getAllAssignments(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //var my_map = getAssignmentFreq(snapshot.data);
            my_list = snapshot.data;
            //var series = getAssignmentSeries(my_list);
            return SingleChildScrollView(
                child: Column(children: <Widget>[
              SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text(AppLocalizations.of(context)
                            .translate('assign_name_string')),
                        numeric: false,
                      ),
                      DataColumn(
                        label: Text(AppLocalizations.of(context)
                            .translate('duedate_string')),
                        numeric: false,
                      )
                    ],
                    rows: my_list
                        .map((item) => DataRow(cells: [
                              DataCell(Text(item.assignmentName)),
                              DataCell(
                                Text(item.dueDate),
                              )
                            ]))
                        .toList(),
                  )),
              Container(
                  padding: EdgeInsets.all(4),
                  child: SizedBox(
                      width: 300,
                      height: 200,
                      child: charts.LineChart(
                        _createSampleData(_getAssignmentSeries(snapshot.data)),
                        animate: false,
                      )))
            ]));
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Future<List<Assignment>> _getAllAssignments() async {
    List<Assignment> my_list = await _model.getAllAssignments();
    return my_list;
  }
}

Map<String, int> getAssignmentFreq(List<Assignment> mylist) {
  Map<String, int> my_map = new Map();
  mylist.forEach((item) => {
        if (my_map.containsKey(item.dueDate))
          {my_map[item.dueDate] += 1}
        else
          {my_map[item.dueDate] = 1}
      });

  return my_map;
}

List<AssignmentSeries> _getAssignmentSeries(List<Assignment> my_list) {
  List<AssignmentSeries> output = new List();
  int id = 0;
  var dict = getAssignmentFreq(my_list);
  dict.forEach((k, v) => {output.add(new AssignmentSeries(id, k, v)), id += 1});
  return output;
}

class AssignmentSeries {
  int series_id;
  final String date;
  final int count;

  AssignmentSeries(this.series_id, this.date, this.count);
}
