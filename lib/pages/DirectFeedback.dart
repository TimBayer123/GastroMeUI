import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gastrome/settings/globals.dart';
import 'package:gastrome/widgets/FeedbackOverlay.dart';
import 'package:gastrome/widgets/FullWidthButton.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:http/http.dart' as http;

//Autor: Tim Bayer
//Diese Klasse beschreibt den Screen, um direktes Feedback an das Personal abzugeben

class DirectFeedback extends StatefulWidget {

  @override
  _DirectFeedbackState createState() => _DirectFeedbackState();
}

class _DirectFeedbackState extends State<DirectFeedback> with SingleTickerProviderStateMixin{
  TextEditingController textController;
  FocusNode textfieldNode = FocusNode();
  TabController tabController;

//Funktionsweise: Diese Methode wird bei Initialisierung des Screens ausgeführt. Dabei wird ein TextController und ein TabConrtoller initialisiert
  @override
  void initState() {
    textController = new TextEditingController();
    tabController = new TabController(vsync: this, length: 3, initialIndex: 1);
    super.initState();
  }

  //Funktionsweise: Diese Methode liefert die Oberfläche des Direct Feedback-Screens
  //Rückgabewert: Die Methode liefert die gesamte Oberfläche in Form eines Widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        //Die KeyboardActions passen die OnScreen-Tastatur an. Es wird ein "Fertig" Button obehalb der Tastatur platziert.
        child: KeyboardActions(
          config: _buildConfig(context),
          //Die ListView wird benötigt, um den gesamten Inhalt scrollbar zu machen. Wird die Tastur asugefahren, überschreitet der Inhalt die Bildschrimgröße und es kann gescrollt werden
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                child: Text(restaurant.name, style: Theme.of(context).textTheme.headline1),
              ),
              Text('Feedback an Personal', style: Theme.of(context).textTheme.headline2),
              SizedBox(height: 20),
              //In diesem Widget befinden sich die Tabs
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
              //In diesem Widget befindet sich das TextField
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
                //Wird auf den Button getappt wird die folgende Funktion ausgeführt.
                function: (){
                  if(textController.text!=""){
                    //Ist eine Anmerkung eingetragen, wird das Feedback per Email und per Request an das Backend versendet
                    sendFeedback(tabController.index, textController.text);
                    sendFeedbackToBackend(textController.text, tabController.index);
                  } else{
                    //Ist keine Anmerkung eingertagen erscheint ein Hinweis-Dialog
                    showConfirmationDialog("Du hast keine Anmerkung verfasst, bitte versuche es erneut");
                  }

                },
              )

            ],
          ),
        ),
      ),
    );
  }

  //Funktionsweise: Die Dispose Methode beendet die erstellten Controller, um den Speicherplatz freizugeben
  @override
  void dispose() {
    tabController.dispose();
    textController.dispose();
    super.dispose();
  }

 //Funktionsweise; In dieser Methode wird die Tastaur-Konfiguration erstellt
  //Rückgabewert: Es wird ein Konfigurationsobjekt zurückgeliefert
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


  //Funktionsweise: In dieser Methode wird das Feedback via Email an die hinterlegte Email-gesendet
  //Rückgabewert: Es wird lediglich ein Future void zurückgeliefert, aufgrund der asynchronen Sendung
  Future<void> sendFeedback(int index, String message) async {

    String tag = index!=0 ? (index!=1 ? 'Sonstiges' : 'Essen') : 'Service';
    String subject = 'Feedback zu '+tag;

    final smtpServer = gmail(EmailUsername, EmailPassword);

    final body = Message()
      ..from = Address(EmailUsername, 'Waiter Tim')
      ..recipients.add(restaurant.email)
      ..subject = subject
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
  }

  //Funktionsweise: In dieser Methode wird das Feedback via Request an das Backend gesendet. Dies geschieht asynchron
  //Rückgabewert: Es wird ein Future bool zurückgeliefert, wenn die Sendung erfolgreich war.
  Future<bool> sendFeedbackToBackend(String anmerkung, int index) async{
    String tag = index!=0 ? (index!=1 ? 'Sonstiges' : 'Essen') : 'Service';

    var response = await http.post(gastroMeApiUrl + '/feedback/add/?restaurantId='+restaurant.id+'&kategorie='+tag+'&anmerkung='+anmerkung,
        headers: { gastroMeApiAuthTokenName: gastroMeApiAuthTokenValue , 'Content-Type' : 'application/json'});
    print(response.statusCode);
    if(response.statusCode == 200){
      showConfirmationDialog('Dein Feedback wurde erfolgreich übermittelt. Vielen Dank');
      print('erfolgreich versendet');

    } else {
      showConfirmationDialog('Dein Feedback konnte leider nicht erfolgreich übermittelt werden. Es ist ein Fehler aufgetreten. Bitte versuchen sie es erneut');
    }

    return true;
  }

  //Funktionsweise: Diese Methode erstellt ein AlertDialog, der angezeigt werden kann
  //Übergabeparameter: Es wird der Texgt übergeben, der angezeigt wird.
  Future<void> showConfirmationDialog(String text){
    // set up the AlertDialog
    AlertDialog confirmationDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text("Feedback bearbeitet"),
      content: Text(text),
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

  //Funktionsweise: Diese Methode schließt den AlertDialog.
  Future<void> closeConfirmationDialog(){
    // Future.delayed(Duration(seconds: 2)).then((value) => Navigator.pop(context));
    FeedbackOverlay.overlayEntry.remove();
    FeedbackOverlay.overlayEntry=null;
  }

  //Funktionsweise: Diese Methode überschreibt die setState Methode, es wird geprüft ob der Inhalt noch angezeigt wird, ansonsten würde dies zu einem Fehler führen
  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

}

