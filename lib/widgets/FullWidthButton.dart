import 'package:flutter/material.dart';

class FullWidthButton extends StatefulWidget {
  Function function;
  String buttonText;

  FullWidthButton({@required this.buttonText, @required this.function});

  @override
  _FullWidthButtonState createState() => _FullWidthButtonState();
}

class _FullWidthButtonState extends State<FullWidthButton> {
  bool tapDown = false;

  @override
  Widget build(BuildContext context) {
    return  Listener(
      onPointerDown: onTapFunction,
      onPointerUp: onReleaseFunction,
      child: AnimatedContainer(
        duration: Duration(microseconds: 1),
        curve: Curves.linear,
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: tapDown ? Theme.of(context).accentColor.withOpacity(0.5) : Theme.of(context).accentColor,
            boxShadow: [
              BoxShadow(
                offset: Offset(0.00, 2.00),
                color: Color(0xff000000).withOpacity(0.20),
                blurRadius: 8,
              ),
            ]),
        child: Center(
          child: Text(
            widget.buttonText,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ),
    );
  }

  void onTapFunction(PointerDownEvent details){
      tapDown = true;
      setState(() {});
    widget.function();
  }

  void onReleaseFunction(PointerUpEvent details){
    tapDown = false;
    setState(() {});
  }

}
