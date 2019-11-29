import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notetakr/model/assignment.dart';
import 'package:notetakr/model/assignment_model.dart';

 class AssignmentChartsPage extends StatefulWidget {
  @override
   State<StatefulWidget> createState() {
    // TODO: implement createState
     return AssignmentChartState();
   }
 }

 class AssignmentChartState extends State<AssignmentChartsPage> {
  final _model = AssignmentModel();
  List<Assignment> my_list;
  List<Assignment> selected_list; 


 /// Create one series with sample hard coded data.
static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
   @override
   void setState(fn) {
     // TODO: implement setState
     super.setState(fn);
   }

   @override
   Widget build(BuildContext context) {
     // TODO: implement build
     return FutureBuilder(
         future: _getAllAssignments(),
         builder: (context, snapshot) {
           if (snapshot.hasData) {
             //var my_map = getAssignmentFreq(snapshot.data);
              my_list = snapshot.data;
              //var series = getAssignmentSeries(my_list);
             return SingleChildScrollView(
             child: Column(
                children:<Widget> [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: [
                    DataColumn(
                      label: Text("Assignment Name"),
                      numeric: false,
                    ),
                    DataColumn(
                      label: Text("Due Date"),
                      numeric: false,
                    )
                    ],
                    
                    rows:  
                  
                    my_list.map(
                      (item) => DataRow(
                        cells: [
                          DataCell(
                            Text(item.assignmentName)
                          ),
                          DataCell(
                            Text(item.dueDate),
                          )
                        ]
                      )
                    ).toList(),
                    
                    
                  )

                ),
                Container(
                padding: EdgeInsets.all(4),
                child: SizedBox(
                width: 300,
                height: 200,
                child: charts.LineChart(_createSampleData(),animate: false,)
                )
                
                )
                ]
             ));
           } else {
             return CircularProgressIndicator();
           }
         });
   }

   Future<List<Assignment>> _getAllAssignments() async {
     List<Assignment> my_list = await _model.getAllAssignments();
     my_list.forEach((item) => print('inside for each $item'));
     return my_list;
   }
 }

 Map<String, int> getAssignmentFreq(List<Assignment> mylist) {
   Map<String, int> my_map;
 mylist.forEach((item) => {
         if (my_map.containsKey(item.dueDate))
           {my_map[item.dueDate] += 1}
         else
          {my_map[item.dueDate] = 1}
       });

   return my_map;
 }

 List<charts.Series<String,int>> getAssignmentSeries(List<Assignment> my_list)
 {

    var dict = getAssignmentFreq(my_list);
    return [charts.Series(
      id:"Assignments",
      data: dict.keys,

    )];

 }


class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}