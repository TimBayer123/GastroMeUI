import 'package:flutter/material.dart';
import 'package:gastrome/pages/DirectFeedback.dart';
import 'package:gastrome/widgets/FeedbackOverlay.dart';
import 'package:gastrome/widgets/FullWidthButton.dart';

import 'ExternalFeedback.dart';

class FeedbackSelection extends StatelessWidget {
  static OverlayEntry FeedbackOverlay;
  String restaurantName;

  FeedbackSelection({this.restaurantName});

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
                function: () {
                  showFeedbackOverlay(context, DirectFeedback());
                }),
            SizedBox(height: 15),
            FullWidthButton(
              buttonText: 'Externe Bewertung abgeben',
              function: () {
                showFeedbackOverlay(context, ExternalFeedback());
              },
            ),
          ],
        ));
  }
}

void showFeedbackOverlay(BuildContext context, Widget widget) {
  if (FeedbackOverlay.overlayEntry == null) {
    FeedbackOverlay.overlayEntry =
        OverlayEntry(builder: (context) => FeedbackOverlay(child: widget));
    Overlay.of(context).insert(FeedbackOverlay.overlayEntry);
  }

}
