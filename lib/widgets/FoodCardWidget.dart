import 'package:flutter/material.dart';
import 'package:gastrome/entities/Speise.dart';
import 'package:gastrome/entities/SpeisekartenItem.dart';
import 'package:gastrome/pages/MenuItemDetails.dart';
import 'package:gastrome/widgets/PlaceholderWidget.dart';

class FoodCardWidget extends StatelessWidget {
  SpeisekartenItem item;
  FoodCardWidget({this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        OverlayEntry overlayEntry;
        overlayEntry = OverlayEntry(builder: (context) => MenuItemDetails(item: item, overlayEntry: overlayEntry));
        Overlay.of(context).insert(overlayEntry);
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
                            Text(item.name, style: Theme.of(context).textTheme.headline5),
                            SizedBox(height: 5),
                            Text(item.beschreibung, style: Theme.of(context).textTheme.bodyText1),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(null),
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
}
