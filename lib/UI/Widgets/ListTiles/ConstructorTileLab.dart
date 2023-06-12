import 'package:flutter/material.dart';
import 'package:student_dudes/Data/Model/time_table_model.dart';
import 'package:student_dudes/Util/lab_session_util.dart';
import 'package:student_dudes/Util/time_util.dart';


class ConstructorTileLab extends StatelessWidget {
  const ConstructorTileLab(
      {super.key, required this.labData, required this.isSelected, required this.numberOfEmpty});


  final bool isSelected;  final Session? labData;
  final int numberOfEmpty;

  bool checkError(String input) {
    return input.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    List<Session> data = LabUtils.labToSessions(labData!);
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 20, left: 10,right: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
              color: isSelected
                  ? Colors.blue.withOpacity(0.8)
                  : numberOfEmpty > 0 ? Colors.amber
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
                    labData?.time != null &&
                            labData!.time!.trim().isNotEmpty
                        ? TimeUtil.calculatePeriod(labData!.time!, labData!.duration!)
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
