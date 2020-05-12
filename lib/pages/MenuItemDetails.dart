import 'package:flutter/material.dart';
import 'package:gastrome/entities/SpeisekartenItem.dart';

class MenuItemDetails extends StatelessWidget {
  OverlayEntry overlayEntry;
  SpeisekartenItem item;
  MenuItemDetails({this.item, this.overlayEntry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(40.0),
              topRight: const Radius.circular(40.0)),
          child: GestureDetector(
            onTap: (){
              overlayEntry.remove();
            },
            child: Container(
              height: MediaQuery.of(context).size.height-MediaQuery.of(context).size.height/17,
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 3/1.5,
                    child: Container(

                      decoration: new BoxDecoration(
                          image: new DecorationImage(
                            fit: BoxFit.fitWidth,
                            alignment: FractionalOffset.center,
                            image: Image.memory(item.bild).image
                          ),
                          ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
