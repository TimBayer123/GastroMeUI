import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastrome/settings/globals.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:http/http.dart' as http;

class HeadlineWidget extends StatefulWidget {
  String title;
  String subtitle;
  bool callWaiterButton;

  HeadlineWidget({this.title, this.subtitle, this.callWaiterButton});

  @override
  _HeadlineWidgetState createState() => _HeadlineWidgetState();
}

class _HeadlineWidgetState extends State<HeadlineWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.title,
                          style: Theme.of(context).textTheme.headline1, textAlign: TextAlign.left,),
                        if(widget.subtitle != null) Text(widget.subtitle,
                          style: Theme.of(context).textTheme.headline2, textAlign: TextAlign.left,)
                      ],
                    ),
                )
            ),
            if(widget.callWaiterButton) InkWell(
              onTap: (){
                callWaiter();
                showConfirmationDialog();
              },
              child: Container(
                  alignment: Alignment.centerRight,
                  child: FloatingActionButton(
                    elevation: 0,
                    child: Icon(Icons.directions_run, color: Theme.of(context).accentColor),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> callWaiter() async{


      String subject = 'Kellner gerufen von Tisch Nr. '+tischId;


      final smtpServer = gmail(EmailUsername, EmailPassword);
      // Use the SmtpServer class to configure an SMTP server:
      // final smtpServer = SmtpServer('smtp.domain.com');
      // See the named arguments of SmtpServer for further configuration
      // options.

      // Create our message.
      final body = Message()
        ..from = Address(EmailUsername, 'Waiter Tim')
        ..recipients.add(restaurant.email)
      //  ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      //  ..bccRecipients.add(Address('bccAddress@example.com'))
        ..subject = subject
      // ..text = 'This is the plain text.\nThis is line 2 of the text part.'
        ..html = "<h1>Kellner gerufen</h1>\n<p>Tisch Nr: "+tischId+"</p>";

      try {
        final sendReport = await send(body, smtpServer);
        callWaiterUpdateDB();
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
      // DONE
  }

  Future<void> callWaiterUpdateDB() async {
    var response = await http.patch(gastroMeApiUrl + '/tisch/' + tischId + '/kellner',
    headers: { gastroMeApiAuthTokenName: gastroMeApiAuthTokenValue });

    if(response.statusCode == 200){
      //TODO Handle Success
    } else {
      //TODO Handle Error
    }
  }

  Future<void> showConfirmationDialog(){
    // set up the AlertDialog
    AlertDialog confirmationDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text("Kellner gerufen"),
      content: Text("Ein Kellner macht sich in Kürze auf den Weg zu dir"),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return confirmationDialog;
      },
    );
    closeConfirmationDialog();
  }

  Future<void> closeConfirmationDialog(){
    Future.delayed(Duration(seconds: 2)).then((value) => Navigator.pop(context));
  }
}
