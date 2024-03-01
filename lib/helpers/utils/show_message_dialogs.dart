import 'package:foody/helpers/widgets/my_spacing.dart';
import 'package:foody/helpers/widgets/my_text.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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
              child: MyText.titleLarge(titolo),
            ),
          ],
        ),
        content: MyText.labelMedium(messaggio),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: MyText.labelMedium("Ok"),
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
              child: MyText.titleLarge(titolo),
            ),
          ],
        ),
        content: Container(
            constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
            child: MyText.labelMedium(messaggio, maxLines: 10)),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: MyText.labelMedium("Ok"),
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
              child: MyText.titleLarge(titolo),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: MyText.labelMedium("Ok"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}