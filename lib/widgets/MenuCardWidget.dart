import 'package:flutter/material.dart';
import 'package:gastrome/entities/Getraenk.dart';
import 'package:gastrome/entities/Speise.dart';
import 'package:gastrome/pages/MenuItemDetails.dart';
import 'package:gastrome/widgets/MarqueeWidget.dart';
import 'package:gastrome/widgets/VeganVegieIcons.dart';

//Autor: Tim Bayer, Tim Riebesam
//Diese Klasse stellt ein Eintrag in der Speisekarte dar

class MenuCardWidget extends StatefulWidget {

  Speise speise;
  Getraenk getraenk;
  //Der Konstruktor der Klasse empfängt eine Speise oder ein Getränk
  MenuCardWidget({this.speise, this.getraenk});

  @override
  _MenuCardWidgetState createState() => _MenuCardWidgetState();
}

class _MenuCardWidgetState extends State<MenuCardWidget> {
  var item;

  //Bei Initialisierung wird geprüft, ob das dem Konstruktor eine Speise oder ein Getränk übergeben wurde und entsprechend das Item gesetzt
  @override
  void initState() {
    if(widget.speise!=null)
      item=widget.speise;
    else if(widget.getraenk!=null)
      item=widget.getraenk;
    super.initState();
  }

  //Funktionsweise: Diese Methode liefert die Oberfläche eines Speisekarteneintrags
  //Rückgabewert: Die Methode liefert die Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    return InkWell(
      //Wird auf ein Item geklickt, wird die Detailaufsicht des Items aufgerufen
      onTap: (){
        showDetailsOverlay(context);
      },
        child: Card(
            margin: EdgeInsets.fromLTRB(2.0, 0.0, 4.0, 16.0),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              height: 100,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        bottomLeft: const Radius.circular(10.0)),
                    child: Container(
                        width: 100,
                        child: Image.memory(item.bild)
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MarqueeWidget(
                              direction: Axis.horizontal,
                              child: Text(
                                  item.name,
                                  style: Theme.of(context).textTheme.headline5
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                                item.beschreibung,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText1
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,8,8),
                        //Hier werden die Vegan/Vegie Icons eingebunden
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            item.vegan
                                ? VeganIcon()
                                : item.vegie
                                ? VegieIcon()
                                : SizedBox(width: 50),
                            Text(item.preis.toString()+'0 €', style: Theme.of(context).textTheme.headline6)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
        )

    );
  }

  //Funktionsweise: Es werden die Details eines Items in einem Pverlay angezeigt. Dies wird in dieser Methode instantiiert
  //Übergabeparameter: Es wird der BuildContext übergeben
  void showDetailsOverlay(BuildContext context) {
    if(widget.speise!=null && MenuItemDetails.overlayEntry==null){
      MenuItemDetails.overlayEntry = OverlayEntry(builder: (context) => MenuItemDetails(speise: item));
      Overlay.of(context).insert(MenuItemDetails.overlayEntry);
    }
    else if(widget.getraenk!=null && MenuItemDetails.overlayEntry==null){
      MenuItemDetails.overlayEntry = OverlayEntry(builder: (context) => MenuItemDetails(getraenk: item));
      Overlay.of(context).insert(MenuItemDetails.overlayEntry);
    }

  }
}
