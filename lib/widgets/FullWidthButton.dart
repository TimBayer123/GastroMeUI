import 'package:flutter/material.dart';

class FullWidthButton extends StatelessWidget {
  Function function;
  String buttonText;

  FullWidthButton({@required this.buttonText, @required this.function});

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: function,
      child: Container(
        width: double.infinity,
        height: 71,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).accentColor,
            boxShadow: [
              BoxShadow(
                offset: Offset(0.00, 2.00),
                color: Color(0xff000000).withOpacity(0.20),
                blurRadius: 8,
              ),
            ]),
        child: Center(
          child: Text(
            buttonText,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ),
    );
  }
}
