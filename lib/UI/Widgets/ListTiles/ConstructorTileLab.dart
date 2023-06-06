import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:student_dudes/Data/Model/timeTableModel.dart';
import 'package:student_dudes/UI/Widgets/DialogBox/ConstructorDialogs/ConstructorDialogLab.dart';

class ConstructorTileLab extends StatefulWidget {
  const ConstructorTileLab({super.key, required this.labData});

  final List<LabSession> labData;

  @override
  State<ConstructorTileLab> createState() => _ConstructorTileLabState();
}

class _ConstructorTileLabState extends State<ConstructorTileLab> {
  bool checkError(String input) {
    return input.contains("error");
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () => showDialog(context: context, builder: (context) => ConstructorDialogLab(labData: widget.labData)),
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
                color: checkError(widget.labData.toString())
                    ? Colors.red.withOpacity(0.8)
                    : Colors.transparent)),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Lab Session",
                      style: Theme.of(context).textTheme.headlineLarge),
                  Text(widget.labData[0].time ?? "",
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.start)
                ]),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: widget.labData.length,
                  itemBuilder: (context, index) {
                    LabSession labSession = widget.labData[index];
                    return batchDataTile(labSession);
                  },
                ),
              ],
            )),
      ),
    );
  }

  Widget batchDataTile(LabSession labSession) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Batch: ${labSession.batchName.toString()}",
                  style: Theme.of(context).textTheme.headlineMedium),
              Text(labSession.subjectName.toString(),
                  style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(labSession.location.toString(),
                  style: Theme.of(context).textTheme.headlineMedium),
              Text(
                  labSession.facultyName
                      .toString()
                      .replaceAll(RegExp(r'[()]'), ''),
                  style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ],
      ),
    );
  }
}
