import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastrome/settings/globals.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class HeadlineWidget extends StatelessWidget {
  String title;
  String subtitle;
  bool callWaiterButton;

  HeadlineWidget({this.title, this.subtitle, this.callWaiterButton});

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
                        Text(title,
                          style: Theme.of(context).textTheme.headline1, textAlign: TextAlign.left,),
                        if(subtitle != null) Text(subtitle,
                          style: Theme.of(context).textTheme.headline2, textAlign: TextAlign.left,)
                      ],
                    ),
                )
            ),
            if(callWaiterButton) InkWell(
              onTap: (){
                callWaiter();
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


      String subject = 'Kellner gerufen von Tisch Nr. '+tischNr;


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
        ..html = "<h1>Kellner gerufen</h1>\n<p>Tisch Nr: "+tischNr+"</p>";

      try {
        final sendReport = await send(body, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
      // DONE

  }
}
