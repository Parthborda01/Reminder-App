import 'lecturepositionmodel.dart';

class Timetable {
  String? classroom;
  String? classname;
  Days? days;

  Timetable({this.classroom, this.classname, this.days});

  Timetable.fromJson(Map<String, dynamic> json) {
    classroom = json['classroom'];
    classname = json['classname'];
    days = json['days'] != null ? new Days.fromJson(json['days']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classroom'] = this.classroom;
    data['classname'] = this.classname;
    if (this.days != null) {
      data['days'] = this.days!.toJson();
    }
    return data;
  }
}

class Days {
  Day? monday;
  Day? tuesday;
  Day? wednesday;
  Day? thursday;
  Day? friday;
  Day? saturday;

  Days(
      {this.monday,
        this.tuesday,
        this.wednesday,
        this.thursday,
        this.friday,
        this.saturday});

  Days.fromJson(Map<String, dynamic> json) {
    monday = json['monday'] != null ? new Day.fromJson(json['monday']) : null;

    tuesday =
    json['tuesday'] != null ? new Day.fromJson(json['tuesday']) : null;
    wednesday =
    json['wednusday'] != null ? new Day.fromJson(json['wednusday']) : null;
    thursday =
    json['thursday'] != null ? new Day.fromJson(json['thursday']) : null;
    friday = json['friday'] != null ? new Day.fromJson(json['friday']) : null;
    saturday =
    json['saturday'] != null ? new Day.fromJson(json['saturday']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.monday != null) {
      data['monday'] = this.monday!.toJson();
    }

    if (this.tuesday != null) {
      data['tuesday'] = this.tuesday!.toJson();
    }
    if (this.wednesday != null) {
      data['wednusday'] = this.wednesday!.toJson();
    }
    if (this.thursday != null) {
      data['thursday'] = this.thursday!.toJson();
    }
    if (this.friday != null) {
      data['friday'] = this.friday!.toJson();
    }
    if (this.saturday != null) {
      data['saturday'] = this.saturday!.toJson();
    }
    return data;
  }
}

class Day {
  Slot? slot1;
  Slot? slot2;
  Slot? slot3;

  Day({this.slot1, this.slot2, this.slot3});

  Day.fromJson(Map<String, dynamic> json) {
    slot1 = json['slot1'] != null ? new Slot.fromJson(json['slot1']) : null;
    slot2 = json['slot2'] != null ? new Slot.fromJson(json['slot2']) : null;
    slot3 = json['slot3'] != null ? new Slot.fromJson(json['slot3']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.slot1 != null) {
      data['slot1'] = this.slot1!.toJson();
    }
    if (this.slot2 != null) {
      data['slot2'] = this.slot2!.toJson();
    }
    if (this.slot3 != null) {
      data['slot3'] = this.slot3!.toJson();
    }
    return data;
  }
}

class Slot {
  bool? islab;
  bool? isFullSession;
  List<LabSession>? lab;
  Session? lecture1;
  Session? lecture2;
  Session? slotlecture;

  Slot({this.islab, this.lab, this.lecture1, this.lecture2});

  Slot.fromJson(Map<String, dynamic> json) {
    islab = json['islab'];
    if (json['lab'] != null) {
      lab = <LabSession>[];
      json['lab'].forEach((v) {
        lab!.add(new LabSession.fromJson(v));
      });
    }
    lecture1 = json['lecture1'] != null
        ? new Session.fromJson(json['lecture1'])
        : null;
    lecture2 = json['lecture2'] != null
        ? new Session.fromJson(json['lecture2'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['islab'] = this.islab;
    if (this.lab != null) {
      data['lab'] = this.lab!.map((v) => v.toJson()).toList();
    }
    if (this.lecture1 != null) {
      data['lecture1'] = this.lecture1!.toJson();
    }
    if (this.lecture2 != null) {
      data['lecture2'] = this.lecture2!.toJson();
    }
    return data;
  }

  fromTextBlock(
      {required Textblock textblock, required time1, required time2,location}) {
    String? time;
    List batches= [];

    //time merge
    time = time1.text.split("to")[0] + "to" + time2.text.split("to")[1];
    print("🟩🟦 $time");

    // lab splitting
    RegExp labExpression = RegExp(r'^B[0-9]\:{1}.*\([A-Z]+\);$');
    RegExp forBatchSplit = RegExp(r'B[0-9]:|;');
    RegExp forBatchName = RegExp(r'B[0-9]');

    if(!labExpression.hasMatch(textblock.text)) {
      isFullSession=true;
      slotlecture = Session.fromTextBlockForLec(textblock, time,location: location);
      print("🟨🟨🟨🟨🟨🟨🟨🟨");
      return;
    }
    else if(labExpression.hasMatch(textblock.text)){
      Iterable<RegExpMatch> matches = forBatchName.allMatches(textblock.text);
      for (final m in matches) {
        batches.add(m[0]);
      }
      List batchdata = textblock.text.split(forBatchSplit);

      print("🟩🟥 $batches");
      print("🟩🟥 $batchdata");
      batchdata.removeWhere((element){
        return element=="";
      });
      print("🟩🟥 $batchdata");
    }
    else{

    }




  }
}



class Session {
  String? subjectName;
  String? facultyName;
  String? location;
  String? time;

  Session({this.subjectName, this.facultyName, this.location, this.time});

  Session.fromJson(Map<String, dynamic> json) {
    subjectName = json['subjectName'];
    facultyName = json['facultyName'];
    location = json['location'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subjectName'] = this.subjectName;
    data['facultyName'] = this.facultyName;
    data['location'] = this.location;
    data['time'] = this.time;
    return data;
  }

  Session.fromTextBlockForLec(Textblock block, time1, {String? location}) {
    String text = block.text;
    // extracting the classroom name
    var classstring;
    if (location != null) {
      String classname = location;
      List items = classname.split(RegExp(r"(\(|\))"));
      for (String i in items) {
        if (i.toLowerCase().contains("classroom")) {
          classstring = i;
          print("🟨🟨🟨${classstring.split(":").last}");
        }
      }
    }
    RegExp lecpattern = RegExp(r"^[A-Za-z]+.*\([A-Z]+\)$");
    RegExp onlylecpattern = RegExp(r"^[^()]*$");
    RegExp onlyfacpattern = RegExp(r"^\([A-Z]+\)$");
    String subname = "ERR";
    String facName = "ERR";
    if (lecpattern.hasMatch(text)) {
      List textlist = text.split(RegExp(r"(\(|\))"));

      subname = textlist[0];
      facName = textlist[1];
    } else if (onlyfacpattern.hasMatch(text)) {
      subname = "ERROR";
      facName = text;
    } else if (onlylecpattern.hasMatch(text)) {
      subname = text;
      facName = "ERROR";
    } else {
      subname = "ERROR";
      facName = "ERROR";
    }
    //exporting fields
    subjectName = subname;
    facultyName = facName;
    time = time1;
    this.location = classstring.split(":").last.trim();
  }

}
class LabSession {
  String? batchName;
  String? subjectName;
  String? facultyName;
  String? location;
  String? time;

  LabSession({this.batchName,this.subjectName, this.facultyName, this.location, this.time});

  LabSession.fromJson(Map<String, dynamic> json) {
    subjectName = json['batchName'];
    subjectName = json['subjectName'];
    facultyName = json['facultyName'];
    location = json['location'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batchName'] = this.batchName;
    data['subjectName'] = this.subjectName;
    data['facultyName'] = this.facultyName;
    data['location'] = this.location;
    data['time'] = this.time;
    return data;
  }

  LabSession.fromTextBlockForLab(batchName,String text, String time1) {
    // extracting the classroom name
    var classstring;

    RegExp lecpattern = RegExp(r"^[A-Za-z]+.*\([A-Z]+\)$");
    RegExp onlylecpattern = RegExp(r"^[^()]*$");
    RegExp onlyfacpattern = RegExp(r"^\([A-Z]+\)$");
    String subname = "ERR";
    String facName = "ERR";
    if (lecpattern.hasMatch(text)) {
      List textlist = text.split(RegExp(r"(\(|\))"));

      subname = textlist[0];
      facName = textlist[1];
    } else if (onlyfacpattern.hasMatch(text)) {
      subname = "ERROR";
      facName = text;
    } else if (onlylecpattern.hasMatch(text)) {
      subname = text;
      facName = "ERROR";
    } else {
      subname = "ERROR";
      facName = "ERROR";
    }
    //exporting fields
    subjectName = subname;
    facultyName = facName;
    time = time1;
    this.location = classstring.split(":").last.trim();
  }
}
