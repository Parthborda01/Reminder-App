

import 'dart:io';
import 'dart:math';

import 'package:google_ml_kit/google_ml_kit.dart';

import '../Model/lecturePositionModel.dart';
import '../Model/timeTableModel.dart';

class TextExtractor{
  String? classRoom;
  double width = 1584.0;
  double height = 1190.0;
  File? image;



  Future<TimeTable> fetchTimeTable({required File image,required double width,required double height}) async {
    this.image = image;
    this.width = width;
    this.height = height;

    return await _textOcr(image: image);;
  }


  Future<TimeTable> _textOcr({required File image}) async {


    //vertical positions of the all days monday to saturaday
    List xPositionsOfDays = [0, 0, 0, 0, 0, 0, 0];
    double xPosSemester=0;
    String className="";
    //ending position that will tell the model the last block to  fetch
    double endpos = 0.0;
    double ylunch = 0.0;
    double ybreak = 0.0;
    String breaktime = "";
    String lunchtime = "";
    //this will store the result on ml_kit_image_to_text in string format
    String result = '';

    List<Textblock> time = [];
    List<Textblock> mon = [];
    List<Textblock> tue = [];
    List<Textblock> wed = [];
    List<Textblock> thu = [];
    List<Textblock> fri = [];
    List<Textblock> sat = [];

    //this will store the image taken from class variable
    final InputImage inputImage = InputImage.fromFile(image);

    //initialize the text detector from ml_kit_image_to_text
    final TextRecognizer textDetector = GoogleMlKit.vision.textRecognizer();

    //this linw will process the image and store the fetched data in recognizedText format
    final RecognizedText recognizedText =
    await textDetector.processImage(inputImage);

    //fetch text from recognized_text object
    final String text = recognizedText.text;

    //fetch blocks objects from recognized_text object
    final List<TextBlock> textblocks = recognizedText.blocks;

    //this will add the fetched text to the results variable for
    // later retrieval
    result += 'Detected ${recognizedText.blocks.length} text blocks.\n';

    //this for loop will iterate all the blocks and add the
    // x(vertical position of all the days in x list)
    for (final TextBlock block in recognizedText.blocks) {
      final boundingBox = block.boundingBox;
      final List<Point<int>> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;
      final yPosMean =
          ((block.boundingBox.top) + (block.boundingBox.bottom)) / 2;
      final xPosMean =
          ((block.boundingBox.left) + (block.boundingBox.right)) / 2;
      result += '$text\n' 'x position=$xPosMean\n' 'y position=$yPosMean\n';
      if (text.toLowerCase() == "time") {
        xPositionsOfDays[0] = xPosMean;
      }
      if (text.toLowerCase() == "monday" ||
          text.toLowerCase() == "monday\n" ||
          text.toLowerCase() == "\nmonday" ||
          text.toLowerCase() == " monday" ||
          text.toLowerCase() == "monday ") {
        xPositionsOfDays[1] = xPosMean;
      }
      if (text.toLowerCase() == "tuesday") {
        xPositionsOfDays[2] = xPosMean;
      }
      if (text.toLowerCase() == "wednesday") {
        xPositionsOfDays[3] = xPosMean;
      }
      if (text.toLowerCase() == "thursday") {
        xPositionsOfDays[4] = xPosMean;
      }
      if (text.toLowerCase() == "friday") {
        xPositionsOfDays[5] = xPosMean;
      }
      if (text.toLowerCase() == "saturday") {
        xPositionsOfDays[6] = xPosMean;
      }if (text.toLowerCase() == "semester") {
        xPosSemester = xPosMean;
      }
      if (text.toLowerCase() == 'subject' ||
          text.toLowerCase() == 'subject name' ||
          text.toLowerCase() == 'subject\nname') {
        endpos = yPosMean;
      }
      if (text.toLowerCase() == 'lunch break') {
        ylunch = yPosMean;
      }
      if (text.toLowerCase() == 'break') {
        ybreak = yPosMean;
      }
      if (text.toLowerCase().contains("classroom")) {
        classRoom = text;

      }
      // result += '\n# Text block:\n '
      //     'bbox=$boundingBox\n '
      //     'cornerPoints=$cornerPoints\n '
      //     'text=$text\n '
      // 'x position=$xPosMean\n'
      // 'y position=$yPosMean\n';

      // 'languages=$languages';
      // for (TextLine line in block.lines) {
      //   // Same getters as TextBlock
      //   for (TextElement element in line.elements) {
      //     // Same getters as TextBlock
      //   }
      // }
    }

    for (final TextBlock block in recognizedText.blocks) {
      final boundingBox = block.boundingBox;
      final List<Point<int>> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;
      final yup = block.boundingBox.top;
      final ydown = block.boundingBox.bottom;
      final xleft = block.boundingBox.left;
      final xright = block.boundingBox.right;
      final double yPosMean =
          ((block.boundingBox.top) + (block.boundingBox.bottom)) / 2;
      final xPosMean =
          ((block.boundingBox.left) + (block.boundingBox.right)) / 2;
      endpos = endpos - endpos * 0.0010;
      if (-(width / 200) < xPosMean - xPositionsOfDays[0] &&
          xPosMean - xPositionsOfDays[0] < (width / 200) &&
          yPosMean < endpos) {
        if (-(width / 400) < ybreak - yPosMean &&
            ybreak - yPosMean < width / 400) {
          breaktime = text;
        } else if (-(width / 400) < ylunch - yPosMean &&
            ylunch - yPosMean < width / 400) {
          lunchtime = text;
        } else {
          time.add(Textblock(
            text: text,
            yup: yup,
            ydown: ydown,
            ymean: yPosMean,
            xleft: xleft,
            xright: xright,
            xmean: xPosMean,
          ));
        }
      }
      if (-(width / 200) < xPosMean - xPositionsOfDays[1] &&
          xPosMean - xPositionsOfDays[1] < (width / 200) &&
          yPosMean < endpos) {
        mon.add(Textblock(
          text: text,
          yup: yup,
          ydown: ydown,
          ymean: yPosMean,
          xleft: xleft,
          xright: xright,
          xmean: xPosMean,
        ));
      }
      if (-(width / 200) < xPosMean - xPositionsOfDays[2] &&
          xPosMean - xPositionsOfDays[2] < (width / 200) &&
          yPosMean < endpos) {
        tue.add(Textblock(
          text: text,
          yup: yup,
          ydown: ydown,
          ymean: yPosMean,
          xleft: xleft,
          xright: xright,
          xmean: xPosMean,
        ));
      }
      if (-(width / 200) < xPosMean - xPositionsOfDays[3] &&
          xPosMean - xPositionsOfDays[3] < (width / 200) &&
          yPosMean < endpos) {
        wed.add(Textblock(
          text: text,
          yup: yup,
          ydown: ydown,
          ymean: yPosMean,
          xleft: xleft,
          xright: xright,
          xmean: xPosMean,
        ));
      }
      if (-(width / 200) < xPosMean - xPositionsOfDays[4] &&
          xPosMean - xPositionsOfDays[4] < (width / 200) &&
          yPosMean < endpos) {
        thu.add(Textblock(
          text: text,
          yup: yup,
          ydown: ydown,
          ymean: yPosMean,
          xleft: xleft,
          xright: xright,
          xmean: xPosMean,
        ));
      }
      if (-(width / 200) < xPosMean - xPositionsOfDays[5] &&
          xPosMean - xPositionsOfDays[5] < (width / 200) &&
          yPosMean < endpos) {
        fri.add(Textblock(
          text: text,
          yup: yup,
          ydown: ydown,
          ymean: yPosMean,
          xleft: xleft,
          xright: xright,
          xmean: xPosMean,
        ));
      }
      if (-(width / 200) < xPosMean - xPositionsOfDays[6] &&
          xPosMean - xPositionsOfDays[6] < (width / 200) &&
          yPosMean < endpos) {
        sat.add(Textblock(
          text: text,
          yup: yup,
          ydown: ydown,
          ymean: yPosMean,
          xleft: xleft,
          xright: xright,
          xmean: xPosMean,
        ));
      }
      if(-(width / 200) < xPosMean - xPosSemester &&
          xPosMean - xPosSemester < (width / 200) &&
          yPosMean < endpos){
        className = text;

      }
    }

    for (var i in time) {
      i.text = i.text.replaceAll("\n", " ");

      // print("${i.text} 🟩${i.ymean} 🟩");
    }

    lecset(mon);
    for (var i in mon) {
      i.text = i.text.replaceAll("\n", " ");

      // print("${i.text} 🟩${i.ymean} 🟩");
    }

    lecset(tue);
    for (var i in tue) {
      i.text = i.text.replaceAll("\n", " ");

      // print("${i.text} 🟩${i.ymean} 🟩");
    }


    lecset(wed);
    for (var i = 0; i < wed.length; i++) {
      wed[i].text = wed[i].text.replaceAll("\n", " ");

      // print("${wed[i].text} 🟩 ${wed[i].ymean}");
      if (wed[i].text.toLowerCase() == "break" ||
          wed[i].text.toLowerCase() == "lunch break") {
        // print(" ${wed[i].text} removed🟩");
        wed.remove(i);
      }
    }


    lecset(thu);
    for (var i in thu) {
      i.text = i.text.replaceAll("\n", " ");

      // print("${i.text} 🟩${i.ymean} 🟩");
    }


    lecset(fri);
    for (var i in fri) {
      i.text = i.text.replaceAll("\n", " ");

      // print("${i.text} 🟩${i.ymean} 🟩");
    }


    lecset(sat);
    for (var i in sat) {
      i.text = i.text.replaceAll("\n", " ");

      // print("${i.text} 🟩${i.ymean} 🟩");
    }
    print("");
    DayOfWeek monfinal = daymaker(time, mon);
    DayOfWeek tuefinal = daymaker(time, tue);
    DayOfWeek wedfinal = daymaker(time, wed);
    DayOfWeek thufinal = daymaker(time, thu);
    DayOfWeek frifinal = daymaker(time, fri);
    DayOfWeek satfinal = daymaker(time, sat);
    WeekDays daylist = WeekDays(
        monday: monfinal,
        tuesday: tuefinal,
        wednesday: wedfinal,
        thursday: thufinal,
        friday: frifinal,
        saturday: satfinal);
    return TimeTable(weekDays:daylist,className: className,classRoom: classRoom);
    daylist.toJson().forEach((key, value) {
      DayOfWeek dayhere = DayOfWeek.fromJson(value);
      print(" 🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥$key");
      print("🟦🟦 slot 1 is lab?  ${dayhere.slot1?.isLab } is slot lecture? ${dayhere.slot1?.isFullSession}");
      if (dayhere.slot1?.isLab!=null && dayhere.slot1!.isLab!) {
        if(dayhere.slot1?.isFullSession==true){
          print("🟩🟩🟩🟩🟩🟩🟩🟩🟩🟦🟦🟦🟦🟦🟦🟦🟦🟦");
          print(dayhere.slot1?.slotLecture?.subjectName);
          print(dayhere.slot1?.slotLecture?.facultyName);
          print(dayhere.slot1?.slotLecture?.location);
          print(dayhere.slot1?.slotLecture?.time);
          print("");
        }
        else {
          if(dayhere.slot1!=null && dayhere.slot1!.lab!=null ){
            print(dayhere.slot1!.lab);
            for(int i=0; i<dayhere.slot1!.lab!.length;i++){
              print("🟩🟩🟩🟩🟩🟩🟥🟥🟥🟥🟥🟥🟥🟥");

              print(dayhere.slot1?.lab?[i].batchName);
              print(dayhere.slot1?.lab?[i].subjectName);
              print(dayhere.slot1?.lab?[i].facultyName);
              print(dayhere.slot1?.lab?[i].location);
              print(dayhere.slot1?.lab?[i].time);
              print("");
            }}
          print("🟨🟨🟨🟨🟨🟨🟨🟨🟨🟥🟥🟥🟥🟥🟥🟥🟥🟥  lab");
        }
      } else {
        print(dayhere.slot1?.lecture1?.subjectName);
        print(dayhere.slot1?.lecture1?.facultyName);
        print(dayhere.slot1?.lecture1?.location);
        print(dayhere.slot1?.lecture1?.time);
        print("");
        print(dayhere.slot1?.lecture2?.subjectName);
        print(dayhere.slot1?.lecture2?.facultyName);
        print(dayhere.slot1?.lecture2?.location);
        print(dayhere.slot1?.lecture2?.time);
        print("");
        print("");
      }

      print("🟦🟦 slot 2 is lab?  ${dayhere.slot2?.isLab} is slot lecture? ${dayhere.slot1?.isFullSession}");
      if (dayhere.slot2?.isLab!=null && dayhere.slot2!.isLab!  ) {
        if(dayhere.slot2?.isFullSession==true){
          print("🟩🟩🟩🟩🟩🟩🟩🟩🟩🟦🟦🟦🟦🟦🟦🟦🟦🟦");
          print(dayhere.slot2?.slotLecture?.subjectName);
          print(dayhere.slot2?.slotLecture?.facultyName);
          print(dayhere.slot2?.slotLecture?.location);
          print(dayhere.slot2?.slotLecture?.time);
          print("");
        }
        else {
          if(dayhere.slot2!=null && dayhere.slot2!.lab!=null ){
            print(dayhere.slot2!.lab);
            for(int i=0; i<dayhere.slot2!.lab!.length;i++){
              print("🟩🟩🟩🟩🟩🟩🟥🟥🟥🟥🟥🟥🟥🟥");

              print(dayhere.slot2?.lab?[i].batchName);
              print(dayhere.slot2?.lab?[i].subjectName);
              print(dayhere.slot2?.lab?[i].facultyName);
              print(dayhere.slot2?.lab?[i].location);
              print(dayhere.slot2?.lab?[i].time);
              print("");
            }}
          print("🟨🟨🟨🟨🟨🟨🟨🟨🟨🟥🟥🟥🟥🟥🟥🟥🟥🟥  lab");
        }
      } else {
        print(dayhere.slot2?.lecture1?.subjectName);
        print(dayhere.slot2?.lecture1?.facultyName);
        print(dayhere.slot2?.lecture1?.location);
        print(dayhere.slot2?.lecture1?.time);
        print("");
        print(dayhere.slot2?.lecture2?.subjectName);
        print(dayhere.slot2?.lecture2?.facultyName);
        print(dayhere.slot2?.lecture2?.location);
        print(dayhere.slot2?.lecture2?.time);
        print("");
        print("");
      }
      print("🟦🟦 slot 3 is lab?  ${dayhere.slot3?.isLab} is slot lecture? ${dayhere.slot1?.isFullSession}");
      if (dayhere.slot3?.isLab!=null && dayhere.slot3!.isLab! ) {
        if(dayhere.slot3?.isFullSession==true){
          print("🟩🟩🟩🟩🟩🟩🟩🟩🟩🟦🟦🟦🟦🟦🟦🟦🟦🟦");
          print(dayhere.slot3?.slotLecture?.subjectName);
          print(dayhere.slot3?.slotLecture?.facultyName);
          print(dayhere.slot3?.slotLecture?.location);
          print(dayhere.slot3?.slotLecture?.time);
          print("");
        }
        else {
          if(dayhere.slot3!=null && dayhere.slot3!.lab!=null ){
            print(dayhere.slot3!.lab);
            for(int i=0; i<dayhere.slot3!.lab!.length;i++){
              print("🟩🟩🟩🟩🟩🟩🟥🟥🟥🟥🟥🟥🟥🟥");

              print(dayhere.slot3?.lab?[i].batchName);
              print(dayhere.slot3?.lab?[i].subjectName);
              print(dayhere.slot3?.lab?[i].facultyName);
              print(dayhere.slot3?.lab?[i].location);
              print(dayhere.slot3?.lab?[i].time);
              print("");
            }}
          print("🟨🟨🟨🟨🟨🟨🟨🟨🟨🟥🟥🟥🟥🟥🟥🟥🟥🟥  lab");
        }
      } else {
        print(dayhere.slot3?.lecture1?.subjectName);
        print(dayhere.slot3?.lecture1?.facultyName);
        print(dayhere.slot3?.lecture1?.location);
        print(dayhere.slot3?.lecture1?.time);
        print("");
        print(dayhere.slot3?.lecture2?.subjectName);
        print(dayhere.slot3?.lecture2?.facultyName);
        print(dayhere.slot3?.lecture2?.location);
        print(dayhere.slot3?.lecture2?.time);
        print("");
        print("");
      }
    });

  }

  void lecset(List daylist) {
    for (var i = 0; i < daylist.length - 1; i++) {
      Textblock current = daylist[i];
      Textblock next = daylist[i + 1];
      current.text.trim();
      next.text.trim();
      RegExp facultynamepattern = RegExp(r"^\([A-Z]+\)$");

      //check if textblock text start from B(0-9)
      if (current.text[0] == "B" &&
          (RegExp(r"[1-9]+").hasMatch(current.text[1]))) {
        // if start from B(0-9) and ends with ; then text
        // is okay so we can ignore that as it is
        if (current.text[current.text.length - 1] == ";" ||
            (current.text[current.text.length - 1] == ":" &&
                current.text[current.text.length - 2] == ")")) {
          //ignored
          continue;
        }

        //else we have to check until the end of the text becomes ;
        // and till then merge incoming
        else {
          var k = i;

          while (k < daylist.length - 1 &&
              daylist[k].text[daylist[k].text.length - 1] != ";") {
            if (daylist[k + 1].text[daylist[k + 1].text.length - 1] == ";") {
              daylist[k].append(daylist[k + 1]);
              daylist.remove(daylist[k + 1]);
              break;
            }
            else {
              daylist[k].append(daylist[k + 1]);
              daylist.remove(daylist[k + 1]);
            }
          }
        }
      }


      else if (facultynamepattern.hasMatch(next.text.trim()) &&
          !facultynamepattern.hasMatch(current.text.trim()) &&
          next.ymean - current.ymean < height / 30) {
        current.append(next);
        daylist.remove(next);
      }
    }
  }

  DayOfWeek daymaker(List<Textblock> time, List<Textblock> day) {
    Slot slot1 = Slot();
    Slot slot2 = Slot();
    Slot slot3 = Slot();


    for (var itime = 1; itime < time.length; itime++) {
      for (var iday = 1; iday < day.length; iday++) {
        Textblock time1 = time[itime];
        Textblock? time2;
        if (itime < time.length - 1) {
          time2 = time[itime + 1];
        }

        Textblock current = day[iday];
        // textblock next = day[iday+1];

        //checks if textblock is lacturee
        if ((time1.ymean - current.ymean).abs() < height / 60) {
          if (itime == 1 || itime == 2) {
            //slot 1
            slot1.isLab = false;

            if (itime == 1) {
              slot1.lecture1 = Session.fromTextBlockForLec(
                  current, time[itime].text,
                  location: classRoom);
            } else {
              slot1.lecture2 = Session.fromTextBlockForLec(
                  current, time[itime].text,
                  location: classRoom);
            }
          } else if (itime == 3 || itime == 4) {
            //slot 2
            slot2.isLab = false;
            if (itime == 3) {
              slot2.lecture1 = Session.fromTextBlockForLec(
                  current, time[itime].text,
                  location: classRoom);
            } else {
              slot2.lecture2 = Session.fromTextBlockForLec(
                  current, time[itime].text,
                  location: classRoom);
            }
          } else if (itime == 5 || itime == 6) {
            //slot 3
            slot3.isLab = false;
            if (itime == 5) {
              slot3.lecture1 = Session.fromTextBlockForLec(
                  current, time[itime].text,
                  location: classRoom);
            } else {
              slot3.lecture2 = Session.fromTextBlockForLec(
                  current, time[itime].text,
                  location: classRoom);
            }
          }
        }

        //checks if textblock is lab
        else if (time2 != null &&
            ((time1.ymean + time2.ymean) / 2 - current.ymean).abs() <
                height / 60) {
          if (itime == 1) {
            slot1.isLab = true;

            slot1.fromTextBlock(
                textblock: current,
                time1: time1,
                time2: time2,
                location: classRoom);
          } else if (itime == 3) {
            slot2.isLab = true;
            slot2.fromTextBlock(
                textblock: current,
                time1: time1,
                time2: time2,
                location: classRoom);
          } else if (itime == 5) {
            slot3.isLab = true;
            slot3.fromTextBlock(
                textblock: current,
                time1: time1,
                time2: time2,
                location: classRoom);
          }
        }
      }
    }

    DayOfWeek dayfinal = DayOfWeek(slot1: slot1, slot2: slot2, slot3: slot3);
    return dayfinal;
  }
}