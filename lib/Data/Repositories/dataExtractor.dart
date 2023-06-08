import 'dart:convert';
import 'dart:io';

import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:student_dudes/Util/ImageHelper/ImageConverter.dart';

import '../Model/lecturePositionModel.dart';
import '../Model/timeTableModel.dart';

class TextExtractor {
  String? classRoom;
  double width = 1584.0;
  double height = 1190.0;
  File? image;

  Future<TimeTable> fetchTimeTable(
      {required File image,
      required double width,
      required double height}) async {
    this.image = image;
    this.width = width;
    this.height = height;

    return await _textOcr(image: image);
  }

  Future<TimeTable> _textOcr({required File image}) async {
    //vertical positions of the all days monday to saturaday
    List xPositionsOfDays = [0, 0, 0, 0, 0, 0, 0];
    double xPosSemester = 0;
    String className = "";
    //ending position that will tell the model the last block to  fetch
    double endpos = 0.0;
    double ylunch = 0.0;
    double ybreak = 0.0;
    //this will store the result on ml_kit_image_to_text in string format

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

    //fetch blocks objects from recognized_text object

    //this will add the fetched text to the results variable for
    // later retrieval

    //this for loop will iterate all the blocks and add the
    // x(vertical position of all the days in x list)
    for (final TextBlock block in recognizedText.blocks) {
      final String text = block.text;
      final yPosMean =
          ((block.boundingBox.top) + (block.boundingBox.bottom)) / 2;
      final xPosMean =
          ((block.boundingBox.left) + (block.boundingBox.right)) / 2;
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
      }
      if (text.toLowerCase() == "semester") {
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
    }

    for (final TextBlock block in recognizedText.blocks) {
      final String text = block.text;
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
        } else if (-(width / 400) < ylunch - yPosMean &&
            ylunch - yPosMean < width / 400) {
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
      if (-(width / 200) < xPosMean - xPosSemester &&
          xPosMean - xPosSemester < (width / 200) &&
          yPosMean < endpos) {
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
        wed.removeAt(i);
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
    List<DayOfWeek> dayList = [
      dayMaker(time, mon, "monday"),
      dayMaker(time, tue, "tuesday"),
      dayMaker(time, wed, "wednesday"),
      dayMaker(time, thu, "thursday"),
      dayMaker(time, fri, "friday"),
      dayMaker(time, sat, "saturday"),
    ];
    return TimeTable(image: ImageConverter().imageToString(image),
        weekDays: dayList, className: className, classRoom: classRoom);
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
            } else {
              daylist[k].append(daylist[k + 1]);
              daylist.remove(daylist[k + 1]);
            }
          }
        }
      } else if (facultynamepattern.hasMatch(next.text.trim()) &&
          !facultynamepattern.hasMatch(current.text.trim()) &&
          next.ymean - current.ymean < height / 30) {
        current.append(next);
        daylist.remove(next);
      }
    }
  }

  DayOfWeek dayMaker(List<Textblock> time, List<Textblock> day, String d) {

    List<Session> session = [];

    for (int itime = 1; itime < time.length; itime++) {
      for (int iday = 1; iday < day.length; iday++) {

        Textblock time1 = time[itime];
        Textblock? time2;

        if (itime < time.length - 1) {
          time2 = time[itime + 1];
        }

        Textblock current = day[iday];
        String id = DateTime.now().microsecondsSinceEpoch.toString();
        if ((time1.ymean - current.ymean).abs() < 25) {


          // Is one hour Lecture
          session.add(Session(
            id: id,
            isLab: false,
            facultyName: RegExp(r'\((.*?)\)')
                .stringMatch(current.text)
                ?.replaceAll(RegExp(r'[()]'), ''),

            location: RegExp(r'\b([A-Z]-\d+(?:,\d+)?)\b')
                    .firstMatch(current.text)
                    ?.group(1) ??
                (classRoom?.substring(
                        classRoom!.indexOf(":") + 1, classRoom!.indexOf(")")))
                    ?.replaceAll(" ", ""),

            subjectName: current.text.contains("(")
                ? RegExp(r"([A-Z]-\d+)$").hasMatch(current.text.substring(0, current.text.indexOf("(")).trim())
                ? current.text
                .substring(0, current.text.indexOf("("))
                .substring(
                0,
                current.text
                    .substring(0, current.text.indexOf("("))
                    .indexOf("-") -
                    1)
                : current.text.substring(0, current.text.indexOf("("))
                : current.text.contains(RegExp(r"([A-Z]-/d+)$"))
                ? current.text.substring(
                0,
                current.text
                    .substring(0, current.text.indexOf("("))
                    .indexOf("-") -
                    1)
                : current.text,
            time: time1.text.trim().replaceAll(" ", "").split("to").first,
            duration: 1,
          ));

        } else if (time2 != null &&
            ((((time1.ymean + time2.ymean) / 2) - current.ymean).abs() < 25)) {

          if (!RegExp(r'^B\d:').hasMatch(current.text)) {
            // Is Two hour Lecture
            session.add(Session(
              id: id,
              isLab: false,
              facultyName: RegExp(r'\((.*?)\)')
                  .stringMatch(current.text)
                  ?.replaceAll(RegExp(r'[()]'), ''),
              location: RegExp(r'\b([A-Z]-\d+(?:,\d+)?)\b')
                      .firstMatch(current.text)
                      ?.group(1) ??
                  (classRoom?.substring(
                          classRoom!.indexOf(":") + 1, classRoom!.indexOf(")")))
                      ?.replaceAll(" ", ""),
              subjectName: current.text.contains("(")
                  ? RegExp(r"([A-Z]-\d+)$").hasMatch(current.text.substring(0, current.text.indexOf("(")).trim())
                  ? current.text
                  .substring(0, current.text.indexOf("("))
                  .substring(
                  0,
                  current.text
                      .substring(0, current.text.indexOf("("))
                      .indexOf("-") -
                      1)
                  : current.text.substring(0, current.text.indexOf("("))
                  : current.text.contains(RegExp(r"([A-Z]-/d+)$"))
                  ? current.text.substring(
                  0,
                  current.text.
                  substring(0, current.text.indexOf("("))
                      .indexOf("-") -
                      1)
                  : current.text,
              time: time1.text.trim().replaceAll(" ", "").split("to").first,
              duration: 2,
            ));
          } else {
            // Is Lab
            session.add(Session(
              id: id,
              isLab: true,
              location: (classRoom?.substring(
                      classRoom!.indexOf(":") + 1, classRoom!.indexOf(")")))
                  ?.replaceAll(" ", ""),
              subjectName: current.text,
              time: time1.text.trim().replaceAll(" ", "").split("to").first,
              duration: 2,
            ));
          }
        }
      }
    }

    DayOfWeek dayfinal = DayOfWeek(day: d, sessions: session);
    return dayfinal;
  }
} /**/
