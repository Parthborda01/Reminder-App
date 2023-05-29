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
        this.friday,this.saturday});

  Days.fromJson(Map<String, dynamic> json) {
    monday =
    json['monday'] != null ? new Day.fromJson(json['monday']) : null;

    tuesday =
    json['tuesday'] != null ? new Day.fromJson(json['tuesday']) : null;
    wednesday = json['wednusday'] != null
        ? new Day.fromJson(json['wednusday'])
        : null;
    thursday =
    json['thursday'] != null ? new Day.fromJson(json['thursday']) : null;
    friday =
    json['friday'] != null ? new Day.fromJson(json['friday']) : null;
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
  Lab? lab;
  Session? lecture1;
  Session? lecture2;

  Slot({this.islab, this.lab, this.lecture1, this.lecture2});

  Slot.fromJson(Map<String, dynamic> json) {
    islab = json['islab'];
    lab = json['lab'] != null ? new Lab.fromJson(json['lab']) : null;
    lecture1 =
    json['lecture1'] != null ? new Session.fromJson(json['lecture1']) : null;
    lecture2 =
    json['lecture2'] != null ? new Session.fromJson(json['lecture2']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['islab'] = this.islab;
    if (this.lab != null) {
      data['lab'] = this.lab!.toJson();
    }
    if (this.lecture1 != null) {
      data['lecture1'] = this.lecture1!.toJson();
    }
    if (this.lecture2 != null) {
      data['lecture2'] = this.lecture2!.toJson();
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
    if (this.b1 != null) {
      data['b1'] = this.b1!.toJson();
    }
    if (this.b2 != null) {
      data['b2'] = this.b2!.toJson();
    }
    if (this.b3 != null) {
      data['b3'] = this.b3!.toJson();
    }
    if (this.b4 != null) {
      data['b4'] = this.b4!.toJson();
    }
    if (this.b5 != null) {
      data['b5'] = this.b5!.toJson();
    }
    return data;
  }

  Lab.fromTextBlock({required Textblock textblock,required time1,required time2 }){

       RegExp exp = RegExp(r'B[0-9].*\([A-Z]+\)');
       Iterable<RegExpMatch> matches = exp.allMatches(textblock.text);

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
    data['subjectName'] = this.subjectName;
    data['facultyName'] = this.facultyName;
    data['location'] = this.location;
    data['time'] = this.time;
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
    RegExp lecpattern = RegExp(r"^[A-Za-z]+.*\([A-Z]+\)$");
    RegExp onlylecpattern = RegExp(r"^[^()]*$");
    RegExp onlyfacpattern = RegExp(r"^\([A-Z]+\)$");
    String subname= "ERR";
    String facName= "ERR";
   if(lecpattern.hasMatch(text)){
     List textlist = text.split(RegExp(r"(\(|\))"));

     subname= textlist[0];
     facName= textlist[1];
   }else if(onlyfacpattern.hasMatch(text)){
     subname= "ERROR";
     facName= text;
   }
   else if(onlylecpattern.hasMatch(text)){
     subname= text;
     facName= "ERROR";
   }
   else{
     subname= "ERROR";
     facName= "ERROR";
   }
    //exporting fields
    subjectName=subname;
    facultyName=facName;
    time=time1.text;
    this.location=classstring.split(":").last.trim();
  }
  Session.fromTextBlockForLab(String text,time1,{String? location}){
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
    RegExp lecpattern = RegExp(r"^[A-Za-z]+.*\([A-Z]+\)$");
    RegExp onlylecpattern = RegExp(r"^[^()]*$");
    RegExp onlyfacpattern = RegExp(r"^\([A-Z]+\)$");
    String subname= "ERR";
    String facName= "ERR";
   if(lecpattern.hasMatch(text)){
     List textlist = text.split(RegExp(r"(\(|\))"));

     subname= textlist[0];
     facName= textlist[1];
   }else if(onlyfacpattern.hasMatch(text)){
     subname= "ERROR";
     facName= text;
   }
   else if(onlylecpattern.hasMatch(text)){
     subname= text;
     facName= "ERROR";
   }
   else{
     subname= "ERROR";
     facName= "ERROR";
   }
    //exporting fields
    subjectName=subname;
    facultyName=facName;
    time=time1.text;
    this.location=classstring.split(":").last.trim();
  }



}