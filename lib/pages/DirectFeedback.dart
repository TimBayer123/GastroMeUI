import 'package:flutter/material.dart';

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
        length: 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Feedback an Personal', style: Theme.of(context).textTheme.headline1,),
            SizedBox(height: 15),
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              constraints: BoxConstraints.expand(height: 50),
              child: TabBar(
                indicator: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                tabs: [
                  Tab(text: 'Service',),
                  Tab(text: 'Essen'),
                  Tab(text: 'Sonstiges'),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
