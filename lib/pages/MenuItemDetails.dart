import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:gastrome/entities/SpeisekartenItem.dart';

class MenuItemDetails extends StatefulWidget {
  static OverlayEntry overlayEntry;
  SpeisekartenItem item;
  MenuItemDetails({this.item});

  @override
  _MenuItemDetailsState createState() => _MenuItemDetailsState();

  static OverlayEntry getOverlay() {
    return overlayEntry;
  }
}

class _MenuItemDetailsState extends State<MenuItemDetails> with SingleTickerProviderStateMixin{
  AnimationController animationController;
  double containerHeight;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250)
    );
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.of(context).size.height-55,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                color: Colors.transparent,
                height: 45,
              ),
              SizeTransition(
                sizeFactor: animationController,
                axis: Axis.vertical,
                axisAlignment: -1,
                child: Container(
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
                        topRight: const Radius.circular(40.0)),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 100,
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 3 / 1.5,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                        fit: BoxFit.fitWidth,
                                        alignment: FractionalOffset.center,
                                        image: Image.memory(widget.item.bild).image),
                                  ),
                                ),
                                Positioned(
                                    top: 10,
                                    right: 10,
                                    child: GestureDetector(
                                      onTap: () {
                                        animationController.reverse();
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        width: 50,
                                        height: 50,
                                        child: Center(
                                          child: Icon(
                                            Icons.close,
                                            color:
                                                Theme.of(context).accentIconTheme.color,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: Theme.of(context).primaryColor,
                              child: Padding(
                                padding: EdgeInsets.all(30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(widget.item.name,
                                            style:
                                                Theme.of(context).textTheme.headline1),
                                        Icon(Icons.beenhere, color: Colors.green),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                                      child: Text(
                                        widget.item.beschreibung,
                                        style: Theme.of(context).textTheme.headline4,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                                      child: Text('Allergene',
                                          style: Theme.of(context).textTheme.headline4),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.assessment,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                        Icon(Icons.assignment,
                                            color: Colors.orange, size: 30),
                                        Icon(Icons.assignment_late,
                                            color: Colors.grey, size: 30),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
