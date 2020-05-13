import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastrome/entities/SpeisekartenItem.dart';

class MenuItemDetails extends StatelessWidget {

  static OverlayEntry overlayEntry;
  SpeisekartenItem item;
  MenuItemDetails({this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          color: Colors.transparent,
          height: 45,
        ),

        ClipRRect(
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(40.0),
              topRight: const Radius.circular(40.0)),
          child: Container(
            height: MediaQuery.of(context).size.height-100,
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 3/1.5,
                  child: Stack(
                    children: [
                      Container(
                        decoration: new BoxDecoration(
                            image: new DecorationImage(
                              fit: BoxFit.fitWidth,
                              alignment: FractionalOffset.center,
                              image: Image.memory(item.bild).image
                            ),
                            ),
                      ),
                      Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: (){
                              overlayEntry.remove();
                              overlayEntry=null;
                            },
                            child: Container(
                              color: Colors.transparent,
                              width: 50,
                              height:50,
                              child: Center(
                                child: Icon(
                                    Icons.close,
                                color: Theme.of(context).accentIconTheme.color,
                                size: 30,),
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
                              Text(item.name,
                                  style: Theme.of(context).textTheme.headline1),
                              Icon(Icons.beenhere, color: Colors.green),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                            child: Text(item.beschreibung, style: Theme.of(context).textTheme.bodyText2,),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                            child: Text('Allergene', style: Theme.of(context).textTheme.bodyText2),
                          ),
                          Row(
                            children: [
                              Icon(Icons.assessment, color: Colors.red, size: 30,),
                              Icon(Icons.assignment, color: Colors.orange, size: 30),
                              Icon(Icons.assignment_late, color: Colors.grey, size: 30),
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
      ],
    );
  }

  static OverlayEntry getOverlay(){
    return overlayEntry;
  }
}
