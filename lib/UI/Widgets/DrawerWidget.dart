import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class SlidingDrawer extends StatefulWidget {
  const SlidingDrawer({Key? key}) : super(key: key);

  @override
  State<SlidingDrawer> createState() => _SlidingDrawerState();
}

class _SlidingDrawerState extends State<SlidingDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(right: 10, top: 10),
        child: ClipRRect(
          borderRadius:
              const BorderRadius.horizontal(right: Radius.circular(20)),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Icon(Icons.settings)],
                ),
                SizedBox(height: 10),
                DottedLine(
                  dashColor: Theme.of(context).dividerColor,
                    lineThickness: 2,
                    dashRadius: 4,
                    dashGapLength: 4,
                    dashLength: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
