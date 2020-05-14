import 'package:flutter/material.dart';
import 'package:gastrome/MainLayout.dart';
import 'package:gastrome/animations/ScaleRoute.dart';
import 'package:gastrome/animations/SlideRightRoute.dart';
import 'package:gastrome/settings/globals.dart'as globals;

class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        globals.loggedIn=true;
        Navigator.push(context, ScaleRoute(page: MainLayout(navBarindex: 0,loggedIn: true)),
        );
      },
      child: Container(
        color: Theme.of(context).accentColor,
        height: 80,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.settings_overscan,
              color: Theme.of(context).primaryColor,
              size: 40,
            ),
            SizedBox(width: 20),
            Text('Check-In',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Lato',
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                )),
          ],
        ),
      ),
    );
  }
}