import 'package:student_dudes/Data/Model/time_table_model.dart';

class LabUtils {

  LabUtils._();

  static List<Session> labToSessions(Session labData) {
    List<String>? labels = labData.subjectName!.trim().split(")");
    labels.removeLast();
    List<Session> data = [];
    for (String i in labels) {
      if (i.isNotEmpty) {
        i = "$i)";
        data.add(Session(
          id: labData.id,
          isLab: true,
          duration: labData.duration,
          time: i.split(":")[0],
          subjectName: extractSub(i),
          location: locName(i),
          facultyName: RegExp(r'\((.*?)\)')
              .stringMatch(i)
              .toString()
              .replaceAll(RegExp(r'[()]'), ''),
        ));
      }
    }
    return data;
  }

  static String labDataToString(List<Session> labData) {
    String a ="";
    for(Session i in labData) {
      a = "$a${i.time?.toString().trim() ?? ""}: ${i.subjectName?.toString().trim() ?? ""} ${i.location?.toString().trim() ?? ""} (${(i.facultyName?.toString().trim() ?? "")}) ";
    }
    return  "${a.trim()};";
  }

  static String locName(string) {
    String loc = '';

    RegExp regex = RegExp(r"[A-Z]-\d+(,\s*\d+)*");
    Iterable<Match> matches = regex.allMatches(string);

    for (var match in matches) {
      loc = string.substring(match.start, match.end);
    }

    return loc;
  }

  static String extractSub(input) {
    String extractedElements = "";
    // Split the input string by ":" to get the relevant portion
    List<String> parts = input.split(":");
    if (parts.length >= 2) {
      // Extract the element by removing unwanted characters
      RegExp regex = RegExp(r"[A-Za-z0-9]+(?=[\s-]|$)");
      Match? match = regex.firstMatch(input);

      if (match != null) {
        extractedElements = match.group(0)!.trim();
      }
    }
    return extractedElements;
  }

  static TimeTable getFinalTimeTable(TimeTable n, String batch) {
    TimeTable t = TimeTable.fromJson(n.toJson());
    for (int i = 0; i < (t.weekDays ?? []).length; i++) {
      for (int j = 0; j < ((t.weekDays ?? [])[i].sessions ?? []).length; j++) {
        if (((t.weekDays ?? [])[i].sessions ?? [])[j].isLab ?? false) {
          List<Session> labSessions = LabUtils.labToSessions(((t.weekDays ?? [])[i].sessions ?? [])[j]);
          bool isDone = false;
          for (Session labSession in labSessions) {
            if (!isDone) {
              if (labSession.time?.trim() == batch) {
                ((t.weekDays ?? [])[i].sessions ?? [])[j] = Session(
                    id: labSession.id,
                    isLab: true,
                    duration: 2,
                    time: n.weekDays![i].sessions![j].time,
                    subjectName: labSession.subjectName,
                    facultyName: labSession.facultyName,
                    location: labSession.location);
                isDone = true;
              } else {
                ((t.weekDays ?? [])[i].sessions ?? [])[j] = Session(id: "%^&*(@x!)");
              }
            }
          }
        }
      }
    }

    for (int i = 0; i < (t.weekDays ?? []).length; i++) {
      ((t.weekDays ?? [])[i].sessions ?? []).removeWhere((element) {
        return element.id == "%^&*(@x!)";
      });
    }
    t.id = "${t.id} $batch";
    return t;
  }

}
