import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_dudes/Data/Model/timeTableModel.dart';
import 'package:student_dudes/UI/Routes/route.dart';
import 'package:student_dudes/UI/Widgets/ListTiles/ConstructorTileLab.dart';
import 'package:student_dudes/UI/Widgets/ListTiles/ConstructorTileLecture.dart';
import 'package:student_dudes/Util/Cubits/AnimationHelper/animationHelperCubit.dart';
import 'package:student_dudes/Util/Cubits/fileDataFetch/file_data_fetch_cubit.dart';
import 'package:student_dudes/Util/PdfToImage/PickHelper.dart';

class ConstructorPage extends StatefulWidget {
  const ConstructorPage({Key? key, required this.fileData}) : super(key: key);
  final FileData fileData;

  @override
  State<ConstructorPage> createState() => _ConstructorPageState();
}

class _ConstructorPageState extends State<ConstructorPage> {
  @override
  void initState() {
    File image = widget.fileData.imageFile;
    double width = widget.fileData.width;
    double height = widget.fileData.height;
    BlocProvider.of<FileDataFetchCubit>(context)
        .fetchData(image, width, height);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    ScrollController _sliverScrollController = ScrollController();
    _sliverScrollController.addListener(() {
      if (_sliverScrollController.offset >= 100 &&
          !_sliverScrollController.position.outOfRange) {
        BlocProvider.of<SliverScrolled>(context).Add();
      } else {
        BlocProvider.of<SliverScrolled>(context).clear();
      }
    });

    return Scaffold(
        body: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  spreadRadius: 1,
                  color: Theme.of(context).scaffoldBackgroundColor)
            ]),
            child:
                CustomScrollView(controller: _sliverScrollController, slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                expandedHeight: 300,
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.pdfSelect).then((value) => Navigator.pop(context));
                      },
                      highlightColor: Colors.transparent,
                      icon: Icon(
                        Icons.refresh_rounded,
                        color: Theme.of(context).iconTheme.color,
                      ))
                ],
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    highlightColor: Colors.transparent,
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Theme.of(context).iconTheme.color,
                    )),
                bottom: PreferredSize(
                  preferredSize: Size(deviceWidth, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BlocBuilder<SliverScrolled, bool>(
                          builder: (context, state) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: AnimatedOpacity(
                                    opacity: state ? 1.0 : 0.0,
                                    duration: Duration(milliseconds: 200),
                                    child: Text("Tasks",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall)),
                              )),
                      Spacer(),
                      IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                    ],
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Center(child: BlocBuilder<SliverScrolled, bool>(
                    builder: (context, state) {
                      return AnimatedOpacity(
                        opacity: state ? 0.0 : 1.0,
                        duration: Duration(milliseconds: 100),
                        child: Text(
                          "Reminder",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      );
                    },
                  )),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: deviceHeight * 2,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: BlocBuilder<FileDataFetchCubit, FileDataFetchState>(
                    builder: (context, state) {
                      if (state is FileDataFetchLoading) {
                        return CircularProgressIndicator();
                      }
                      else if (state is FileDataFetchLoaded) {

                        Map<String, dynamic> weekdays = state.timeTable.weekDays!.toJson();

                        return PageView.builder(
                          itemCount: weekdays.length,
                          itemBuilder: (BuildContext context, int indexPage) {

                            String dayKey = weekdays.keys.toList()[indexPage];  // Name of the day
                            Map dayOfWeek = weekdays[dayKey];                   // Data for the day
                            /*

                            for(int slotNumber = 0; slotNumber < dayOfWeek.length; slotNumber++){
                              String slotKey = dayOfWeek.keys.toList()[slotNumber];
                              Map<String, dynamic> slotInMap = dayOfWeek[slotKey];
                              Slot slot = Slot.fromJson(slotInMap);
                              if(slot.isLab == false){
                                  print(slot.lecture1?.toJson());
                                  print(slot.lecture2?.toJson());
                              }
                              else if(slot.isLab == true){
                                if(slot.isFullSession == false) {
                                  List<LabSession>? labSession = slot.lab
                                      ?.toList();
                                  for (int labNumber = 0; labNumber <
                                      labSession!.length; labNumber++) {
                                    print(labSession[labNumber].subjectName);
                                  }
                                }
                                else if(slot.isFullSession == true){
                                  print(slot.slotLecture?.toJson());
                                }
                              }
                            }
*/    //secret Code

                            return
                              Column(
                                children: [
                                  Text(dayKey.toUpperCase(),style: Theme.of(context).textTheme.titleMedium),
                                  Flexible(
                                    child: ListView.builder(
                                    itemCount: dayOfWeek.length,
                                    physics: const NeverScrollableScrollPhysics(),

                                    itemBuilder: (context, indexList) {

                                      var slotKey = dayOfWeek.keys.toList()[indexList]; //Name of slot
                                      var slotInMap = dayOfWeek[slotKey];               //Data for slot
                                      Slot slot = Slot.fromJson(slotInMap);             //Data to json

                                      if (slot.isLab == false) {                        //It's a lecture

                                        if (slot.lecture1 != null && slot.lecture2 != null) {

                                          return ListView(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              children: [
                                                ConstructorTileLecture(lectureData: slot.lecture1?? Session(facultyName: "Empty", location: "Empty", subjectName: "Empty", time: "Empty")),
                                                ConstructorTileLecture(lectureData: slot.lecture2?? Session(facultyName: "Empty", location: "Empty", subjectName: "Empty", time: "Empty"))
                                              ]);
                                        }
                                        else if (slot.lecture1 != null) {
                                          return ListView(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              children: [
                                                ConstructorTileLecture(lectureData: slot.lecture1?? Session(facultyName: "Empty", location: "Empty", subjectName: "Empty", time: "Empty")),
                                                ConstructorTileLecture(lectureData: Session(facultyName: "free", location: "free", subjectName: "free", time: "free"))
                                              ]);
                                        }
                                        else if (slot.lecture2 != null) {
                                          return ListView(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              children: [
                                                ConstructorTileLecture(lectureData: Session(facultyName: "free", location: "free", subjectName: "free", time: "free")),
                                                ConstructorTileLecture(lectureData: slot.lecture2?? Session(facultyName: "Empty", location: "Empty", subjectName: "Empty", time: "Empty"))
                                              ]);
                                        } else {
                                          return ListView(
                                              physics:
                                              NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              children: [
                                                ConstructorTileLecture(lectureData: Session(facultyName: "free", location: "free", subjectName: "free", time: "free")),
                                                ConstructorTileLecture(lectureData: Session(facultyName: "free", location: "free", subjectName: "free", time: "free"))
                                              ]);
                                        }
                                      }
                                      else if (slot.isLab == true && slot.isFullSession == false) {//for lab
                                        return ConstructorTileLab(labData: slot.lab?? []);
                                      } else if (slot.isLab == true && slot.isFullSession == true) {
                                        // for Full Session
                                        return ConstructorTileLecture(lectureData: slot.slotLecture?? Session(facultyName: "Empty", location: "Empty", subjectName: "Empty", time: "Empty"));
                                      } else {
                                        //for free lecture
                                        return ConstructorTileLecture(lectureData: Session(facultyName: "free", location: "free", subjectName: "free", time: "free"));
                                      }
                                    },
                            ),
                                  ),
                                ],
                              );
                          },
                        );
                      } else if (state is FileDataFetchError) {
                        print("🟥🟥🟥Error $state");
                        return SizedBox();
                      } else {
                        print("🚫🚫Other");
                        return SizedBox();
                      }
                    },
                  ),
                ),
              ),
            ])));
  }
}
