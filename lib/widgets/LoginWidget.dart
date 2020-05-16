import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastrome/animations/ScaleRoute.dart';
import 'package:gastrome/settings/globals.dart'as globals;
import 'package:gastrome/pages/QrCodeScanner.dart';

class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        globals.loggedIn=false;
        Navigator.push(context, ScaleRoute(page: QrCodeScan()),
        );
      },
      child: Container(
        color: Theme.of(context).accentColor,
        height: 80,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(3.5, 0, 3, 0),
                  child: FaIcon(FontAwesomeIcons.qrcode, size: 35, color: Theme.of(context).primaryColor),
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 3
                  ),
                ),
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