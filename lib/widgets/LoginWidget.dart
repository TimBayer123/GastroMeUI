import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastrome/animations/ScaleRoute.dart';
import 'package:gastrome/pages/RestaurantItemDetails.dart';
import 'package:gastrome/settings/globals.dart'as globals;
import 'package:gastrome/pages/QrCodeScanner.dart';

//Autor: Tim Bayer
//Diese Klasse stellt den Login Button dar, mit dem ein User in ein Restaurant einchecken kann

//Ein Stateless Widget verändert seinen Inhalt nicht, daher hat es auch keine verknüpfte State-Klasse
class LoginWidget extends StatelessWidget {

  //Funktionsweise: Diese Methode liefert die Oberfläche des Login Buttons
  //Rückgabewert: Die Methode liefert die Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    return InkWell(
      //Bei onTap wird das RestuarantOverlay geschlossen (falls noch geöffnet) und auf den QRCode Scanner weitergeleitet
      onTap: (){
        globals.loggedIn=false;
        if(RestaurantItemDetails.overlayEntry!=null){
          RestaurantItemDetails.overlayEntry.remove();
          RestaurantItemDetails.overlayEntry = null;
        }
        //Hier wird auf den QRCOde Scanner weitergeleitet
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