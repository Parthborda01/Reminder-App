import 'lecturePositionModel.dart';

class TimeTable {
  String? classRoom;
  String? className;
  WeekDays? weekDays;

  TimeTable({this.classRoom, this.className, this.weekDays});

  TimeTable.fromJson(Map<String, dynamic> json) {
    classRoom = json['classroom'];
    className = json['classname'];
    weekDays = json['days'] != null ? new WeekDays.fromJson(json['days']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classroom'] = this.classRoom;
    data['classname'] = this.className;
    if (this.weekDays != null) {
      data['days'] = this.weekDays!.toJson();
    }
    return data;
  }
}

class WeekDays {
  DayOfWeek? monday;
  DayOfWeek? tuesday;
  DayOfWeek? wednesday;
  DayOfWeek? thursday;
  DayOfWeek? friday;
  DayOfWeek? saturday;

  WeekDays(
      {this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday});

  WeekDays.fromJson(Map<String, dynamic> json) {
    monday = json['monday'] != null ? new DayOfWeek.fromJson(json['monday']) : null;

    tuesday =
        json['tuesday'] != null ? new DayOfWeek.fromJson(json['tuesday']) : null;
    wednesday =
        json['wednusday'] != null ? new DayOfWeek.fromJson(json['wednusday']) : null;
    thursday =
        json['thursday'] != null ? new DayOfWeek.fromJson(json['thursday']) : null;
    friday = json['friday'] != null ? new DayOfWeek.fromJson(json['friday']) : null;
    saturday =
        json['saturday'] != null ? new DayOfWeek.fromJson(json['saturday']) : null;
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

class DayOfWeek {
  Slot? slot1;
  Slot? slot2;
  Slot? slot3;

  DayOfWeek({this.slot1, this.slot2, this.slot3});

  DayOfWeek.fromJson(Map<String, dynamic> json) {
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
  bool? isLab;
  bool? isFullSession=false;
  List<LabSession>? lab ;
  Session? lecture1;
  Session? lecture2;
  Session? slotLecture;

  Slot({this.isLab, this.lab, this.lecture1, this.lecture2});

  Slot.fromJson(Map<String, dynamic> json) {
    isLab = json['islab'];
    isFullSession = json['isfullsession'];
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
    slotLecture = json['slotlecture'] != null
        ? new Session.fromJson(json['slotlecture'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['islab'] = this.isLab;
    data['isfullsession'] = this.isFullSession;
    if (this.lab != null) {
      data['lab'] = this.lab!.map((v) => v.toJson()).toList();
    }
    if (this.lecture1 != null) {
      data['lecture1'] = this.lecture1!.toJson();
    }
    if (this.lecture2 != null) {
      data['lecture2'] = this.lecture2!.toJson();
    }if (this.slotLecture != null) {
      data['slotlecture'] = this.slotLecture!.toJson();
    }
    return data;
  }

  fromTextBlock(
      {required Textblock textblock,
      required time1,
      required time2,
      location}) {
    String? time;
    List batches = [];

    //time merge
    time = time1.text.split("to")[0] + "to" + time2.text.split("to")[1];
    print("🟩🟦 $time");

    // lab splitting

    RegExp sessionExpression = RegExp(r'^[A-Za-z]+.*$');
    RegExp labExpression = RegExp(r'^B[0-9]:{1}.*\([A-Z]+\);$');
    RegExp forBatchSplit = RegExp(r'B[0-9]:|;');
    RegExp forBatchName = RegExp(r'B[0-9]');

    if (sessionExpression.hasMatch(textblock.text) && !labExpression.hasMatch(textblock.text)) {
      isFullSession = true;
      var slotlecture =
          Session.fromTextBlockForLec(textblock, time, location: location);
      this.slotLecture=slotlecture;
      //todo : handle class address within the lecture text

      print(this.slotLecture?.subjectName);
      print("🟨🟨🟨🟨🟨🟨🟨🟨");


    } else if (labExpression.hasMatch(textblock.text)) {

      Iterable<RegExpMatch> matches = forBatchName.allMatches(textblock.text);
      for (final m in matches) {
        batches.add(m[0]);
      }
      List batchdata = textblock.text.split(forBatchSplit);

      print("🟩🟥 $batches");
      print("🟩🟥 $batchdata");
      batchdata.removeWhere((element) {
        return element == "";
      });
      for (var i = 0; i < batchdata.length; i++) {
        batchdata[i] = batchdata[i].trim();
      }
      print("🟩🟥 $batchdata");
      if (batches.length == batchdata.length) {
        for (var i = 0; i < batchdata.length; i++) {
          if(lab==null){
            lab=[];
            this.lab!.add(
                LabSession.fromTextBlockForLab(batches[i], batchdata[i], time));
          }
          else{
          this.lab!.add(
              LabSession.fromTextBlockForLab(batches[i], batchdata[i], time));
        }}
      }
    } else {
      return;
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
    RegExp lecPattern = RegExp(r"^[A-Za-z]+.*\([A-Z]+\)$");
    RegExp onlyLecPattern = RegExp(r"^[^()]*$");
    RegExp onlyFacultyPattern = RegExp(r"^\([A-Z]+\)$");
    String subName = "ERR🟥⬜😅🤣";
    String facName = "ERR🟥";
    if (lecPattern.hasMatch(text)) {
      List textList = text.split(RegExp(r"(\(|\))"));

      subName = textList[0];
      facName = textList[1];
    } else if (onlyFacultyPattern.hasMatch(text)) {
      subName = "ERROR🟥";
      facName = text;
    } else if (onlyLecPattern.hasMatch(text)) {
      subName = text;
      facName = "ERROR🟥";
    } else {
      subName = "ERROR🟥";
      facName = "ERROR🟥";
    }
    //exporting fields
    subjectName = subName;
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

  LabSession(
      {this.batchName,
      this.subjectName,
      this.facultyName,
      this.location,
      this.time});

  LabSession.fromJson(Map<String, dynamic> json) {
    batchName = json['batchName'];
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

  LabSession.fromTextBlockForLab(batchName, String text, String? time1) {
    // extracting the classroom name


    RegExp labPattern = RegExp(r"^[A-Z]+\s?[A-Z]-\s?[0-9]{1,2}\s?,\s?[0-9]{1,2}\s?\([A-Z]+\)$");
    RegExp onlyLabPattern = RegExp(r"^[A-Z]+\W*");
    RegExp onlyLocationPattern = RegExp(r"[A-Z]-\s?[0-9]{1,2}\s?,?\s?[0-9]{0,2}");
    RegExp onlyFacultyPattern = RegExp(r"\([A-Z]+\)$");



    String subName = "ERR🟥";
    String locationName= "ERR🟥";
    String facName = "ERR🟥";
    Iterable<RegExpMatch> submatches = onlyLabPattern.allMatches(text);
    for (final m in submatches) {
      subName = m[0].toString();
      print(m[0]);

    }
    Iterable<RegExpMatch> facMatches = onlyFacultyPattern.allMatches(text);
    for (final m in facMatches) {
      facName = m[0].toString();

      print(m[0]);

    }
    Iterable<RegExpMatch> locationmatches = onlyLocationPattern.allMatches(text);

    for (final m in locationmatches) {
      locationName = m[0].toString();

      print(m[0]);

    }
    //exporting fields
    this.batchName = batchName;
    subjectName = subName;
    facultyName = facName;
    time = time1;
    this.location = locationName;
  }
}
