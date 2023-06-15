
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:student_dudes/Data/Model/text_position_model.dart';
import 'package:student_dudes/Data/Model/time_table_model.dart';

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
    //vertical positions of the all days monday to saturday
    List xPositionsOfDays = [0, 0, 0, 0, 0, 0, 0];
    double xPosSemester = 0;
    String className = "";
    //ending position that will tell the model the last block to  fetch
    double endPos = 0.0;
    double yLunch = 0.0;
    double yBreak = 0.0;
    //this will store the result on ml_kit_image_to_text in string format

    List<TextBlockObject> time = [];
    List<TextBlockObject> mon = [];
    List<TextBlockObject> tue = [];
    List<TextBlockObject> wed = [];
    List<TextBlockObject> thu = [];
    List<TextBlockObject> fri = [];
    List<TextBlockObject> sat = [];

    //this will store the image taken from class variable
    final InputImage inputImage = InputImage.fromFile(image);

    //initialize the text detector from ml_kit_image_to_text
    final TextRecognizer textDetector = TextRecognizer();

    //this line will process the image and store the fetched data in recognizedText format
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
        endPos = yPosMean;
      }
      if (text.toLowerCase() == 'lunch break') {
        yLunch = yPosMean;
      }
      if (text.toLowerCase() == 'break') {
        yBreak = yPosMean;
      }
      if (text.toLowerCase().contains("classroom")) {
        classRoom = text;
      }
    }

    for (final TextBlock block in recognizedText.blocks) {
      final String text = block.text;
      final yUp = block.boundingBox.top;
      final yDown = block.boundingBox.bottom;
      final xLeft = block.boundingBox.left;
      final xRight = block.boundingBox.right;
      final double yPosMean =
          ((block.boundingBox.top) + (block.boundingBox.bottom)) / 2;
      final xPosMean =
          ((block.boundingBox.left) + (block.boundingBox.right)) / 2;
      endPos = endPos - endPos * 0.0010;
      if (-(width / 200) < xPosMean - xPositionsOfDays[0] &&
          xPosMean - xPositionsOfDays[0] < (width / 200) &&
          yPosMean < endPos) {
        if (-(width / 400) < yBreak - yPosMean &&
            yBreak - yPosMean < width / 400) {
        } else if (-(width / 400) < yLunch - yPosMean &&
            yLunch - yPosMean < width / 400) {
        } else {
          time.add(TextBlockObject(
            text: text,
            yUp: yUp,
            yDown: yDown,
            yMean: yPosMean,
            xLeft: xLeft,
            xRight: xRight,
            xMean: xPosMean,
          ));
        }
      }
      if (-(width / 200) < xPosMean - xPositionsOfDays[1] &&
          xPosMean - xPositionsOfDays[1] < (width / 200) &&
          yPosMean < endPos) {
        mon.add(TextBlockObject(
          text: text,
          yUp: yUp,
          yDown: yDown,
          yMean: yPosMean,
          xLeft: xLeft,
          xRight: xRight,
          xMean: xPosMean,
        ));
      }
      if (-(width / 200) < xPosMean - xPositionsOfDays[2] &&
          xPosMean - xPositionsOfDays[2] < (width / 200) &&
          yPosMean < endPos) {
        tue.add(TextBlockObject(
          text: text,
          yUp: yUp,
          yDown: yDown,
          yMean: yPosMean,
          xLeft: xLeft,
          xRight: xRight,
          xMean: xPosMean,
        ));
      }
      if (-(width / 200) < xPosMean - xPositionsOfDays[3] &&
          xPosMean - xPositionsOfDays[3] < (width / 200) &&
          yPosMean < endPos) {
        wed.add(TextBlockObject(
          text: text,
          yUp: yUp,
          yDown: yDown,
          yMean: yPosMean,
          xLeft: xLeft,
          xRight: xRight,
          xMean: xPosMean,
        ));
      }
      if (-(width / 200) < xPosMean - xPositionsOfDays[4] &&
          xPosMean - xPositionsOfDays[4] < (width / 200) &&
          yPosMean < endPos) {
        thu.add(TextBlockObject(
          text: text,
          yUp: yUp,
          yDown: yDown,
          yMean: yPosMean,
          xLeft: xLeft,
          xRight: xRight,
          xMean: xPosMean,
        ));
      }
      if (-(width / 200) < xPosMean - xPositionsOfDays[5] &&
          xPosMean - xPositionsOfDays[5] < (width / 200) &&
          yPosMean < endPos) {
        fri.add(TextBlockObject(
          text: text,
          yUp: yUp,
          yDown: yDown,
          yMean: yPosMean,
          xLeft: xLeft,
          xRight: xRight,
          xMean: xPosMean,
        ));
      }
      if (-(width / 200) < xPosMean - xPositionsOfDays[6] &&
          xPosMean - xPositionsOfDays[6] < (width / 200) &&
          yPosMean < endPos) {
        sat.add(TextBlockObject(
          text: text,
          yUp: yUp,
          yDown: yDown,
          yMean: yPosMean,
          xLeft: xLeft,
          xRight: xRight,
          xMean: xPosMean,
        ));
      }
      if (-(width / 200) < xPosMean - xPosSemester &&
          xPosMean - xPosSemester < (width / 200) &&
          yPosMean < endPos) {
        className = text;
      }
    }

    for (var i in time) {
      i.text = i.text.replaceAll("\n", " ");
    }

    lecSet(mon);
    for (var i in mon) {
      i.text = i.text.replaceAll("\n", " ");
    }

    lecSet(tue);
    for (var i in tue) {
      i.text = i.text.replaceAll("\n", " ");
    }

    lecSet(wed);
    for (var i = 0; i < wed.length; i++) {
      wed[i].text = wed[i].text.replaceAll("\n", " ");
      if (wed[i].text.toLowerCase() == "break" ||
          wed[i].text.toLowerCase() == "lunch break") {
        wed.removeAt(i);
      }
    }

    lecSet(thu);
    for (var i in thu) {
      i.text = i.text.replaceAll("\n", " ");
    }

    lecSet(fri);
    for (var i in fri) {
      i.text = i.text.replaceAll("\n", " ");
    }

    lecSet(sat);
    for (var i in sat) {
      i.text = i.text.replaceAll("\n", " ");
    }
    List<DayOfWeek> dayList = [
      dayMaker(time, mon, "Monday"),
      dayMaker(time, tue, "Tuesday"),
      dayMaker(time, wed, "Wednesday"),
      dayMaker(time, thu, "Thursday"),
      dayMaker(time, fri, "Friday"),
      dayMaker(time, sat, "Saturday"),
    ];
    return TimeTable(weekDays: dayList, className: className, classRoom: classRoom);
  }

  void lecSet(List dayList) {

    for (var i = 0; i < dayList.length - 1; i++) {
      TextBlockObject current = dayList[i];
      TextBlockObject next = dayList[i + 1];
      current.text.trim();
      next.text.trim();
      RegExp facultyNamePattern = RegExp(r"^\([A-Z]+\)$");

      //check if textBlock text start from B(0-9)
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

          while (k < dayList.length - 1 &&
              dayList[k].text[dayList[k].text.length - 1] != ";") {
            if (dayList[k + 1].text[dayList[k + 1].text.length - 1] == ";") {
              dayList[k].append(dayList[k + 1]);
              dayList.remove(dayList[k + 1]);
              break;
            } else {
              dayList[k].append(dayList[k + 1]);
              dayList.remove(dayList[k + 1]);
            }
          }
        }
      } else if (facultyNamePattern.hasMatch(next.text.trim()) &&
          !facultyNamePattern.hasMatch(current.text.trim()) &&
          next.yMean - current.yMean < height / 30) {
        current.append(next);
        dayList.remove(next);
      }
    }
  }

  DayOfWeek dayMaker(List<TextBlockObject> time, List<TextBlockObject> day, String d) {

    List<Session> session = [];

    for (int timeList = 1; timeList < time.length; timeList++) {
      for (int aDayList = 1; aDayList < day.length; aDayList++) {

        TextBlockObject time1 = time[timeList];
        TextBlockObject? time2;

        if (timeList < time.length - 1) {
          time2 = time[timeList + 1];
        }

        TextBlockObject current = day[aDayList];
        String id = DateTime.now().microsecondsSinceEpoch.toString();
        if ((time1.yMean - current.yMean).abs() < 25) {


          // Is one hour Lecture
          session.add(Session(
            id: id,
            isLab: false,
            facultyName: RegExp(r'\((.*?)\)')
                .stringMatch(current.text)
                ?.replaceAll(RegExp(r'[()]'), '').trim(),

            location: RegExp(r'\b([A-Z]-\d+(?:,\d+)?)\b')
                    .firstMatch(current.text)
                    ?.group(1) ??
                (classRoom?.substring(
                        classRoom!.indexOf(":") + 1, classRoom!.indexOf(")")))
                    ?.replaceAll(":", "").trim(),

            subjectName: current.text.contains("(")
                ? RegExp(r"([A-Z]-\d+)$").hasMatch(current.text.substring(0, current.text.indexOf("(")).trim())
                ? current.text.substring(0, current.text.indexOf("(")).substring(0, current.text.substring(0, current.text.indexOf("(")).indexOf("-") - 1).trim()
                : current.text.substring(0, current.text.indexOf("(")).trim()
                : current.text.contains(RegExp(r"([A-Z]-/d+)$"))
                ? current.text.substring(0, current.text.substring(0, current.text.indexOf("(")).indexOf("-") - 1).trim()
                : current.text.trim(),
            time: time1.text.trim().replaceAll(" ", "").split("to").first,
            duration: 1,
          ));

        } else if (time2 != null &&
            ((((time1.yMean + time2.yMean) / 2) - current.yMean).abs() < 25)) {

          if (!RegExp(r'^B\d:').hasMatch(current.text)) {
            // Is Two hour Lecture
            session.add(Session(
              id: id,
              isLab: false,
              facultyName: RegExp(r'\((.*?)\)')
                  .stringMatch(current.text)
                  ?.replaceAll(RegExp(r'[()]'), '').trim(),
              location: RegExp(r'\b([A-Z]-\d+(?:,\d+)?)\b')
                      .firstMatch(current.text)
                      ?.group(1) ??
                  (classRoom?.substring(
                          classRoom!.indexOf(":") + 1, classRoom!.indexOf(")")))
                      ?.replaceAll(":", "").trim(),
              subjectName: current.text.contains("(")
                  ? RegExp(r"([A-Z]-\d+)$").hasMatch(current.text.substring(0, current.text.indexOf("(")).trim())
                  ? current.text.substring(0, current.text.indexOf("(")).substring(0, current.text.substring(0, current.text.indexOf("(")).indexOf("-") - 1).trim()
                  : current.text.substring(0, current.text.indexOf("(")).trim()
                  : current.text.contains(RegExp(r"([A-Z]-/d+)$"))
                  ? current.text.substring(0, current.text.substring(0, current.text.indexOf("(")).indexOf("-") - 1).trim()
                  : current.text.trim(),
              time: time1.text.trim().replaceAll(" ", "").split("to").first.trim(),
              duration: 2,
            ));
          } else {
            // Is Lab
            session.add(Session(
              id: id,
              isLab: true,
              location: (classRoom?.substring(
                      classRoom!.indexOf(":") + 1, classRoom!.indexOf(")")))
                  ?.replaceAll(":", "").trim(),
              subjectName: current.text,
              time: time1.text.trim().replaceAll(" ", "").split("to").first.trim(),
              duration: 2,
            ));
          }
        }
      }
    }

    DayOfWeek dayFinal = DayOfWeek(day: d, sessions: session);
    return dayFinal;
  }
} /**/
