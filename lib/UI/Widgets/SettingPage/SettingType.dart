import 'package:flutter/material.dart';

class SettingTile extends StatefulWidget {
  const SettingTile({Key? key, this.title}) : super(key: key);
  final title;

  @override
  State<SettingTile> createState() => _SettingTileState();
}

class _SettingTileState extends State<SettingTile> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.title,
      child: Material(
        child: ListTile(
            style: ListTileStyle.drawer,
            title: Text(widget.title,
                style: Theme.of(context).textTheme.headlineMedium),
            tileColor: Theme.of(context).backgroundColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<Widget>(builder: (BuildContext context) {
                  return Scaffold(
                    body: Center(
                      child: Hero(
                        tag: widget.title,
                        child: Material(
                          child: ListTile(
                            title: Text(widget.title ?? "", style: Theme.of(context).textTheme.headlineMedium),
                            tileColor: Theme.of(context).backgroundColor,
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            }),
      ),
    );
  }
}
