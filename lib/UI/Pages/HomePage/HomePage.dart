import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:student_dudes/UI/Widgets/TaskTile.dart';
import 'package:student_dudes/Util/Cubits/HomePage/animationHelperCubit.dart';

import '../../Widgets/DrawerWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<SliderDrawerState> _drwerButtonkey = GlobalKey<SliderDrawerState>();

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    ScrollController _sliverScrollController = ScrollController();
    _sliverScrollController.addListener(() {
      if (_sliverScrollController.offset >= 200 &&
          !_sliverScrollController.position.outOfRange) {
        BlocProvider.of<SliverScrolled>(context).Add();
      } else {
        BlocProvider.of<SliverScrolled>(context).clear();
      }
    });
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SliderDrawer(
          slider: SlidingDrawer(),
          key: _drwerButtonkey,
          appBar: Container(),
          isDraggable: true,
          isCupertino: true,
          animationDuration: 200,
          sliderOpenSize: deviceWidth - 80,
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(spreadRadius: 1,color: Theme.of(context).scaffoldBackgroundColor)]
            ),
            child: CustomScrollView(
              controller: _sliverScrollController,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  expandedHeight: 300,
                  leading: IconButton(
                      onPressed: () {
                        _drwerButtonkey.currentState?.toggle();
                      },
                      highlightColor: Colors.transparent,
                      icon: Icon(Icons.menu,color: Theme.of(context).iconTheme.color,)),
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
                                          style: Theme.of(context).textTheme.titleSmall)),
                                )),
                        Spacer(),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.add)),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.edit)),
                      ],
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Center(
                        child: Text("Reminder",style: Theme.of(context).textTheme.titleLarge,)),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: deviceHeight,
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: [BoxShadow(spreadRadius: 1,color: Theme.of(context).scaffoldBackgroundColor)]
                    ),
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: const [
                        TaskLectureTile(
                          Lecture: '',
                          LectureTime: '10:45 TO 12:45',
                          LectureLocation: 'E-306',
                        ),
                        TaskLectureTile(
                          Lecture: '',
                          LectureTime: '10:45 TO 12:45',
                          LectureLocation: 'E-306',
                        ),
                        TaskLectureTile(
                          Lecture: '',
                          LectureTime: '10:45 TO 12:45',
                          LectureLocation: 'E-306',
                        ),
                        TaskLectureTile(
                          Lecture: '',
                          LectureTime: '10:45 TO 12:45',
                          LectureLocation: 'L-17,18',
                        ),
                        TaskLectureTile(
                          Lecture: '',
                          LectureTime: '10:45 TO 12:45',
                          LectureLocation: 'E-306',
                        ),
                        TaskLectureTile(
                          Lecture: '',
                          LectureTime: '10:45 TO 12:45',
                          LectureLocation: 'E-306',
                        ),
                      ],
                    ),
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
                        ),
                      ),
                    ),
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
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
