import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gastrome/settings/globals.dart';
import 'package:gastrome/widgets/FeedbackOverlay.dart';
import 'package:gastrome/widgets/FullWidthButton.dart';
import 'package:gastrome/widgets/WarningDialog.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class DirectFeedback extends StatefulWidget {

  @override
  _DirectFeedbackState createState() => _DirectFeedbackState();
}

class _DirectFeedbackState extends State<DirectFeedback> with SingleTickerProviderStateMixin{
  TextEditingController textController;
  FocusNode textfieldNode = FocusNode();
  TabController tabController;


  @override
  void initState() {
    textController = new TextEditingController();
    tabController = new TabController(vsync: this, length: 3, initialIndex: 1);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        child: KeyboardActions(
          config: _buildConfig(context),
          child: ListView(

           // crossAxisAlignment: CrossAxisAlignment.start,
           // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                child: Text(restaurant.name, style: Theme.of(context).textTheme.headline1),
              ),
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
                      controller: tabController,
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
                    controller: textController,
                    autocorrect: true,
                    minLines: 6,
                    maxLines: 6,
                    decoration: InputDecoration.collapsed(hintText: "Gebe hier dein Feedback ab"),
                    keyboardType: TextInputType.multiline,
                    focusNode: textfieldNode,
                  ),
                ),
              ),
              SizedBox(height: 20),
              FullWidthButton(
                buttonText: 'Absenden',
                function: (){
                  textController.text!="" ?
                    sendFeedback(tabController.index, textController.text) :
                  showDialog(
                      context: context,
                      builder: (context) => WarningDialog(
                        text: "Du hast keine Anmerkung verfasst. Bitte verfasse zuerst eine Anmerkung vor dem Senden",
                        textJa: "Okei",
                        textNein: "",
                      )
                  )?? false;
                  FeedbackOverlay.overlayEntry.remove();
                  FeedbackOverlay.overlayEntry=null;

                },
              )

            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    textController.dispose();
    super.dispose();
  }

  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Theme.of(context).accentColor,
      nextFocus: false,
      actions: [
        KeyboardAction(focusNode: textfieldNode, toolbarButtons: [
              (node) {
            return GestureDetector(
              onTap: () => node.unfocus(),
              child: Container(
                width: 100,
                height: 100,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('Fertig', style: TextStyle(
                      fontFamily: 'lato',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ))
                  ),
                ),
              ),
            );
          }
        ]),
      ],
    );
  }

  Future<void> sendFeedback(int index, String message) async {

    String tag = index!=0 ? (index!=1 ? 'Sonstiges' : 'Essen') : 'Service';
    String subject = 'Feedback zu '+tag;


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
      ..html = "<h1>Kategorie: "+tag+"</h1>\n<p>"+message+"</p>";

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

