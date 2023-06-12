import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';
import 'package:student_dudes/Data/Model/time_table_model.dart';
import 'package:student_dudes/UI/Routes/route.dart';
import 'package:student_dudes/UI/Theme/theme_constants.dart';
import 'package:toggle_switch/toggle_switch.dart';

class BuildInformation extends StatefulWidget {
  const BuildInformation({super.key});

  @override
  State<BuildInformation> createState() => _BuildInformationState();
}

class _BuildInformationState extends State<BuildInformation> {
  int semester = 0;
  TextEditingController departmentNameController = TextEditingController();
  TextEditingController classroomController = TextEditingController();
  TextEditingController classNameController = TextEditingController();

  TimeTable timeTable = TimeTable(image: null, weekDays: [
    DayOfWeek(day: "Monday", sessions: []),
    DayOfWeek(day: "Tuesday", sessions: []),
    DayOfWeek(day: "Wednesday", sessions: []),
    DayOfWeek(day: "Thursday", sessions: []),
    DayOfWeek(day: "Friday", sessions: []),
    DayOfWeek(day: "Saturday", sessions: []),
  ]);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: departmentNameController,
                    style: Theme.of(context).textTheme.headlineMedium,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.class_outlined, color: Theme.of(context).textTheme.titleLarge?.color),
                        label: const Text(
                          "Department",
                          style: TextStyle(letterSpacing: 1),
                        )),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: classroomController,
                          style: Theme.of(context).textTheme.headlineMedium,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.badge, color: Theme.of(context).textTheme.titleLarge?.color),
                              label: const Text(
                                "classroom",
                                style: TextStyle(letterSpacing: 0),
                              )),
                        ),
                      ),
                      const SizedBox(
                        width: 20
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: classNameController,
                          style: Theme.of(context).textTheme.headlineMedium,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.people_outline_rounded, color: Theme.of(context).textTheme.titleLarge?.color),
                              label: const Text(
                                "Class",
                                style: TextStyle(letterSpacing: 1),
                              )),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Semester"),
                  const SizedBox(height: 10),

                  ToggleSwitch(
                    labels: const ["1", "2", "3", "4", "5", "6", "7", "8"],
                    customWidths: [
                      deviceWidth * 0.1,
                      deviceWidth * 0.1,
                      deviceWidth * 0.1,
                      deviceWidth * 0.1,
                      deviceWidth * 0.1,
                      deviceWidth * 0.1,
                      deviceWidth * 0.1,
                      deviceWidth * 0.1
                    ],
                    initialLabelIndex: semester,
                    totalSwitches: 8,
                    activeBgColor: [deadColor],
                    cornerRadius: 15,
                    inactiveBgColor: Colors.transparent,
                    inactiveFgColor: deadColor,
                    animate: true,
                    animationDuration: 200,
                    onToggle: (index) {
                      semester = index! + 1;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: deviceHeight * 0.2),
                  SliderButton(
                    backgroundColor: Theme.of(context).canvasColor,
                    buttonColor: Theme.of(context).colorScheme.background,
                    baseColor: deadColor,
                    dismissible: true,
                    buttonSize: 60,
                    vibrationFlag: true,
                    action: () {
                      timeTable.department = departmentNameController.text;
                      timeTable.className = classNameController.text;
                      timeTable.classRoom = classroomController.text;
                      timeTable.semester = semester;
                      print(timeTable.toJson());
                      Navigator.pushReplacementNamed(context, RouteNames.manualBuild, arguments: timeTable);
                    },
                    label: Text(
                      "Slide to Load!",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
