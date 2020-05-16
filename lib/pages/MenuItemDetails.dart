import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastrome/entities/Allergen.dart';
import 'package:gastrome/entities/Getraenk.dart';
import 'package:gastrome/entities/Speise.dart';
import 'package:gastrome/entities/SpeisekartenItem.dart';
import 'package:gastrome/widgets/AllergeneIcons.dart';
import 'package:gastrome/widgets/VeganVegieIcons.dart';

class MenuItemDetails extends StatefulWidget {
  static OverlayEntry overlayEntry;
  Getraenk getraenk;
  Speise speise;
  MenuItemDetails({this.speise, this.getraenk});

  @override
  _MenuItemDetailsState createState() => _MenuItemDetailsState();

  static OverlayEntry getOverlay() {
    return overlayEntry;
  }
}

class _MenuItemDetailsState extends State<MenuItemDetails>
    with SingleTickerProviderStateMixin {
  dynamic item;
  AnimationController animationController;
  double containerHeight;

  @override
  void initState() {
    if (widget.speise != null)
      item = widget.speise;
    else if (widget.getraenk != null) item = widget.getraenk;

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.of(context).size.height - 55,
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
                                            image:
                                                Image.memory(item.bild).image),
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
                                                color: Theme.of(context)
                                                    .accentIconTheme
                                                    .color,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(item.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline1),
                                            item.vegan
                                                ? VeganIcon()
                                                : item.vegie
                                                    ? VegieIcon()
                                                    : SizedBox(width: 50),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 30, 0, 30),
                                          child: Text(
                                            item.beschreibung,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 20, 0, 10),
                                          child: Text('Allergene',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4),
                                        ),
                                        Row(
                                          children: [
                                            item.allergene.toString().contains(
                                                    "Glutenhaltiges Getreide")
                                                ? WheatIcon()
                                                : SizedBox(
                                                    width: 0,
                                                  ),
                                            item.allergene
                                                    .toString()
                                                    .contains('Eier')
                                                ? EggIcon()
                                                : SizedBox(
                                                    width: 0,
                                                  ),
                                            item.allergene
                                                    .toString()
                                                    .contains('Erdnüsse')
                                                ? NutsIcon()
                                                : SizedBox(
                                                    width: 0,
                                                  ),
                                            item.allergene
                                                .toString()
                                                .contains('Milch und Milchprodukte')
                                                ? MilkIcon()
                                                : SizedBox(
                                              width: 0,
                                            ),
                                            !item.allergene
                                                        .toString()
                                                        .contains('Erdnüsse') &&
                                                    !item.allergene
                                                        .toString()
                                                        .contains(
                                                            "Glutenhaltiges Getreide") &&
                                                    !item.allergene
                                                        .toString()
                                                        .contains('Eier') &&
                                                !item.allergene
                                                    .toString()
                                                    .contains('Milch und Milchprodukte')
                                                ? Text(
                                                    "Keine Allergene enthalten",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4,
                                                  )
                                                : SizedBox(
                                                    width: 0,
                                                  ),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
