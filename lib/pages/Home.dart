import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  int i;
  Home({this.i});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          color: Colors.red,
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Expanded(
                  flex:1,
                  child: Text(widget.i.toString()),),
              FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: (){
                  widget.i= widget.i+1;
                  setState(() {});
                },
              )


            ],
          ),
        ),
      ),
    );
  }
}
