
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notetakr/model/assignment.dart';
import 'package:notetakr/model/assignment_model.dart';

class AssignmentChartsPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AssignmentChartState();
  }

}

class AssignmentChartState extends State<AssignmentChartsPage> 
{
  final _model = AssignmentModel(); 
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
      builder: (context,snapshot)
      {
        if(snapshot.hasData)
        {
           var my_map = getAssignmentFreq(snapshot.data);

          
           return Text("My data chart goes here");
        }
        else{
          return CircularProgressIndicator(); 
        }
      }
    );
  }

  Future<List<Assignment>> _getAllAssignments() async
  {
    List<Assignment> my_list = await _model.getAllAssignment(); 
    my_list.forEach((item) => print('inside for each $item'));
    return my_list; 

  }

    

}

Map<String,int> getAssignmentFreq(List<Assignment> mylist)
{
    Map<String,int> my_map; 
    mylist.forEach((item)=> 
    {
      if (my_map.containsKey(item.dueDate))
      {
        my_map[item.dueDate] +=1
      }
      else
      {
        my_map[item.dueDate] =1
      }
    
    });

    return my_map; 
}