import 'package:flutter/material.dart';
import 'package:gastrome/settings/globals.dart';
import 'package:gastrome/widgets/FeedbackOverlay.dart';
import 'package:gastrome/widgets/FullWidthButton.dart';
import 'package:gastrome/widgets/WarningDialog.dart';
import 'package:keyboard_actions/keyboard_action.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

class ExternalFeedback extends StatefulWidget {
  @override
  _ExternalFeedbackState createState() => _ExternalFeedbackState();
}

class _ExternalFeedbackState extends State<ExternalFeedback> with SingleTickerProviderStateMixin {
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
                  sendFeedback(textController.text) :
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

  Future<void> sendFeedback(String text){

  }



}
