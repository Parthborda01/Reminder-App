
import 'dart:ui';

import 'package:flutter/material.dart';

class DialogBox{

  static Widget installConform(context, {required String timeTableName, required String batch, void Function()? onConform}){
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 4, sigmaX: 4),
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(style: Theme.of(context).textTheme.titleMedium, children: <TextSpan>[
                      const TextSpan(text: "Install schedule\nfor "),
                      TextSpan(
                          text: "$timeTableName($batch)",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const TextSpan(text: ".")
                    ]),
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.transparent;
                            }
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.transparent;
                            }
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.transparent;
                            }
                            return Colors.transparent; // Defer to the widget's default.
                          }),
                        ),
                        child: Text("Cancel", style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onConform,
                        child: Text("Get", style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  static Widget deleteConform(context,{required String timeTableName, required String batch, void Function()? onConform}){
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 4, sigmaX: 4),
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(style: Theme.of(context).textTheme.titleMedium, children: <TextSpan>[
                      const TextSpan(text: "Delete schedule\nof "),
                      TextSpan(
                          text: "$timeTableName($batch)",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const TextSpan(text: ".")
                    ]),
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.transparent;
                            }
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.transparent;
                            }
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.transparent;
                            }
                            return Colors.transparent; // Defer to the widget's default.
                          }),
                        ),
                        child: Text("Cancel", style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onConform,
                        child: Text("Delete", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red), textAlign: TextAlign.center),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}