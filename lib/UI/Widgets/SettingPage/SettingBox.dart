import 'package:flutter/material.dart';


class SettingBox extends StatefulWidget {
  const SettingBox({Key? key, required this.children,this.title}) : super(key: key);
  final List<Widget> children;
  final String? title;
  @override
  State<SettingBox> createState() => _SettingBoxState();
}

class _SettingBoxState extends State<SettingBox> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
              child: Text(widget.title?? "",
                  style: Theme.of(context).textTheme.labelSmall),
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  color: Theme.of(context).colorScheme.background,
                  child: Column(
                    children: widget.children,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
