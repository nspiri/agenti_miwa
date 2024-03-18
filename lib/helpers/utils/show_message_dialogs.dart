import 'package:foody/helpers/widgets/my_text.dart';
import 'package:flutter/material.dart';

showErrorMessage(BuildContext context, String titolo, String messaggio) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(
              size: 50,
              Icons.cancel,
              color: Colors.red,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: MyText.titleSmall(titolo),
            ),
          ],
        ),
        content: Container(
            constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
            child: MyText.labelSmall(messaggio, maxLines: 10)),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: MyText.labelSmall("Ok"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

showAlertMessage(BuildContext context, String titolo, String messaggio) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(
              size: 50,
              Icons.error,
              color: Colors.orange,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  MyText.titleSmall(
                    titolo,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Container(
            constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
            child: MyText.labelSmall(messaggio, maxLines: 10)),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: MyText.labelSmall("Ok"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

showSuccessMessage(BuildContext context, String titolo, String messaggio) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(
              size: 50,
              Icons.done_outline,
              color: Colors.green,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: MyText.titleSmall(titolo),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: MyText.labelSmall("Ok"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
