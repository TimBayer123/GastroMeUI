import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastrome/settings/globals.dart';
import 'package:gastrome/widgets/BewertungAuswahlWidget.dart';
import 'package:gastrome/widgets/FeedbackOverlay.dart';
import 'package:gastrome/widgets/FullWidthButton.dart';
import 'package:keyboard_actions/keyboard_action.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:http/http.dart' as http;

//Autor: Tim Bayer
//Diese Klasse stellt den externen Feedback-Screen bereit

class ExternalFeedback extends StatefulWidget {
  @override
  _ExternalFeedbackState createState() => _ExternalFeedbackState();
}

class _ExternalFeedbackState extends State<ExternalFeedback> with SingleTickerProviderStateMixin {
  TextEditingController textController;
  FocusNode textfieldNode = FocusNode();
  TabController tabController;
  int essen = 0, atmosphaere = 0, service = 0, preise = 0, sonderwuensche = 0;

//Funktionsweise: Diese Methode wird bei Initialisierung des Screens ausgeführt. Dabei wird ein TextController und ein TabConrtoller initialisiert
  @override
  void initState() {
    textController = new TextEditingController();
    tabController = new TabController(vsync: this, length: 3, initialIndex: 1);
    super.initState();
  }

  //Funktionsweise: Diese Methode liefert die Oberfläche des externen Feedback-Screens
  //Rückgabewert: Die Methode liefert die gesamte Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        //Die KeyboardActions passen die OnScreen-Tastatur an. Es wird ein "Fertig" Button obehalb der Tastatur platziert.
        child: KeyboardActions(
          config: _buildConfig(context),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                child: Text(restaurant.name, style: Theme.of(context).textTheme.headline1),
              ),
              Text('Externe Bewertung', style: Theme.of(context).textTheme.headline2),
              SizedBox(height: 20),
              //In diesem Widget können die Kategorien bewertet werden
              //Dies ist über einen Klick auf den jeweiligen Stern möglich
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BewertungAuswahlWidget(text: 'Essen', value: essen,
                  onValueSelect: (value){
                    setState(() {
                      essen = value;
                    });
                  },
                  ),
                  BewertungAuswahlWidget(text: 'Atmosphäre', value: atmosphaere,
                    onValueSelect: (value){
                    setState(() {
                      atmosphaere = value;
                    });

                    },),
                  BewertungAuswahlWidget(text: 'Service', value: service,
                    onValueSelect: (value){
                    setState(() {
                      service = value;
                    });

                    },),
                  BewertungAuswahlWidget(text: 'Preise', value: preise,
                    onValueSelect: (value){
                      setState(() {
                        preise = value;
                      });

                    },),
                  BewertungAuswahlWidget(text: 'Sonderwünsche', value: sonderwuensche,
                    onValueSelect: (value){
                      setState(() {
                        sonderwuensche = value;
                      });

                    },),

                ],
              ),

              SizedBox(height: 20),
              Text('Anmerkung', style: Theme.of(context).textTheme.headline5),
              SizedBox(height: 10),
              //In diesem Widget befindet sich das Text Feld der Anmerkung
              Card(
                color: Colors.white,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: textController,
                    autocorrect: true,
                    minLines: 5,
                    maxLines: 5,
                    decoration: InputDecoration.collapsed(hintText: "Gebe hier dein Feedback ab"),
                    keyboardType: TextInputType.multiline,
                    focusNode: textfieldNode,
                  ),
                ),
              ),
              SizedBox(height: 20),
              FullWidthButton(
                buttonText: 'Absenden',
                //Bei Klick des Buttons wird das Feedback abgesendet
                function: (){
                  sendFeedback(textController.text);
                },
              ),
              SizedBox(height: 20),

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

  //Funktionsweise: In dieser Methode wird das Feedback an das Backend gesendet. Dies geschieht asynchron
  //Übergabeparameter: Die Anmerkung, die gesendet werden soll wird übergeben
  //Rückgabewert: Es wird ein Future bool geliefert, ob das Senden erfolgreich war
  Future<bool> sendFeedback(String anmerkung) async{
    if(anmerkung=="" || essen==0 || service==0 || atmosphaere ==0 || sonderwuensche==0 || preise==0){
      showConfirmationDialog("Du hast deine Bewertung leider unvollständig abgeschickt. Bitte versuche es erneut");
      return false;
    }


    var response = await http.post(gastroMeApiUrl + '/rezession/add/?restaurantId='+restaurant.id+'&essen='+essen.toString()+'&atmosphaere='+atmosphaere.toString()
        +'&service='+service.toString()+'&preise='+preise.toString()+'&sonderwuensche='+sonderwuensche.toString()+'&anmerkung='+anmerkung
        ,
    headers: { gastroMeApiAuthTokenName: gastroMeApiAuthTokenValue , 'Content-Type' : 'application/json'});
    print(response.statusCode);
    if(response.statusCode == 200){
    showConfirmationDialog('Ihre Rezession wurde erfolgreich übermittelt. Vielen Dank');
    print('erfolgreich versendet');

    } else {
    showConfirmationDialog('Ihre Rezession konnte leider nicht erfolgreich übermittelt werden. Es ist ein Fehler aufgetreten. Bitte versuchen sie es erneut');
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
      title: Text("Rezession bearbeitet"),
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
