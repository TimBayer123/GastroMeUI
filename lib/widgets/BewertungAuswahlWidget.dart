import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastrome/widgets/BewertungenWidget.dart';

class BewertungAuswahlWidget extends StatefulWidget {
  String text;
  BewertungAuswahlWidget({this.text});
  @override
  _BewertungAuswahlWidgetState createState() => _BewertungAuswahlWidgetState();
}

class _BewertungAuswahlWidgetState extends State<BewertungAuswahlWidget> {
  GlobalKey _keyBewertungsWidget = GlobalKey();
  static int value = 0;

  @override
  void initState() {
    value=0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.text,style: Theme.of(context).textTheme.headline4,),
          Listener(
              onPointerDown: (PointerDownEvent event) {
                print(event.position);
                checkTap(event);
                setState(() {});
              },
              child: Container(
                height: 28,
                  key: _keyBewertungsWidget,
                  child: BewertungWidget(anzahl: value))),
        ],
      ),
    );
  }

  void checkTap(PointerDownEvent event) {
    final RenderBox renderBoxRed = _keyBewertungsWidget.currentContext
        .findRenderObject();
    final position = renderBoxRed.localToGlobal(Offset.zero);
    final size = renderBoxRed.size;

    double unitWidth = size.width/5;
    double unit0 = position.dx;
    double unit1 = unit0+unitWidth;
    double unit2 = unit0+2*unitWidth;
    double unit3 = unit0+3*unitWidth;
    double unit4 = unit0+4*unitWidth;
    double unit5 = unit0+5*unitWidth;

    if (event.position.dx > unit0 && event.position.dx < unit1)
      value = 1;
    else if (event.position.dx > unit1 && event.position.dx < unit2)
      value = 2;
    else if (event.position.dx > unit2 && event.position.dx < unit3)
      value = 3;
    else if (event.position.dx > unit3 && event.position.dx < unit4)
      value = 4;
    else if (event.position.dx > unit4 && event.position.dx < unit5)
      value = 5;

}



}
