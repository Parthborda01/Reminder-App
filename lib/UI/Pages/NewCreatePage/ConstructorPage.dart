
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_dudes/Data/Model/timeTableModel.dart';
import 'package:student_dudes/UI/Routes/route.dart';
import 'package:student_dudes/UI/Widgets/DialogBox/ConstructorDialogs/ConstructorDialogLab.dart';
import 'package:student_dudes/UI/Widgets/DialogBox/ConstructorDialogs/ConstructorDialogLecture.dart';
import 'package:student_dudes/UI/Widgets/ListTiles/ConstructorTileLab.dart';
import 'package:student_dudes/UI/Widgets/ListTiles/ConstructorTileLecture.dart';
import 'package:student_dudes/Util/Cubits/AnimationHelper/animationHelperCubit.dart';
import 'package:student_dudes/Util/Cubits/fileDataFetch/file_data_fetch_cubit.dart';
import 'package:student_dudes/Util/ImageHelper/PickHelper.dart';

class ConstructorPage extends StatefulWidget {
  const ConstructorPage({Key? key, required this.fileData}) : super(key: key);
  final FileData fileData;

  @override
  State<ConstructorPage> createState() => _ConstructorPageState();
}

class _ConstructorPageState extends State<ConstructorPage> {
  TimeTable? timeTable;

  List<Session> selectedItems = [];

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

    ScrollController sliverScrollController = ScrollController();
    sliverScrollController.addListener(() {
      if (sliverScrollController.offset >= 100 &&
          !sliverScrollController.position.outOfRange) {
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
                CustomScrollView(controller: sliverScrollController, slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                expandedHeight: 300,
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.pdfSelect)
                            .then((value) => Navigator.pop(context));
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: AnimatedOpacity(
                                    opacity: state ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: Text("Tasks",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall)),
                              )),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            //Todo: Save to Fire Based
                          },
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.focused)) {
                                    return Colors.white12;
                                  }
                                  if (states.contains(MaterialState.hovered)) {
                                    return Colors.white12;
                                  }
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.white12;
                                  }
                                  return Colors.white12; // Defer to the widget's default.
                                }),
                          ),
                          child: Row(
                          children: [
                          Text("Done",style: Theme.of(context).textTheme.titleSmall),
                          Icon(Icons.save_alt_rounded,color: Theme.of(context).iconTheme.color),
                        ],
                      )),
                    ],
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Center(child: BlocBuilder<SliverScrolled, bool>(
                    builder: (context, state) {
                      return AnimatedOpacity(
                        opacity: state ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 100),
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
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is FileDataFetchLoaded) {
                        timeTable = state.timeTable;
                        return PageView.builder(
                          itemCount: timeTable!.weekDays!.length,
                          itemBuilder: (BuildContext context, int indexPage) {
                            return Column(
                              children: [
                                Text(
                                    timeTable!.weekDays![indexPage].day!
                                        .toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Flexible(
                                  child: ListView.builder(
                                    itemCount: timeTable!
                                        .weekDays![indexPage].sessions!.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, indexList) {
                                      //Data to json

                                      if (!(timeTable?.weekDays?[indexPage]
                                              .sessions?[indexList].isLab ??
                                          false)) {
                                        //It's a lecture
                                        return InkWell(
                                          onLongPress: () {
                                            if (selectedItems.isEmpty) {
                                              selectedItems.add(timeTable!
                                                  .weekDays![indexPage]
                                                  .sessions![indexList]);
                                              setState(() {});
                                            }
                                          },
                                          onTap: () {
                                            if (selectedItems.isEmpty) {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      ConstructorDialogLecture(
                                                        fileData: widget.fileData,
                                                        lectureData: timeTable!
                                                                .weekDays![
                                                                    indexPage]
                                                                .sessions![
                                                            indexList],
                                                        onChanged: (session) {
                                                          timeTable!
                                                                  .weekDays![
                                                                      indexPage]
                                                                  .sessions![
                                                              indexList] = session;
                                                          setState(() {});
                                                        },
                                                      ));
                                            } else {
                                              if (selectedItems
                                                  .where((element) =>
                                                      element.id ==
                                                      timeTable!
                                                          .weekDays![indexPage]
                                                          .sessions![indexList]
                                                          .id)
                                                  .isNotEmpty) {
                                                selectedItems.removeWhere(
                                                    (element) =>
                                                        element.id ==
                                                        timeTable!
                                                            .weekDays![
                                                                indexPage]
                                                            .sessions![
                                                                indexList]
                                                            .id);
                                              } else {
                                                selectedItems.add(timeTable!
                                                    .weekDays![indexPage]
                                                    .sessions![indexList]);
                                              }
                                              setState(() {});
                                            }
                                          },
                                          child: ConstructorTileLecture(
                                            isSelected: selectedItems
                                                .where((element) =>
                                                    element.id ==
                                                    timeTable!
                                                        .weekDays![indexPage]
                                                        .sessions![indexList]
                                                        .id)
                                                .isNotEmpty,
                                            lectureData: timeTable!
                                                .weekDays![indexPage]
                                                .sessions![indexList],
                                          ),
                                        );
                                      } else {
                                        //for lab
                                        return InkWell(
                                          onLongPress: () {
                                            if (selectedItems.isEmpty) {
                                              selectedItems.add(timeTable!
                                                  .weekDays![indexPage]
                                                  .sessions![indexList]);
                                              setState(() {});
                                            }
                                          },
                                          onTap: () {
                                            if (selectedItems.isEmpty) {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      ConstructorDialogLab(
                                                        labData: timeTable!
                                                            .weekDays?[indexPage]
                                                            .sessions?[indexList],
                                                        onChanged: (p0) {
                                                          timeTable!.weekDays?[indexPage]
                                                              .sessions?[indexList] = p0;
                                                          setState(() {});
                                                        }, fileData: widget.fileData,
                                                      ));
                                            } else {
                                              if (selectedItems
                                                  .where((element) =>
                                              element.id ==
                                                  timeTable!
                                                      .weekDays![indexPage]
                                                      .sessions![indexList]
                                                      .id)
                                                  .isNotEmpty) {
                                                selectedItems.removeWhere(
                                                        (element) =>
                                                    element.id ==
                                                        timeTable!
                                                            .weekDays![
                                                        indexPage]
                                                            .sessions![
                                                        indexList]
                                                            .id);
                                              } else {
                                                selectedItems.add(timeTable!
                                                    .weekDays![indexPage]
                                                    .sessions![indexList]);
                                              }
                                              setState(() {});
                                            }
                                          },
                                          child: ConstructorTileLab(
                                            fileData: widget.fileData,
                                           isSelected: selectedItems
                                              .where((element) =>
                                            element.id ==
                                            timeTable!
                                                .weekDays![indexPage]
                                            .sessions![indexList]
                                            .id)
                                            .isNotEmpty,

                                            labData: timeTable!
                                                .weekDays?[indexPage]
                                                .sessions?[indexList],
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (state is FileDataFetchError) {
                        // print("🟥🟥🟥Error ${state.errorMessage}");
                        return const SizedBox();
                      } else {
                        // print("🚫🚫Other");
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ),
            ])));
  }
}
