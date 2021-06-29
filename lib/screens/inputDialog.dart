import 'package:flutter/material.dart';

Future<String> inputDialog(
    BuildContext context, TextEditingController textController,
    {String mainTitle = 'Title',
    String lableText = 'Label text',
    String textHint = 'hint'}) async {
  return showDialog(
    context: context,
    barrierDismissible:
        false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(mainTitle),
        content: new Row(
          children: <Widget>[
            new Expanded(
                child: new TextField(
              autofocus: true,
              decoration:
                  new InputDecoration(labelText: lableText, hintText: textHint),
              controller: textController,
            ))
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
              return textController.text.toString();
            },
          ),
        ],
      );
    },
  );
}
