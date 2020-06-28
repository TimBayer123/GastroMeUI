import 'package:flutter/material.dart';
import 'package:gastrome/pages/DirectFeedback.dart';
import 'package:gastrome/widgets/FeedbackOverlay.dart';
import 'package:gastrome/widgets/FullWidthButton.dart';

import 'ExternalFeedback.dart';
//Autor: Tim Bayer
//Diese Klasse stellt die Oberfläche für das Nav-Bar Item Feedback bereit.
// Hier kann der User zwischen Esternem oder direktem Feedback wählen

class FeedbackSelection extends StatelessWidget {
  static OverlayEntry FeedbackOverlay;
  String restaurantName;

  FeedbackSelection({this.restaurantName});

  //Funktionsweise: Diese Methode liefert die Oberfläche für den Feedback-Auswahl Screen
  //Rückgabewert: Die Methode liefert die gesamte Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Wie möchtest du Feedback geben?',
                style: Theme.of(context).textTheme.headline1),
            SizedBox(height: 25),
            FullWidthButton(
                buttonText: 'Direkt an Personal',
                //Bei Klick dieses Buttons wird ein FeedbackOverlay mit direktem Feedback geladen
                function: () {
                  showFeedbackOverlay(context, DirectFeedback());
                }),
            SizedBox(height: 15),
            FullWidthButton(
              buttonText: 'Externe Bewertung abgeben',
              //Bei Klick dieses Buttons wird ein FeedbackOverlay mit externem Feedback geladen
              function: () {
                showFeedbackOverlay(context, ExternalFeedback());
              },
            ),
          ],
        ));
  }
}

//Funktionsweise: Es wird ein Overlay geladen, auf dem das Feedback abgegeben werden kann
//Übergabeparameter: Es wird der BuildContext und ein widget übergeben. Das Widget wird den Hauptinhalt des Overlays bestimmen
void showFeedbackOverlay(BuildContext context, Widget widget) {
  if (FeedbackOverlay.overlayEntry == null) {
    FeedbackOverlay.overlayEntry =
        OverlayEntry(builder: (context) => FeedbackOverlay(child: widget));
    Overlay.of(context).insert(FeedbackOverlay.overlayEntry);
  }
}
