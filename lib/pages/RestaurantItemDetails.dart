import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastrome/entities/Restaurant.dart';
import 'package:gastrome/widgets/BewertungenWidget.dart';
import 'package:gastrome/widgets/MenuLogedOutWidget.dart';
import 'package:gastrome/widgets/RestaurantMapsWidget.dart';
import 'package:gastrome/widgets/RezessionenWidget.dart';

//Autor: Tim Riebesam, Tim Bayer
//Diese Klasse stellt den Restaurant-Detail-Screen dar. Es werden alle Informationen des Restaurants angezeigt.

class RestaurantItemDetails extends StatefulWidget {
  static OverlayEntry overlayEntry;
  Restaurant restaurant;
  //Der Konstruktor der Klasse besteht aus dem Restaurant
  RestaurantItemDetails({this.restaurant});

  @override
  _RestaurantItemDetailsState createState() => _RestaurantItemDetailsState();

  static OverlayEntry getOverlay() {
    return overlayEntry;
  }
}

class _RestaurantItemDetailsState extends State<RestaurantItemDetails>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  ScrollController scrollController;
  double containerHeight;
  bool showRezessionen = false;
  bool showSpeisekarte = false;
  bool showBeschreibung = false;

  @override
  void initState() {
    showRezessionen = false;
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    scrollController = new ScrollController();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        animationController.forward();
      });
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  //Funktionsweise: Diese Methode liefert die Oberfläche des Restaurant-Detail-Screen zurück
  //Rückgabewert: Die Methode liefert die gesamte Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height - 80,
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizeTransition(
                  sizeFactor: animationController,
                  axis: Axis.vertical,
                  axisAlignment: -1,
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Colors.transparent,
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(40.0),
                          topRight: const Radius.circular(40.0)),
                          boxShadow: <BoxShadow>[
                            new BoxShadow(
                              color: Colors.black26,
                              blurRadius: 2.0,
                              offset: new Offset(0.0, -2.0),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(40.0),
                              topRight: const Radius.circular(40.0)
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height - 125,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).primaryColor,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        //width: MediaQuery.of(context).size.width - 60,
                                        child: ListView(
                                          controller: scrollController,
                                          padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                                          scrollDirection: Axis.vertical,
                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              widget.restaurant.name,
                                              style: Theme.of(context).textTheme.headline1,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            //Einbindung des BewertungenWidget
                                            BewertungenWidget(restaurant: widget.restaurant,
                                               onRezessionenClick: (bool showRezessionen){
                                                    this.showRezessionen == true ?
                                                      this.showRezessionen = false :
                                                        this.showRezessionen = true;
                                                    setState(() {});
                                                    return this.showRezessionen;
                                               }),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            AnimatedContainer(
                                              duration: Duration(seconds: 1),
                                              height: showRezessionen ? (RezessionenWidget.rezessionenKey.currentContext!=null?(RezessionenWidget.rezessionenKey.currentContext.findRenderObject() as RenderBox).size.height:0) : 0,
                                              curve: Curves.fastOutSlowIn,
                                              //Einbindung des RezessionenWidget
                                              child: RezessionenWidget(
                                                restaurantId: widget.restaurant.id,
                                              ),
                                            ),
                                            AnimatedContainer(
                                              duration: Duration(seconds: 1),
                                              curve: Curves.fastOutSlowIn,
                                              //Auf dem nachfolgenden Bereich liegt ein GestureDetector, bei einer Berührnug bzw. Tap auf diesem Bereich wird eine Funktion getriggert. In diesem Fall wird der Text der Restaurantbeschreibung ausgeklappt bzw. geschlossen.
                                              child: GestureDetector(
                                                onTap: (){
                                                  setState(() {
                                                    this.showBeschreibung ? this.showBeschreibung = false : this.showBeschreibung = true;
                                                  });
                                                },
                                                child: Column(
                                                  children: <Widget>[
                                                    Text(
                                                      widget.restaurant.beschreibung.replaceAll("\r", "").replaceAll("\n", ""),
                                                      style: Theme.of(context).textTheme.bodyText1,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: showBeschreibung == true ? 100 : 5,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Text(showBeschreibung ? "weniger" : "mehr", style: Theme.of(context).textTheme.bodyText1,),
                                                        Icon(showBeschreibung ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.black, size: 14,)
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            //Einbindung des RestaurantMapsWidget
                                            RestaurantMapsWidget(widget.restaurant),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            //Weiterer GestureDetector für ausklappen der Speisekarte im ausgeloggten Modus
                                            GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  this.showSpeisekarte == true ? this.showSpeisekarte = false : this.showSpeisekarte = true;
                                                  this.showSpeisekarte ? scrollController.animateTo(0, duration: Duration(seconds:1), curve: Curves.fastOutSlowIn):null;
                                                });

                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  Text(
                                                    showSpeisekarte ? "Speisekarte ausblenden " : "Speisekarte einsehen ",
                                                    style: Theme.of(context).textTheme.headline4,
                                                  ),
                                                  Icon(
                                                    showSpeisekarte ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                                    size: 20,
                                                    color: Colors.black54,
                                                  )
                                                ],
                                              ),
                                            ),
                                            AnimatedContainer(
                                              duration: Duration(milliseconds: 10),
                                              height: showSpeisekarte ? 560 : 0,
                                              curve: Curves.fastOutSlowIn,
                                              onEnd: (){
                                                scrollController.animateTo(540, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
                                              },
                                              //Einbindung des MenuLogedOutWidget.
                                              child: MenuLogedOutWidget(restaurant: widget.restaurant),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                          top: 10,
                                          right: 10,
                                          child: GestureDetector(
                                            onTap: () {
                                              animationController.reverse();
                                              RestaurantItemDetails.overlayEntry.remove();
                                              RestaurantItemDetails.overlayEntry=null;
                                            },
                                            child: Container(
                                              //color: Colors.transparent,
                                              width: 50,
                                              height: 50,
                                              child: Center(
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.black87,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          )
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
          ),
        ),
      ],
    );

  }
}
