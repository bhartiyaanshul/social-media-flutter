import 'package:flutter/material.dart';

class ConfirmBox extends StatelessWidget {

  final String action;
  const ConfirmBox({super.key, required this.action});

  @override
  Widget build(context) {
    return AlertDialog(
      content: Container(
        height: 90,
        // padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            Text("Are you sure you want to $action?"),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text("Yes")),
                const SizedBox(width: 20,),
                // Spacer(),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text("No"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
