import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  int i;

  Home({this.i});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String username;
  String password;
  String basicAuth;

  @override
  void initState() {
    username = 'user';
    password = '904fe4e0-75f6-450b-b052-4730373e17d3';
    basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          color: Colors.deepOrangeAccent,
          alignment: Alignment.center,
          child: FutureBuilder(

            future: http.get('http://10.0.2.2:8084/restaurant/get/all', headers: <String, String>{'authorization': basicAuth}),
              builder:(context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Container(
                     child: Text(snapshot.data.body,
                     style: TextStyle(
                         color: Colors.black,
                         fontSize: 14,
                     ),),
                  );
                }
              }
          )


        ),
    ),
    );







  }
}
