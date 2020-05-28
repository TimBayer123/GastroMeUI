import 'package:flutter/material.dart';
import 'package:gastrome/pages/DirectFeedback.dart';
import 'package:gastrome/widgets/FeedbackOverlay.dart';
import 'package:gastrome/widgets/FullWidthButton.dart';

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
                  showDirectFeedbackOverlay(context, DirectFeedback(restaurantName: restaurantName));
                }),
            SizedBox(height: 15),
            FullWidthButton(
              buttonText: 'Externe Bewertung abgeben',
              function: () {},
            ),
          ],
        ));
  }
}

void showDirectFeedbackOverlay(BuildContext context, Widget widget) {
  if (FeedbackOverlay.overlayEntry == null) {
    FeedbackOverlay.overlayEntry =
        OverlayEntry(builder: (context) => FeedbackOverlay(child: widget));
    Overlay.of(context).insert(FeedbackOverlay.overlayEntry);
  }
}
