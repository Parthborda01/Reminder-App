import 'package:flutter/material.dart';
import 'package:student_dudes/Data/Model/timeTableModel.dart';
import 'package:student_dudes/UI/Widgets/DialogBox/ConstructorDialogs/ConstructorDialogLab.dart';
import 'package:student_dudes/Util/ImageHelper/PickHelper.dart';
import 'package:student_dudes/Util/Util.dart';

import '../../../Util/LabSessionHelper.dart';

class ConstructorTileLab extends StatefulWidget {
  const ConstructorTileLab(
      {super.key, required this.labData, required this.onChanged,required this.fileData});
  final FileData fileData;
  final Session? labData;
  final Function(Session) onChanged;

  @override
  State<ConstructorTileLab> createState() => _ConstructorTileLabState();
}

class _ConstructorTileLabState extends State<ConstructorTileLab> {
  bool checkError(String input) {
    return input.isEmpty;
  }
  List<Session> data = [];
  @override
  void initState() {
    data = LabUtils.labToSessions(widget.labData!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => ConstructorDialogLab(
              fileData: widget.fileData,
                  labData: widget.labData,
                  onChanged: (p0) {
                    data = LabUtils.labToSessions(p0);
                    setState(() {});
                    widget.onChanged(p0);
                  },
                ));
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
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
                  Text(
                      widget.labData?.time != null &&
                              widget.labData!.time!.trim().isNotEmpty
                          ? Util.calculatePeriod(widget.labData!.time!, widget.labData!.duration!)
                          : "⚠️⚠️⚠️",
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.start)
                ]),
                const SizedBox(height: 10),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return batchDataTile(context, data[index]);
                  },
                ),
              ],
            )),
      ),
    );
  }

  Widget batchDataTile(context, Session labSession) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Batch: ${labSession.time != null && labSession.time!.trim().isNotEmpty ? labSession.time! : "⚠️⚠️⚠️"}",
                style: Theme.of(context).textTheme.headlineMedium),
            Text(
                labSession.subjectName != null &&
                        labSession.subjectName!.trim().isNotEmpty
                    ? labSession.subjectName!
                    : "⚠️⚠️⚠️",
                style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
                labSession.location != null &&
                        labSession.location!.trim().isNotEmpty
                    ? labSession.location!
                    : "⚠️⚠️⚠️",
                style: Theme.of(context).textTheme.headlineMedium),
            Text(
                labSession.facultyName
                        ?.toString()
                        .replaceAll(RegExp(r'[()]'), '') ??
                    "⚠️⚠️⚠️",
                style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ],
    );
  }
}
