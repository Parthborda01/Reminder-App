import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_dudes/Data/Model/timeTableModel.dart';
import 'package:student_dudes/UI/Widgets/HomePage/TaskTile.dart';
import 'package:student_dudes/UI/Widgets/HomePage/tempTile.dart';
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
                leading: IconButton(
                    onPressed: () {},
                    highlightColor: Colors.transparent,
                    icon: Icon(
                      Icons.menu,
                      color: Theme.of(context).iconTheme.color,
                    )),
                bottom: PreferredSize(
                  preferredSize: Size(deviceWidth, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BlocBuilder<SliverScrolled, bool>(
                          builder: (context, state) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: AnimatedOpacity(
                                    opacity: state ? 1.0 : 0.0,
                                    duration: Duration(milliseconds: 200),
                                    child: Text("Tasks",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall)),
                              )),
                      Spacer(),
                      IconButton(onPressed: () {

                      }, icon: Icon(Icons.add)),
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
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: deviceHeight * 0.6,
                            color: Theme.of(context).backgroundColor,
                            child: BlocBuilder<FileDataFetchCubit, FileDataFetchState>(
                              builder: (context, state) {
                                if (state is FileDataFetchInitial){
                                  print("🟨🟨🟨");
                                  return CircularProgressIndicator();
                                }
                                else if(state is FileDataFetchLoading){
                                  print('🟨🟨🟨Loading....');
                                  return CircularProgressIndicator();
                                }
                                else if(state is FileDataFetchLoaded){
                                  print("🟩🟩🟩Loaded");
                                  return PageView.builder(
                                    itemCount: state.timeTable.weekDays?.toJson().length,
                                    itemBuilder: (context, index1) {
                                      if (state.timeTable != null) {
                                        var daykey =
                                        state.timeTable.weekDays?.toJson().keys.toList()[index1];
                                        print(daykey);
                                        Map day = state.timeTable.weekDays?.toJson()[daykey];
                                        return ListView.builder(



                                          itemCount: day.length,
                                          itemBuilder: (context, index2) {
                                            var slotkey = day.keys.toList()[index2];
                                            var slotInMap = day[slotkey];
                                            Slot slot = Slot.fromJson(slotInMap);
                                            if (slot.isLab == false) {
                                              //for lecture
                                              if(slot.lecture1!=null && slot.lecture2!= null){
                                                return ListView(physics: NeverScrollableScrollPhysics(),shrinkWrap: true,children: [TaskLectureTiletemp(Lecture: slot.lecture1!),TaskLectureTiletemp(Lecture: slot.lecture2!)]);
                                              }else if(slot.lecture1!=null){
                                                return ListView(physics: NeverScrollableScrollPhysics(),shrinkWrap: true,children: [TaskLectureTiletemp(Lecture: slot.lecture1!),TaskLectureTiletemp(Lecture: Session(facultyName: "free",location: "free",subjectName: "free",time: "free"))]);

                                              }else if(slot.lecture2!=null){
                                                return ListView(physics: NeverScrollableScrollPhysics(),shrinkWrap: true,children: [TaskLectureTiletemp(Lecture: Session(facultyName: "free",location: "free",subjectName: "free",time: "free")),TaskLectureTiletemp(Lecture: slot.lecture2!)]);

                                              }else{
                                                return ListView(physics: NeverScrollableScrollPhysics(),shrinkWrap: true,children: [TaskLectureTiletemp(Lecture:  Session(facultyName: "free",location: "free",subjectName: "free",time: "free")),TaskLectureTiletemp(Lecture:  Session(facultyName: "free",location: "free",subjectName: "free",time: "free")) ]);

                                              }
                                            } else if (slot.isLab == true&&
                                                slot.isFullSession == false) {
                                              //for lab
                                              return TaskLectureTiletemp(Lecture: slot.lab![0]);
                                            } else if (slot.isLab == true &&
                                                slot.isFullSession == true) {
                                              // for Full Session
                                              return TaskLectureTiletemp(Lecture: slot.slotLecture!);

                                            } else {
                                              //for free lecture
                                              return TaskLectureTiletemp(Lecture: Session(facultyName: "free",location: "free",subjectName: "free",time: "free"));
                                            }
                                          },
                                        );
                                        //Container(decoration: BoxDecoration(border: Border.all(color: Colors.black)),child: Center(child: Text("${slot}"),),)


                                      } else {
                                        return Center(child: Text("null"));
                                      }
                                    },
                                  );
                                }
                                else if(state is FileDataFetchError){
                                  print("🟥🟥🟥Error $state");
                                  return SizedBox();
                                }
                                else{
                                  print("🚫🚫Other");
                                  return SizedBox();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

            ])
        )
    );
  }
}
