import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTask extends StatefulWidget {
  EditTask({ this.title, this.duedate,this.note,this.index});
  
  final String title;
  final String note;
  final DateTime duedate;
  final index;
  @override
  _EditTaskState createState() => new _EditTaskState();
}

class _EditTaskState extends State<EditTask> {

  TextEditingController controllerTitle;
  TextEditingController controllernote;  

  DateTime _dueDate ;
  String _dateText = '';
  String newTask ;
  String note;

  void _editTask() {
    Firestore.instance.runTransaction((Transaction transaction) async {

      DocumentSnapshot snapshot = await transaction.get(widget.index);
      await transaction.update(snapshot.reference, {
        "title" : newTask,
        "note"  :note,
        "duedate" :_dueDate


      }
      );

    });

    Navigator.pop(context);
  }



  Future<Null> _selectDueDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _dueDate,
        firstDate: DateTime(2018),
        lastDate: DateTime(2080));

    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dateText = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  

  @override
  void initState() {
    
    super.initState();
    _dueDate = widget.duedate;
    _dateText = "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}";

    newTask = widget.title;
    note = widget.note;



    controllerTitle = new TextEditingController(text: widget.title);
     controllernote = new TextEditingController(text: widget.note);
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
        child: Column(
      children: <Widget>[
        Container(
          height: 200.0,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bluewhite.jpg"),
                  fit: BoxFit.cover),
              color: Colors.blue),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "My Practicum Log",
                  style: new TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      letterSpacing: 2.0,
                      fontFamily: 'Chewy'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    "edit task",
                    style: new TextStyle(fontSize: 24.0, color: Colors.black),
                  ),
                ),
                Icon(
                  Icons.list,
                  color: Colors.black,
                  size: 30.0,
                )
              ]),
        ),
        new Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: controllerTitle,
              onChanged: (String str) {
                setState(() {
                  newTask = str;
                });
              },
              decoration: new InputDecoration(
                  icon: Icon(Icons.dashboard),
                  hintText: "Task title",
                  border: InputBorder.none),
              style: new TextStyle(fontSize: 22.0, color: Colors.black)),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: new Icon(Icons.date_range),
              ),
              new Expanded(
                  child: Text(
                "Date",
                style: new TextStyle(fontSize: 22.0, color: Colors.black),
              )),
              new FlatButton(
                  onPressed: () => _selectDueDate(context),
                  child: Text(
                    _dateText,
                    style: new TextStyle(fontSize: 22.0, color: Colors.black),
                  )),
            ],
          ),
        ),
        new Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: controllernote,
              onChanged: (String str) {
                setState(() {
                  note = str;
                });
              },
              decoration: new InputDecoration(
                  icon: Icon(Icons.note),
                  hintText: "Details",
                  border: InputBorder.none),
              style: new TextStyle(fontSize: 22.0, color: Colors.black)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.check, size: 40.0),
                onPressed: () {
                  _editTask();
                },
              ),
              IconButton(
                icon: Icon(Icons.close, size: 40.0),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        )
      ],
    ));
  }
}
