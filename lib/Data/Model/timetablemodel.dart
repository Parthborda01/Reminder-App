import 'lecturepositionmodel.dart';

class Timetable {
  String? classroom;
  String? classname;
  Days? days;

  Timetable({this.classroom, this.classname, this.days});

  Timetable.fromJson(Map<String, dynamic> json) {
    classroom = json['classroom'];
    classname = json['classname'];
    days = json['days'] != null ? Days.fromJson(json['days']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['classroom'] = classroom;
    data['classname'] = classname;
    if (days != null) {
      data['days'] = days!.toJson();
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
        this.friday,this.saturday});

  Days.fromJson(Map<String, dynamic> json) {
    monday =
    json['monday'] != null ? Day.fromJson(json['monday']) : null;

    tuesday =
    json['tuesday'] != null ? Day.fromJson(json['tuesday']) : null;
    wednesday = json['wednesday'] != null
        ? Day.fromJson(json['wednesday'])
        : null;
    thursday =
    json['thursday'] != null ? Day.fromJson(json['thursday']) : null;
    friday =
    json['friday'] != null ? Day.fromJson(json['friday']) : null;
    saturday =
    json['saturday'] != null ? Day.fromJson(json['saturday']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (monday != null) {
      data['monday'] = monday!.toJson();
    }

    if (tuesday != null) {
      data['tuesday'] = tuesday!.toJson();
    }
    if (wednesday != null) {
      data['wednesday'] = wednesday!.toJson();
    }
    if (thursday != null) {
      data['thursday'] = thursday!.toJson();
    }
    if (friday != null) {
      data['friday'] = friday!.toJson();
    }
    if (saturday != null) {
      data['saturday'] = saturday!.toJson();
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
    slot1 = json['slot1'] != null ? Slot.fromJson(json['slot1']) : null;
    slot2 = json['slot2'] != null ? Slot.fromJson(json['slot2']) : null;
    slot3 = json['slot3'] != null ? Slot.fromJson(json['slot3']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (slot1 != null) {
      data['slot1'] = slot1!.toJson();
    }
    if (slot2 != null) {
      data['slot2'] = slot2!.toJson();
    }
    if (slot3 != null) {
      data['slot3'] = slot3!.toJson();
    }
    return data;
  }
}

class Slot {
  bool? isLab;
  Lab? lab;
  Session? lecture1;
  Session? lecture2;

  Slot({this.isLab, this.lab, this.lecture1, this.lecture2});

  Slot.fromJson(Map<String, dynamic> json) {
    isLab = json['isLab'];
    lab = json['lab'] != null ? new Lab.fromJson(json['lab']) : null;
    lecture1 =
    json['lecture1'] != null ? new Session.fromJson(json['lecture1']) : null;
    lecture2 =
    json['lecture2'] != null ? new Session.fromJson(json['lecture2']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isLab'] = isLab;
    if (lab != null) {
      data['lab'] = lab!.toJson();
    }
    if (lecture1 != null) {
      data['lecture1'] = lecture1!.toJson();
    }
    if (lecture2 != null) {
      data['lecture2'] = lecture2!.toJson();
    }
    return data;
  }
}

class Lab {
  Session? b1;
  Session? b2;
  Session? b3;
  Session? b4;
  Session? b5;

  Lab({this.b1, this.b2, this.b3, this.b4, this.b5});

  Lab.fromJson(Map<String, dynamic> json) {
    b1 = json['b1'] != null ? new Session.fromJson(json['b1']) : null;
    b2 = json['b2'] != null ? new Session.fromJson(json['b2']) : null;
    b3 = json['b3'] != null ? new Session.fromJson(json['b3']) : null;
    b4 = json['b4'] != null ? new Session.fromJson(json['b4']) : null;
    b5 = json['b5'] != null ? new Session.fromJson(json['b5']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (b1 != null) {
      data['b1'] = b1!.toJson();
    }
    if (b2 != null) {
      data['b2'] = b2!.toJson();
    }
    if (b3 != null) {
      data['b3'] = b3!.toJson();
    }
    if (b4 != null) {
      data['b4'] = b4!.toJson();
    }
    if (b5 != null) {
      data['b5'] = b5!.toJson();
    }
    return data;
  }

  Lab.fromTextBlock({required Textblock textBlock,required time1,required time2 }){

       RegExp exp = RegExp(r'B[0-9].*\([A-Z]+\)');
       Iterable<RegExpMatch> matches = exp.allMatches(textBlock.text);

       for (final m in matches) {
            // if(){
            //
            // }
            // else{
            //
            // }
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
    data['subjectName'] = subjectName;
    data['facultyName'] = facultyName;
    data['location'] = location;
    data['time'] = time;
    return data;
  }


  Session.fromTextBlockForLec(Textblock block,time1,{String? location}){
    String text= block.text;
    // extracting the classroom name
    var classstring;
    if(location!=null){
      String classname=location;
      List items= classname.split(RegExp(r"(\(|\))"));
      for(String i in items){
        if(i.toLowerCase().contains("classroom")){
          classstring=i;
          print("🟨🟨🟨${classstring.split(":").last}");
        }
      }
    }
    RegExp lecPattern = RegExp(r"^[A-Za-z]+.*\([A-Z]+\)$");
    RegExp onlyLecPattern = RegExp(r"^[^()]*$");
    RegExp onlyFacPattern = RegExp(r"^\([A-Z]+\)$");
    String subName= "ERR";
    String facName= "ERR";
   if(lecPattern.hasMatch(text)){
     List textlist = text.split(RegExp(r"(\(|\))"));

     subName= textlist[0];
     facName= textlist[1];
   }else if(onlyFacPattern.hasMatch(text)){
     subName= "ERROR";
     facName= text;
   }
   else if(onlyLecPattern.hasMatch(text)){
     subName= text;
     facName= "ERROR";
   }
   else{
     subName= "ERROR";
     facName= "ERROR";
   }
    //exporting fields
    subjectName=subName;
    facultyName=facName;
    time=time1.text;
    this.location=classstring.split(":").last.trim();
  }
  Session.fromTextBlockForLab(String text,time1,{String? location}){
    // extracting the classroom name
    var classString;
    if(location!=null){
      String classname=location;
      List items= classname.split(RegExp(r"(\(|\))"));
      for(String i in items){
        if(i.toLowerCase().contains("classroom")){
          classString=i;
          print("🟨🟨🟨${classString.split(":").last}");
        }
      }
    }
    RegExp lecPattern = RegExp(r"^[A-Za-z]+.*\([A-Z]+\)$");
    RegExp onlyLecPattern = RegExp(r"^[^()]*$");
    RegExp onlyFacPattern = RegExp(r"^\([A-Z]+\)$");
    String subName= "ERR";
    String facName= "ERR";
   if(lecPattern.hasMatch(text)){
     List textList = text.split(RegExp(r"(\(|\))"));

     subName= textList[0];
     facName= textList[1];
   }else if(onlyFacPattern.hasMatch(text)){
     subName= "ERROR";
     facName= text;
   }
   else if(onlyLecPattern.hasMatch(text)){
     subName= text;
     facName= "ERROR";
   }
   else{
     subName= "ERROR";
     facName= "ERROR";
   }
    //exporting fields
    subjectName=subName;
    facultyName=facName;
    time=time1.text;
    this.location=classString.split(":").last.trim();
  }



}