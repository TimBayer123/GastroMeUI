import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  //Der foodAreaActive Parameter gibt an, ob der Essensreiter oder der Profilreiter aktiviert sein soll
  bool foodAreaActive;

  @override
  final Size preferredSize;

  TopBar({@required this.foodAreaActive})
      : preferredSize = Size(double.infinity, 100);

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.preferredSize.width,
      height: widget.preferredSize.height,
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.restaurant_menu, color: widget.foodAreaActive ? Theme.of(context).accentIconTheme.color : Theme.of(context).primaryIconTheme.color),
                  iconSize: 30,
                  onPressed: (){
                    widget.foodAreaActive = true;
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  iconSize: 30,
                  icon: Icon(Icons.person, color: !widget.foodAreaActive ? Theme.of(context).accentIconTheme.color : Theme.of(context).primaryIconTheme.color),
                  onPressed: (){
                    widget.foodAreaActive = false;
                    setState(() {});
                  },
                ),
              )
            ],
          ),
        ),
      ),

    );

  }
}
