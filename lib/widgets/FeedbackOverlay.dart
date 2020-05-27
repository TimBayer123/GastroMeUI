import 'package:flutter/material.dart';

class FeedbackOverlay extends StatefulWidget {
  Widget child;
  static OverlayEntry overlayEntry;
  String restaurantName;

  FeedbackOverlay({@required this.child, @required this.restaurantName});
  @override
  _FeedbackOverlayState createState() => _FeedbackOverlayState();
}

class _FeedbackOverlayState extends State<FeedbackOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
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
                          color: Theme.of(context).primaryColor,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(30, 130, 30, 0),
                                     child: widget.child,
                              )),
                              Positioned(
                                  top: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      animationController.reverse();
                                      FeedbackOverlay.overlayEntry = null;
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
                              Positioned(
                                  top: 80,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                  child: Text(widget.restaurantName, style: Theme.of(context).textTheme.headline1,),
                                ),
                              )
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
