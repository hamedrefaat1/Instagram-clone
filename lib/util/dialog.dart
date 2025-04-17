import 'package:flutter/material.dart';

Future<void> dialogBuilder(BuildContext context, String massage) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Error",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Text(
            massage,
            style: const TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK" , style: TextStyle(color: Colors.black),))
          ],
        );
      });
}
