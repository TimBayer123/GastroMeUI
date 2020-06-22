import 'package:flutter/material.dart';
import 'package:gastrome/entities/Rezession.dart';
import 'package:gastrome/widgets/BewertungenSmallWidget.dart';

class RezessionItemWidget extends StatelessWidget {
  Rezession rezession;
  RezessionItemWidget({this.rezession});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(rezession.anmerkung, style: Theme.of(context).textTheme.bodyText1),
              ),
              Expanded(

                  child: BewertungenSmallWidget(bewertung: rezession.bewertung)),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
