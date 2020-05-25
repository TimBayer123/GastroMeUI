import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastrome/entities/Restaurant.dart';
import 'package:gastrome/widgets/BewertungenWidget.dart';
import 'package:gastrome/widgets/RestaurantMapsWidget.dart';

class RestaurantItemDetails extends StatefulWidget {
  static OverlayEntry overlayEntry;
  Restaurant restaurant;
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
  double containerHeight;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
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
                                          Positioned(
                                              top: 10,
                                              right: 10,
                                              child: GestureDetector(
                                                onTap: () {
                                                  animationController.reverse();
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
                                          RestaurantMapsWidget(widget.restaurant),

                                          Positioned(
                                            top: 30,
                                            left: 30,
                                            child: Container(
                                              width: MediaQuery.of(context).size.width - 60,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    widget.restaurant.name,
                                                    style: Theme.of(context).textTheme.headline1,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  BewertungenWidget(restaurant: widget.restaurant),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    widget.restaurant.beschreibung.replaceAll("\r", "").replaceAll("\n", ""),
                                                    overflow: TextOverflow.ellipsis,
                                                    style: Theme.of(context).textTheme.bodyText1,
                                                    maxLines: 4,
                                                  ),
                                                  Icon(
                                                    Icons.keyboard_arrow_down,
                                                    size: 20,
                                                    color: Colors.black54,
                                                  ),
                                                  SizedBox(
                                                    height: 200,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      Text(
                                                        "Speisekarte einsehen ",
                                                        style: Theme.of(context).textTheme.bodyText1,
                                                      ),
                                                      Icon(
                                                        Icons.keyboard_arrow_down,
                                                        size: 20,
                                                        color: Colors.black54,
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
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
        ),
      ),
    );

  }
}
