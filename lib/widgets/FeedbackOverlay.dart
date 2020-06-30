import 'package:flutter/material.dart';

//Autor: Tim Bayer
//Diese Klasse stellt die Oberfläche des Feedback Overlays dar, welches bei direktem und externem Feedback verwendet wird. Sie stellt sozusagen die Basisfläche der Feedback Pages dar.

class FeedbackOverlay extends StatefulWidget {
  Widget child;
  static OverlayEntry overlayEntry;

  //Der Konstruktor der Klasse erfordert ein beliebiges Widget
  FeedbackOverlay({@required this.child});
  @override
  _FeedbackOverlayState createState() => _FeedbackOverlayState();
}

class _FeedbackOverlayState extends State<FeedbackOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  //Funktionsweise: Bei Initialisierung wird ein AnimationController initialisiert. Sind alle Widgets geladen, wird eine das Overlay animiert hineingefahren
  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    super.initState();
    //Hier wird die Animation ausgeführt wenn alle Widgets geladen sind
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        animationController.forward();
      });
    });
  }

  //Funktionsweise: Die Dispose Methode beendet die erstellten Controller, um den Speicherplatz freizugeben
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  //Funktionsweise: Diese Methode liefert die Oberfläche des Feedback Overlays
  //Rückgabewert: Die Methode liefert die Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
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
                    //Schatten des Overlays
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
                      //Basisfläche des Overlays, es besitzt oben abgerundete Ecken
                      child: ClipRRect(
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0)),
                        child: Container(
                          height: MediaQuery.of(context).size.height - 100,
                          color: Theme.of(context).primaryColor,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                    child: widget.child,
                                  )),
                              Positioned(
                                  top: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    //Bei Klick auf das Widget wird das Overlay geschlossen. Dies geschieht animiert
                                    onTap: () {
                                      animationController.reverse();
                                      FeedbackOverlay.overlayEntry = null;
                                      FocusScope.of(context).requestFocus(FocusNode());
                                    },
                                    child: Container(
                                      color: Colors.transparent,
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
                                  )),
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
