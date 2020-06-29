import 'package:flutter/material.dart';
import 'package:gastrome/entities/Restaurant.dart';
import 'package:gastrome/pages/RestaurantItemDetails.dart';

//Autor: Tim Riebesam
//Diese Klasse stellt das ListenObjekt dar, welches in der Klasse RestaurantOverview.dart verwendet wird. Es beeinhaltet Informationen über das jeweilige Restausrant

class RestaurantCardWidget extends StatefulWidget {
  final Restaurant restaurant;

  //Der Konstruktor der Klasse besteht aus dem Restaurant
  const RestaurantCardWidget ({this.restaurant });

  @override
  _RestaurantCardWidgetState createState() => _RestaurantCardWidgetState();
}

class _RestaurantCardWidgetState extends State<RestaurantCardWidget>{
  @override
  void initState() {
    super.initState();
  }

  //Funktionsweise: Diese Methode liefert die Oberfläche des RestaurantCardWidget
  //Die Methode besitzt keine tiefere Logik, es werden ausschließlich die Daten des Restaurant-Objektes in entsprechenden UI-Objekten angezeigt.
  //Allerdings wird bei einem Klick auf das erzeugte Objekt die Methode showDetailsOverlay aufgerufen. Der BuildContext wird dabei weitergereicht.
  //Rückgabewert: Die Methode liefert die gesamte Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                        child: Image.memory(widget.restaurant.bild)
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Container(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          widget.restaurant.name,
                                          style: Theme.of(context).textTheme.headline6,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,),
                                        Container(
                                          alignment: Alignment.topRight,
                                          child: Row(
                                            children: <Widget>[
                                              Text(widget.restaurant.getGesamtbewertung(), style: Theme.of(context).textTheme.headline6),
                                              Icon(Icons.star_border, size: 18, color: Theme.of(context).accentColor,),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      widget.restaurant.beschreibung.replaceAll("\n", " ").replaceAll("\r", ""),
                                      style: Theme.of(context).textTheme.bodyText1,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,),
                                    SizedBox(height: 3),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          widget.restaurant.getEntfernungAsString(),
                                          style: Theme.of(context).textTheme.bodyText2,),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }

  //Funktionsweise: Diese Methode sorgt dafür, dass die Klasse RestaurantItemDetails als Overlay angezeigt wird.
  //Übergabeparameter: Der BuildContext wird übergeben
  void showDetailsOverlay(BuildContext context) {
    if(widget.restaurant!=null && RestaurantItemDetails.overlayEntry==null){
      RestaurantItemDetails.overlayEntry = OverlayEntry(builder: (context) => RestaurantItemDetails(restaurant: widget.restaurant));
      Overlay.of(context).insert(RestaurantItemDetails.overlayEntry);
    }
  }

}
