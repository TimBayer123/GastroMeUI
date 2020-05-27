import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastrome/widgets/FullWidthButton.dart';

class DirectFeedback extends StatefulWidget {
  @override
  _DirectFeedbackState createState() => _DirectFeedbackState();
}

class _DirectFeedbackState extends State<DirectFeedback> {


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: DefaultTabController(
        initialIndex: 1,
        length: 3,
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Feedback an Personal', style: Theme.of(context).textTheme.headline2),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                    color: Colors.black12,
                    blurRadius: 3,
                    offset: new Offset(0.0, 2.0),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border:Border.all(
                      color: Theme.of(context).accentColor,
                      width: 1
                    ),
                  ),
                  child: TabBar(
                    unselectedLabelColor: Colors.black,
                    labelStyle: Theme.of(context).textTheme.headline6,
                    labelColor: Colors.white,
                    indicator: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        //borderRadius: BorderRadius.circular(10)
                    ),
                    tabs: [
                      Tab(text: 'Service',),
                      Tab(text: 'Essen'),
                      Tab(text: 'Sonstiges'),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
            Text('Anmerkung', style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 10),
            Card(
              color: Colors.white,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: 6,
                  decoration: InputDecoration.collapsed(hintText: "Gebe hier dein Feedback ab"),
                  keyboardType: TextInputType.multiline,
                ),
              ),
            ),
            SizedBox(height: 20),
            FullWidthButton(
              buttonText: 'Absenden',
              function: (){},
            )

          ],
        ),
      ),
    );
  }
}

